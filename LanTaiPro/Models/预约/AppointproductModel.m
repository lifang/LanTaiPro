//
//  AppointproductModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-21.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "AppointproductModel.h"

@implementation AppointproductModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"id": mts_key(a_p_id),
              @"base_price": mts_key(a_p_basePrice),
              @"is_service": mts_key(a_p_isService),
              @"name": mts_key(a_p_name),
              @"reservation_id": mts_key(a_p_reservationId),
              @"sale_price": mts_key(a_p_salePrice),
              @"types": mts_key(a_p_types),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}


@end
