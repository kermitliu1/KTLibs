//
//  KTCropPhotoViewController.m
//  KkxLibs
//
//  Created by kermit on 16/10/24.
//  Copyright © 2016年 kermit. All rights reserved.
//

#import "KTCropPhotoViewController.h"
#import "PECropView.h"

@interface KTCropPhotoViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong)PECropView *cropView;

@property(nonatomic, strong)NSMutableArray *photoes;

@end

@implementation KTCropPhotoViewController

@synthesize mediaInfoes;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    for(NSDictionary *info in mediaInfoes){
        if([[info objectForKey: UIImagePickerControllerMediaType] isEqualToString: @"kUTTypeImage"]){
            [_photoes addObject: info];
        }
    }
    self.cropView = [[PECropView alloc] initWithFrame: CGRectMake(0, 0,
                                                                  CGRectGetWidth(self.view.frame),
                                                                  CGRectGetHeight(self.view.frame) - 54)];
    self.cropView.rotationGestureRecognizer.enabled = YES;
    self.cropView.cropAspectRatio = 1.0f; // 1.0f
    [self.view addSubview: _cropView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _photoes = [NSMutableArray arrayWithCapacity: 1];
}
#pragma mark UICollectionViewDelegate, UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_photoes count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CELL";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell viewWithTag: 1];
    NSDictionary *info = _photoes[indexPath.row];
    imgView.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    return cell;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = _photoes[indexPath.row];
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    self.cropView.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    self.cropView.imageCropRect = CGRectMake((width - length) / 2,
                                             (height - length) / 2,
                                             length,
                                             length);
    [self.cropView resetCropRect];
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
