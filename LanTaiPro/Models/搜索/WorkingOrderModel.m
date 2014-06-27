//
//  WorkingOrderModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-27.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "WorkingOrderModel.h"

@implementation WorkingOrderModel

+ (NSDictionary*)mts_mapping
{
    return  @{
              @"working_orders": mts_key(workingOrderList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
+ (NSDictionary*)mts_arrayClassMapping
{
    return @{
             mts_key(workingOrderList) : SearchOrder.class,
             };
}

@end
