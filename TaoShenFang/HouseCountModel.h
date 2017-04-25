//
//  HouseCountModel.h
//  TaoShenFang
//
//  Created by YXM on 16/10/12.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseCountModel : NSObject
/*id": "2",
	"pid": "1",
	"name": "\u7f57\u6e56\u533a",
	"cid": "01",
	"house_count": "33"*/
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *cid;
@property (nonatomic,copy)NSString *house_count;


@end
