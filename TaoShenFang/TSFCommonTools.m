//
//  TSFCommonTools.m
//  TaoShenFang
//
//  Created by YXM on 16/11/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFCommonTools.h"

@implementation TSFCommonTools

+ (NSMutableDictionary *)VEComponentsStringToDic:(NSString*)AllString withSeparateString:(NSString *)FirstSeparateString AndSeparateString:(NSString *)SecondSeparateString{

    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    NSArray *FirstArr=[AllString componentsSeparatedByString:FirstSeparateString];
 
    for (int i=0; i<FirstArr.count; i++) {
        
        NSString *Firststr=FirstArr[i];
        
        NSArray *SecondArr=[Firststr componentsSeparatedByString:SecondSeparateString];
        
        [dic setObject:SecondArr[1] forKey:SecondArr[0]];
        

    }

    return dic;
    
}


@end
