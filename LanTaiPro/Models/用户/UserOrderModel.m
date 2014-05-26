//
//  UserOrderModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "UserOrderModel.h"

@implementation UserOrderModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"order_count": mts_key(orderCount),
              @"has_pay": mts_key(orderMoney),
              @"orders_now": mts_key(orderNowList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(orderNowList) : UserNowOrderModel.class};
}

@end
