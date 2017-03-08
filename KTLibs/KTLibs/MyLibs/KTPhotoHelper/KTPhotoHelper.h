//
//  KTPhotoHelper.h
//  KTLibs
//
//  Created by kermit on 16/10/24.
//  Copyright © 2016年 kermit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "QBImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/ALAsset.h>
#import "KTCropPhotoViewController.h"

typedef void(^DidFinishSelectPhotoCompledBlock) (UIViewController *picker, NSArray *mediaInfoes);

@interface KTPhotoHelper : UIViewController
<QBImagePickerControllerDelegate>
{
    //  是否允许多选，默认允许
    BOOL allowsMultipleSelection;
    //  允许选择的最小数量，默认0
    int minimumNumberOfSelection;
    //  允许选择的最大数量，默认9
    int maxmumNumberOfSelection;
    UINavigationController *navigationController;
    ALAssetsLibrary *assetsLib;
}


@property(nonatomic, assign) BOOL allowsMultipleSelection;
@property(nonatomic, assign) int minimumNumberOfSelection;
@property(nonatomic, assign) int maxmumNumberOfSelection;
@property(nonatomic, assign) NSArray *groupTypes;
@property(nonatomic, assign) BOOL cropPhoto;

//  从相册中选择图片
- (void)showPhotoPickerViewControllerOnViewController:(UIViewController *)viewController compled:(DidFinishSelectPhotoCompledBlock)compled;

//  拍照
- (void)showCameraPickerViewControllerOnViewController:(UIViewController *)viewController compled:(DidFinishSelectPhotoCompledBlock)compled;

@end
