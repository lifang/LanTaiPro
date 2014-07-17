//
//  OrderInfoObject.m
//  LanTaiPro
//
//  Created by comdosoft on 14-7-9.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "OrderInfoObject.h"

@implementation OrderInfoObject
+ (NSDictionary*)mts_mapping
{
    return  @{
              @"name": mts_key(name),
              @"phone": mts_key(phone),
              @"code": mts_key(code),
              @"car_num": mts_key(carNum),
              @"created_time": mts_key(creatTime),
              @"status": mts_key(status),
              @"pro_name": mts_key(proNames),
              @"total_price": mts_key(totalPrice),
              @"car_num_id": mts_key(carNumId),
              @"customer_id": mts_key(customerId),
              @"order_id": mts_key(orderId),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
