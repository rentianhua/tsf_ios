//
//  UILabel+TSF.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/19.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "UILabel+TSF.h"

@implementation UILabel (TSF)

- (void)setparagraphText:(NSString *)text{
    if (text==nil || text.length==0) {
        return;
    }
    NSMutableAttributedString * attributedStr=[[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.attributedText=attributedStr;

}
@end
