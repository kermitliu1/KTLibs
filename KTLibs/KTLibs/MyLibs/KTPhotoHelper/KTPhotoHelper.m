//
//  KTPhotoHelper.m
//  KTLibs
//
//  Created by kermit on 16/10/24.
//  Copyright © 2016年 kermit. All rights reserved.
//

#import "KTPhotoHelper.h"

@interface KTPhotoHelper ()
<QBImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) DidFinishSelectPhotoCompledBlock didFinishTakeMediaCompled;

@end

@implementation KTPhotoHelper

@synthesize allowsMultipleSelection, minimumNumberOfSelection, maxmumNumberOfSelection, groupTypes, cropPhoto;

- (instancetype)init {
    self = [super init];
    if (self) {
        minimumNumberOfSelection = 0;
        maxmumNumberOfSelection  = 9;
    }
    return self;
}

- (void)dealloc {
    self.didFinishTakeMediaCompled = nil;
}

- (void)showPhotoPickerViewControllerOnViewController:(UIViewController *)viewController
                                              compled:(DidFinishSelectPhotoCompledBlock)compled {
    if (![QBImagePickerController isAccessible]) {
        compled(nil, nil);
        return;
    }
    self.didFinishTakeMediaCompled = compled;
    if (cropPhoto) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        [viewController presentViewController:imagePickerController animated:YES completion:NULL];
        navigationController = imagePickerController;
    }else{
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = allowsMultipleSelection;
        imagePickerController.minimumNumberOfSelection = minimumNumberOfSelection;
        imagePickerController.maximumNumberOfSelection = maxmumNumberOfSelection;
        imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        if(groupTypes != nil){
            imagePickerController.groupTypes = groupTypes;
        }else{
            imagePickerController.groupTypes = @[@(ALAssetsGroupSavedPhotos),
                                                 @(ALAssetsGroupPhotoStream),
                                                 @(ALAssetsGroupAlbum)];
        }
        navigationController = [[UINavigationController alloc] initWithRootViewController: imagePickerController];
        [viewController presentViewController:navigationController animated:YES completion:NULL];
    }
}

- (void)showCameraPickerViewControllerOnViewController:(UIViewController *)viewController compled:(DidFinishSelectPhotoCompledBlock)compled{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        compled(nil, nil);
        return;
    }
    self.didFinishTakeMediaCompled = compled;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = cropPhoto;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    [viewController presentViewController:imagePickerController animated:YES completion:NULL];
    navigationController = imagePickerController;
}

- (void)dismissPickerViewController:(UIViewController *)picker {
    [navigationController dismissViewControllerAnimated:YES completion:^{
        self.didFinishTakeMediaCompled = nil;
    }];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.didFinishTakeMediaCompled) {
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
            if(CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo){
                NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
                NSString *filePath = [KTPhotoHelper getTmpDirFile: @"tmp.mov"];
                NSData *movieData = [NSData dataWithContentsOfURL:mediaURL];
                [movieData writeToFile:filePath atomically:YES];
                self.didFinishTakeMediaCompled(navigationController, @[info]);
                assetsLib = [[ALAssetsLibrary alloc] init];
                [info setValue:@"kUTTypeMovie" forKey:UIImagePickerControllerMediaType];
                [assetsLib writeVideoAtPathToSavedPhotosAlbum:mediaURL completionBlock:nil];
            }else{
                // 拍照
                self.didFinishTakeMediaCompled(navigationController, @[info]);
            }
        }else{
            self.didFinishTakeMediaCompled(navigationController, @[info]);
        }
    }
    [self dismissPickerViewController:picker];
}

+ (NSString *) getTmpDir{
    return NSTemporaryDirectory();
}

+ (NSString *) getTmpDirFile:(NSString *)fileName{
    return [[self getTmpDir] stringByAppendingPathComponent: fileName];
}

- (void)imagePickerControllerDidCancel:(UIViewController *)imagePickerController{
    [self dismissPickerViewController: imagePickerController];
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    if (self.didFinishTakeMediaCompled) {
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        if(assetRepresentation == nil){
            self.didFinishTakeMediaCompled(navigationController, @[]);
        }else{
            NSDictionary *info = @{UIImagePickerControllerMediaType: @"kUTTypeImage",
                                   UIImagePickerControllerOriginalImage: [UIImage imageWithCGImage:assetRepresentation.fullResolutionImage
                                                                                             scale:assetRepresentation.scale
                                                                                       orientation:(UIImageOrientation)assetRepresentation.orientation],
                                   UIImagePickerControllerReferenceURL: assetRepresentation.url};
            self.didFinishTakeMediaCompled(navigationController, @[info]);
            [self dismissPickerViewController: imagePickerController];
        }
        
    }else{
        [self dismissPickerViewController: imagePickerController];
    }
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    if (self.didFinishTakeMediaCompled) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity: 10];
        ALAssetRepresentation *assetRepresentation = nil;
        for(ALAsset *asset in assets){
            assetRepresentation = [asset defaultRepresentation];
            if(assetRepresentation != nil){
                [datas addObject: @{UIImagePickerControllerMediaType: [asset valueForProperty: ALAssetPropertyType] == ALAssetTypePhoto ? @"kUTTypeImage" : @"kUTTypeMovie",
                                    UIImagePickerControllerOriginalImage: [UIImage imageWithCGImage:assetRepresentation.fullResolutionImage
                                                                                              scale:assetRepresentation.scale
                                                                                        orientation:(UIImageOrientation)assetRepresentation.orientation],
                                    UIImagePickerControllerReferenceURL: assetRepresentation.url}];
            }
        }
        self.didFinishTakeMediaCompled(navigationController, datas);
        [self dismissPickerViewController: imagePickerController];
    }else{
        [self dismissPickerViewController: imagePickerController];
    }
}

// 裁剪图片
- (void)cropPhotoes:(NSArray *)mediaInfoes{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoHelper" bundle: [NSBundle mainBundle]];
    KTCropPhotoViewController *cropV = [storyboard instantiateViewControllerWithIdentifier: @"KTCropPhotoViewController"];
    cropV.mediaInfoes = mediaInfoes;
    [navigationController pushViewController:cropV animated:YES];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissPickerViewController: imagePickerController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
