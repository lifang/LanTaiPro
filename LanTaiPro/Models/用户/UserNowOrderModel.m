//
//  UserNowOrderModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "UserNowOrderModel.h"

@implementation UserNowOrderModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"id": mts_key(orderId),
              @"code": mts_key(orderCode),
              @"num": mts_key(orderNum),
              @"sum_price": mts_key(orderPrice),
              @"detail": mts_key(productList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(productList) : UserNowOrderProductModel.class};
}

@end
