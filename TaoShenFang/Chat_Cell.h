//
//  Chat_Cell.h
//  Chat_V
//
//  Created by BOBO on 16/12/2.
//  Copyright © 2016年 BOBO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chat_Model.h"
@interface Chat_Cell : UITableViewCell
//头像
@property (nonatomic, strong) UIImageView *iconImageView;
//模型 赋值
@property (strong,nonatomic)Chat_Model * chat_M;

// 气泡
@property (nonatomic, strong) UIImageView *popImageView;
// 聊天内容
@property (nonatomic, strong) UILabel *popLabel;


@property (nonatomic,strong) UILabel * timeLabel;

@end
