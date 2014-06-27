//
//  OldOrderModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-27.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "OldOrderModel.h"

@implementation OldOrderModel

+ (NSDictionary*)mts_mapping
{
    return  @{
              @"old_orders": mts_key(oldOrderList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
+ (NSDictionary*)mts_arrayClassMapping
{
    return @{
             mts_key(oldOrderList) : SearchOrder.class,
             };
}

@end
