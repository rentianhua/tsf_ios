//
//  ShowingsViewController.h
//  TaoShenFangTest
//
//  Created by sks on 16/6/19.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSInteger,SegmentSelect){
  SegmentSelectLeft=0,
  SegmentSelectRight,
    //更多
};
@interface ShowingsViewController : BaseViewController

@property (nonatomic, assign)SegmentSelect select;

@end
