//
//  UIImage+UIImageScale.h
//  TaoShenFang
//
//  Created by YXM on 16/9/28.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageScale)
-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)scaleToSize:(CGSize)size;
@end
