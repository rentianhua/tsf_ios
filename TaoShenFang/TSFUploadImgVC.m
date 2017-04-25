//
//  TSFUploadImgVC.m
//  TaoShenFang
//
//  Created by YXM on 16/10/27.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFUploadImgVC.h"
#import "OtherHeader.h"
#import <UIImageView+WebCache.h>
#import "UIImage+UIImageScale.h"
#import <MJExtension.h>
#import "MyCollectionCell.h"
#import "AddCollectionCell.h"
#import "KSAlertView.h"
#import "YJProgressHUD.h"
#import "UploadImgModel.h"//上传图片 返回的数据模型
#import "TSFPicsModel.h"//发布 图片所需的模型
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "QBImagePicker.h"

#define NAVBTNW 20
#define CELL @"cell"
#define ADDCELL @"addcell"
#define ITEMSIZEW (kMainScreenWidth-40)/3
#define ITEMSIZEH ITEMSIZEW+30

@interface TSFUploadImgVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UITextFieldDelegate, QBImagePickerControllerDelegate>

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) UIImage *willUploadImage;
@property (nonatomic, strong) NSArray *willUploadAssets;
@property (nonatomic) int curUploadIndex;
@end

@implementation TSFUploadImgVC

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (UIButton *)rightNavBtn{
    if (_rightNavBtn==nil) {
        _rightNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW*2, NAVBTNW)];
        [_rightNavBtn setTitle:@"上传" forState:UIControlStateNormal];
        [_rightNavBtn setTitleColor:DESCCOL forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
}

- (void)setPics:(NSMutableArray *)pics{
    _pics=pics;
}

- (UICollectionView * )collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout * flowLayout=[[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.autoresizingMask = 0xff;
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerNib:[UINib nibWithNibName:@"MyCollectionCell" bundle:nil] forCellWithReuseIdentifier:CELL];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"AddCollectionCell" bundle:nil] forCellWithReuseIdentifier:ADDCELL];
    }
    return _collectionView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if(self.maxImagesCount<=0)
    {
        if(self.isPersonIDCardUpload)
        {
            self.maxImagesCount = 3;
        }
        else
        {
            self.maxImagesCount = 30;
        }
    }
    self.navigationItem.title=@"上传图片";
    self.pics=[self.pics mutableCopy];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    [self.view addSubview:self.collectionView];
}

- (void)showActionSheetForUploadImage{//上传图片的弹框
    if (IOS8) {
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction * cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * photo=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openCamera];
        }];
        UIAlertAction * album=[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openAlbum];
        }];
        [alertController addAction:photo];
        [alertController addAction:album];
        [alertController addAction:cancle];
        [self presentViewController:alertController animated:YES completion:nil];
    } else{//iOS7及以下版本
        UIActionSheet * sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相机中选择", nil];
        [sheet showInView:self.view];
    }
    //[YJProgressHUD showMessage:@"横向拍照，图片效果更佳" inView:self.view];
}

#pragma mark------UICollectionViewDelegate/UICollectionViewDataSource--
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.pics.count>=self.maxImagesCount)
        return self.pics.count;
    return self.pics.count+1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<self.pics.count) {
        MyCollectionCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:CELL forIndexPath:indexPath];
        
        TSFPicsModel * model=self.pics[indexPath.row];
        [cell.imgView setClipsToBounds:YES];
        [cell.imgView setContentMode:UIViewContentModeScaleAspectFill];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.url]] placeholderImage:[UIImage imageNamed:@"card_default"]];
        cell.textField.text=model.alt;
        cell.textField.tag=indexPath.row;
        cell.textField.returnKeyType=UIReturnKeyDone;
        cell.textField.delegate=self;
        [cell.textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.deleteButton addTarget:self action:@selector(delectAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }  else{
        AddCollectionCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:ADDCELL forIndexPath:indexPath];
        return cell;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldEditChanged:(UITextField *)textField{
    TSFPicsModel * model=self.pics[textField.tag];
    model.alt=textField.text;
    [self.pics replaceObjectAtIndex:textField.tag withObject:model];
}

- (void)delectAction:(UIButton *)button{
    
    MyCollectionCell * cell=(MyCollectionCell *)button.superview.superview;
    NSIndexPath * indexPath=[self.collectionView indexPathForCell:cell];
    [self.pics removeObjectAtIndex:indexPath.row];
    
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ITEMSIZEW, ITEMSIZEH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//collectionView可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.pics.count) {
        if (self.pics.count==10) {
            [KSAlertView showWithTitle:@"提示" message1:@"已经是最后一张了" cancelButton:@"确定"];
        } else{
            
            [self showActionSheetForUploadImage];
            
            //[self openAlbum];
        }
    }
}

+ (void)showNeedCameraAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机"
                                                    message:@"请在iPhone的\"设置-通用-访问限制-相机\"中允许访问相机"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)showNeedPhotosAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相册"
                                                    message:@"请在iPhone的\"设置-通用-访问限制-照片\"中允许访问相机"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)openCamera
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [TSFUploadImgVC showNeedCameraAlert];
        return;
    }
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined)
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else
    {
        [TSFUploadImgVC showNeedCameraAlert];
    }
}

- (void)openAlbum
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [TSFUploadImgVC showNeedPhotosAlert];
        return;
    }
    
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
    {
        [TSFUploadImgVC showNeedCameraAlert];
        return;
    }
    
    if(self.assetsLibrary == nil)
        self.assetsLibrary = [ALAssetsLibrary new];
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init:self.assetsLibrary];
    imagePickerController.delegate = self;
    imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.maximumNumberOfSelection = self.maxImagesCount-[self.pics count]>0?self.maxImagesCount-[self.pics count]:0;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    if(assets && assets.count>0)
    {
        self.willUploadAssets = assets;
        self.curUploadIndex = 0;
        self.willUploadImage = nil;
        //开始上传
        [self gotoUploadImage];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    __weak typeof(self)weakSelf=self;
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        weakSelf.willUploadAssets = nil;
        weakSelf.curUploadIndex = -1;
        weakSelf.willUploadImage = portraitImg;
        //开始上传
        [weakSelf gotoUploadImage];
    }];
}

- (void)gotoUploadImage
{
    if(self.willUploadImage || (self.willUploadAssets && self.willUploadAssets.count>0))
    {
        if(self.willUploadImage)
        {
            [YJProgressHUD showProgress:@"正在上传中" inView:self.view];
            [self uploadNextImage:self.willUploadImage];
        }
        else
        {
            if(self.willUploadAssets && self.willUploadAssets.count>0)
            {
                if(self.curUploadIndex <= 0)
                {
                    self.curUploadIndex = 0;
                    [YJProgressHUD showProgress:@"正在上传中" inView:self.view];
                }
                if(self.curUploadIndex<self.willUploadAssets.count)
                {
                    ALAsset *item = [self.willUploadAssets objectAtIndex:self.curUploadIndex];
                    if([item isKindOfClass:[ALAsset class]])
                    {
                        ALAsset *t = (ALAsset *)item;
                        UIImage *img = [UIImage imageWithCGImage:[[t defaultRepresentation] fullScreenImage]];
                        if(img)
                        {
                            [self uploadNextImage:img];
                        }
                        else
                        {
                            self.willUploadAssets = nil;
                            self.curUploadIndex = -1;
                            self.willUploadImage = nil;
                            [YJProgressHUD hide];
                        }
                    }
                }
                else
                {
                    //上传结束
                    self.willUploadAssets = nil;
                    self.curUploadIndex = -1;
                    self.willUploadImage = nil;
                    [YJProgressHUD hide];
                }
            }
            else
            {
                self.willUploadAssets = nil;
                self.curUploadIndex = -1;
                self.willUploadImage = nil;
                [YJProgressHUD hide];
            }
        }
    }
    else
    {
        self.willUploadAssets = nil;
        self.curUploadIndex = -1;
        self.willUploadImage = nil;
        [YJProgressHUD hide];
    }
}

- (void)uploadNextImage:(UIImage *)image
{
    __weak typeof(self)weakSelf=self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"image/jpeg",
                                                         @"text/html",
                                                         @"image/png",
                                                         nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSNumber * userid=NSUSER_DEF(USERINFO)[@"userid"];
    NSDictionary * params=@{@"userid":userid,
                            @"catid":self.isPersonIDCardUpload?@"52":@"6",
                            @"thumb_width":@"600",
                            @"thumb_height":@"400",
                            @"watermark_enable":@"0",
                            @"module":@"text"};
    [manager POST:[NSString stringWithFormat:@"%@g=api&m=user&a=uploadimg",URLSTR] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage * resultImg=nil;
        UIImage * transImage = [weakSelf fixOrientation:image];
        if (image.size.width<image.size.height) {
            if(self.isPersonIDCardUpload)
                resultImg = transImage;
            else
                resultImg=[weakSelf tailorImage:transImage];
        } else{
            resultImg=image;
        }
        NSData *imageData = UIImageJPEGRepresentation(resultImg, 0.6);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"pic"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL uploadSuccess = NO;
        if (responseObject)
        {
            NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dict)
            {
                UploadImgModel * imgModel=[UploadImgModel mj_objectWithKeyValues:dict];
                TSFPicsModel * picmodel=[[TSFPicsModel alloc]init];
                picmodel.url=imgModel.url;
                picmodel.alt=imgModel.picname;
                
                if (weakSelf.pics==nil)
                {//如果直接点击发布 没有图片传过来 先得初始化数组
                    weakSelf.pics=[NSMutableArray arrayWithCapacity:0];
                }
                
                [weakSelf.pics addObject:picmodel];
                [weakSelf.collectionView reloadData];
                
                uploadSuccess = YES;
            }
        }
        if(uploadSuccess)
        {
            if(weakSelf.willUploadImage)
            {//一张图片
                weakSelf.willUploadAssets = nil;
                weakSelf.curUploadIndex = -1;
                weakSelf.willUploadImage = nil;
                [YJProgressHUD hide];
            }
            else
            {
                self.curUploadIndex++;
                [weakSelf gotoUploadImage];
            }
        }
        else
        {
            weakSelf.willUploadAssets = nil;
            weakSelf.curUploadIndex = -1;
            weakSelf.willUploadImage = nil;
            
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"图片上传失败，请检查网络" inView:weakSelf.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.willUploadAssets = nil;
        weakSelf.curUploadIndex = -1;
        weakSelf.willUploadImage = nil;
        
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//裁剪图片
- (UIImage *)tailorImage:(UIImage *)image{
    CGFloat imgW=kMainScreenWidth;
    CGFloat imgH=kMainScreenWidth*2/3;
    
    UIImage * successImage;
    CGSize size;
    size.width=imgW;
    size.height=(size.width*image.size.height)/image.size.width;
    
    
    CGFloat srcRadio=image.size.height/image.size.width;//2:1
    CGFloat desRadio=imgH/imgW; //2:3
    
    CGRect rect;
    if (srcRadio>desRadio) {//截上下
        
        CGFloat imageH=image.size.width*2/3;
        
        rect.size.height=imageH;
        rect.size.width=image.size.width;
        rect.origin.x=0;
        rect.origin.y = (image.size.height - imageH)/2.0;
        successImage = [image getSubImage:rect];
        
        
    } else if (srcRadio < desRadio) {//截左右，高一致
        CGFloat ratio = image.size.height/imgH;
        rect.size.width = imgW * ratio;
        rect.size.height = image.size.height ;
        rect.origin.x =(image.size.width - imgW)/2.0;
        rect.origin.y =  0;
        successImage= [image getSubImage:rect];
        
    } else {
        successImage = image;//得到的图片的长宽比与iamgeView的长宽比一致，不用裁剪
    }
    return successImage;
}

- (void)uploadAction:(UIButton *)rightBarBtn{
    
    NSMutableArray * pics=[TSFPicsModel mj_keyValuesArrayWithObjectArray:_pics];
    
    self.picsBlock(pics);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back:(UIBarButtonItem *)barButton{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
