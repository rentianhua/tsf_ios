//
//  TSFXiaoQuAnnonation.m
//  TaoShenFang
//
//  Created by YXM on 16/10/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFXiaoQuAnnonation.h"

@implementation TSFXiaoQuAnnonation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize titlelable = _titlelable;
@synthesize coordinate = _coordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.coordinate = coordinate;
    }
    return self;
}

@end
