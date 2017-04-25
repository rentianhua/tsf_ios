//
//  RentDetailBasicCell.m
//  TaoShenFang
//
//  Created by YXM on 16/9/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "RentDetailBasicCell.h"
#import "HouseModel.h"

@implementation RentDetailBasicCell

- (void)configCellWithModel:(HouseModel *)model{
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString * string1=[NSString stringWithFormat:@"特点：%@",model.biaoqian];
    [_label1 setAttributedText:[self string:string1 len:3]];
    NSString * string2=[NSString stringWithFormat:@"楼层：%@/%@",model.ceng,model.zongceng];
    [_label2 setAttributedText:[self string:string2 len:3]];
    NSString * string3=[NSString stringWithFormat:@"朝向：%@",model.chaoxiang];
    [_label3 setAttributedText:[self string:string3 len:3]];
    NSString * string4=[NSString stringWithFormat:@"装修：%@",model.zhuangxiu];
    [_label4 setAttributedText:[self string:string4 len:3]];
    NSString * string5=[NSString stringWithFormat:@"位置：%@ %@",model.cityname,model.areaname];
    [_label5 setAttributedText:[self string:string5 len:3]];
    NSString * string6=[NSString stringWithFormat:@"面积：%@平米",model.mianji];
    [_label6 setAttributedText:[self string:string6 len:3]];
    NSString * string7=nil;
    if ([model.shi isEqualToString:@"6"]) {
        string7=[NSString stringWithFormat:@"户型：5室以上%@厅%@卫",model.ting,model.wei];
    } else{
        string7=[NSString stringWithFormat:@"户型：%@室%@厅%@卫",model.shi,model.ting,model.wei];
    }
    
    [_label7 setAttributedText:[self string:string7 len:3]];
    NSString * string8=[NSString stringWithFormat:@"方式：%@",model.zulin];
    [_label8 setAttributedText:[self string:string8 len:3]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.updatetime integerValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    
    NSString * string9=[NSString stringWithFormat:@"发布：%@",confromTimespStr];
    [_label9 setAttributedText:[self string:string9 len:3]];
    
    
    if (model.ditiexian.length!=0) {
        NSArray * strArr=[model.ditiexian componentsSeparatedByString:@","];
        NSMutableArray * reArr=[NSMutableArray array];
        for ( int i=0; i<strArr.count; i++) {
            NSString * str=strArr[i];
            NSString * restr=[NSString stringWithFormat:@"%@号线",str];
            [reArr addObject:restr];
        }
        NSString * string10=[NSString stringWithFormat:@"地铁：%@", [reArr componentsJoinedByString:@","]];
        [_label10 setAttributedText:[self string:string10 len:3]];
    } else{
        NSString * str=@"地铁：";
        [_label10 setAttributedText:[self string:str len:3]];
    }
    
    NSString * string11=[NSString stringWithFormat:@"小区：%@",model.xiaoquname];
    [_label11 setAttributedText:[self string:string11 len:3]];
    
    NSString * string12=[NSString stringWithFormat:@"房源编号：%@",model.bianhao];
    [_label12 setAttributedText:[self string:string12 len:5]];
}
- (NSMutableAttributedString *)string:(NSString *)string len:(NSInteger)len{
    
    NSMutableAttributedString * attrStr1=[[NSMutableAttributedString alloc]initWithString:string];
    [attrStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, len)];
    [attrStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(len, string.length-len)];
    [attrStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.length)];
    
    return attrStr1;
}

@end
