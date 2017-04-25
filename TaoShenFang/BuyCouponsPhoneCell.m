//
//  BuyCouponsPhoneCell.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/26.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "BuyCouponsPhoneCell.h"
#import "OtherHeader.h"
@implementation BuyCouponsPhoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSString * str=@"手机号";
        NSDictionary * attr=@{NSFontAttributeName:[UIFont systemFontOfSize:17]};
        CGSize strSize=[str sizeWithAttributes:attr];
        
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, strSize.width, self.bounds.size.height)];
        label.font=[UIFont systemFontOfSize:17];
        label.textColor=[UIColor blackColor];
        [self addSubview:label];
        self.label=label;
        
        
        UITextField * textField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, 0, kMainScreenWidth-strSize.width-2*10, self.bounds.size.height)];
        [textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:textField];
        self.textField=textField;
        
        UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton * testButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 80, 30)];
        [testButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [testButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [testButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        testButton.layer.cornerRadius=2;
        testButton.clipsToBounds=YES;
        testButton.layer.borderColor=[UIColor redColor].CGColor;
        testButton.layer.borderWidth=1;
        [bgView addSubview:testButton];
        //[testButton addTarget:self action:@selector(testNunClick) forControlEvents:UIControlEventTouchUpInside];
        textField.rightView=bgView;
        textField.rightViewMode=UITextFieldViewModeAlways;
        
        
        
        
    }
    return self;
}



@end
