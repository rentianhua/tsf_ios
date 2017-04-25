//
//  TSFAvgModel.h
//  TaoShenFang
//
//  Created by YXM on 16/12/28.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSFAvgModel : NSObject

/*[{
	"id": "5",
	"month": "11",
	"avg_price": "47682",
	"avg_price_o": "2",
	"avg_percent": "0.5",
	"avg_percent_o": "1",
	"house_percent": "2.1",
	"house_percent_o": "2",
	"comp_count": "5506",
	"comp_count_o": "2",
	"view_count": "1282",
	"view_count_o": "1"
 }]*/

@property (nonatomic,copy)NSString *month;
@property (nonatomic,copy)NSString *avg_price;
@property (nonatomic,copy)NSString *comp_count;


@end
