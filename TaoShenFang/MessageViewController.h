//
//  MessageViewController.h
//  Framework
//
//  Created by lvtingyang on 16/2/22.
//  Copyright © 2016年 Framework. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, MessageType){
    
    MessageTypeNoBack = 0,
    MessageTypeBack,
    //更多
};
@interface MessageViewController : BaseViewController

@property (nonatomic, assign)MessageType type;

@end
