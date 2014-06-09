//
//  CarModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"capital_arr": mts_key(carList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(carList) : CapitalModel.class,
             };
}
@end
