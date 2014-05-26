//
//  UserNowOrderProductModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "UserNowOrderProductModel.h"

@implementation UserNowOrderProductModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"name": mts_key(p_name),
              @"order_id": mts_key(p_orderId),
              @"price": mts_key(p_price),
              @"pro_num": mts_key(p_number),
              @"t_price": mts_key(p_t_price),
              @"total_price": mts_key(p_totalPrice),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}


@end
