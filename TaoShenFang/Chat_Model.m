//
//  Chat_Model.m
//  Chat_V
//
//  Created by BOBO on 16/12/2.
//  Copyright © 2016年 BOBO. All rights reserved.
//

#import "Chat_Model.h"

@implementation Chat_Model

+ (NSArray *)demoData {
    Chat_Model *message1 = [[Chat_Model alloc] init];
    message1.content = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
    message1.fromMe = YES;
    Chat_Model *message2 = [[Chat_Model alloc] init];
    message2.content = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
    message2.fromMe = NO;
    Chat_Model *message3 = [[Chat_Model alloc] init];
    message3.content = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
    message3.fromMe = YES;
    Chat_Model *message4 = [[Chat_Model alloc] init];
    message4.content = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
    message4.fromMe = NO;
    Chat_Model *message5 = [[Chat_Model alloc] init];
    message5.content = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
    message5.fromMe = YES;
    Chat_Model *message6 = [[Chat_Model alloc] init];
    message6.content = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
    message6.fromMe = NO;
    Chat_Model *message7 = [[Chat_Model alloc] init];
    message7.content = @"测试数据";
    message7.fromMe = YES;
    Chat_Model *message8 = [[Chat_Model alloc] init];
    message8.content = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
    message8.fromMe = NO;
    
    return @[message1, message2, message3, message4, message5, message6, message7, message8];
}

@end
