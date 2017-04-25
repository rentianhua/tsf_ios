//
//  TSFNewRoomCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/25.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFNewRoomCell.h"
#import "OtherHeader.h"



@implementation TSFNewRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgViewW.constant=kMainScreenWidth*0.28;
    self.imgViewH.constant=kMainScreenWidth*0.28*130/173;
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
}

- (void)drawRect:(CGRect)rect{
    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:0.5].CGColor);
    CGContextStrokeRect(contextRef, CGRectMake(15, rect.size.height-0.5, rect.size.width-30, 0.5));
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
