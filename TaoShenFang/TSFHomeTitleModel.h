//
//  TSFHomeTitleModel.h
//  TaoShenFang
//
//  Created by YXM on 16/12/21.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSFHomeTitleModel : NSObject

/*[{"id":"51","varname":"zhubiaoti","info":"首页主标题","groupid":"1","value":"聚焦深圳总价200万以下房源"},{"id":"52","varname":"fubiaoti","info":"首页副标题","groupid":"1","value":"永久免费 深圳不动产自主交易中心"}]*/

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *info;
@property (nonatomic,copy)NSString *value;


@end
