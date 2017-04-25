//
//  TSFUploadImgVC.h
//  TaoShenFang
//
//  Created by YXM on 16/10/27.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^PicsBlock) (NSMutableArray * pics);

@interface TSFUploadImgVC : BaseViewController


@property (nonatomic,copy)PicsBlock picsBlock;

@property (nonatomic,copy)NSMutableArray * pics;

@property (nonatomic) int maxImagesCount;
@property (nonatomic) BOOL isPersonIDCardUpload;
@end
