//
//  TSFCommentModel.h
//  TaoShenFang
//
//  Created by YXM on 16/11/4.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSFCommentModel : NSObject

@property (nonatomic,strong)NSNumber *ID;
@property (nonatomic,copy)NSString *comment_id;
@property (nonatomic,copy)NSString *author_ip;
@property (nonatomic,copy)NSString *date;
@property (nonatomic,copy)NSString *approved;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *author;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *userpic;

@end
