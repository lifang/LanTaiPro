
//
//  SearchOrder.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SearchOrder.h"

@implementation SearchOrder

+ (NSDictionary*)mts_mapping
{
    return  @{@"car_num_id": mts_key(car_num_id),
              @"code": mts_key(code),
              @"created_at": mts_key(created_at),
              @"id": mts_key(order_id),
              @"name": mts_key(name),
              @"price": mts_key(price),
              @"status": mts_key(status),
              @"products":mts_key(productList),
              @"payType":mts_key(payType),
              @"staff_name":mts_key(staff_name),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(productList) : SearchProduct.class,
             };
}

@end
