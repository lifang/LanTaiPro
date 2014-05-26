//
//  AppointModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-21.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "AppointModel.h"

@implementation AppointModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"num": mts_key(appointCarNum),
              @"car_model_name": mts_key(appointCarName),
              @"name": mts_key(appointUserName),
              @"mobilephone": mts_key(appointUserPhone),
              @"is_vip": mts_key(appointUserVip),
              @"email": mts_key(appointUserEmail),
              @"customer_id": mts_key(appointUserId),
              @"id": mts_key(appointId),
              @"created_at": mts_key(appointCreatTime),
              @"status": mts_key(appointStatus),
              @"res_time": mts_key(appointResTime),
              @"products": mts_key(appointProductList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(appointProductList) : AppointproductModel.class};
}

@end
