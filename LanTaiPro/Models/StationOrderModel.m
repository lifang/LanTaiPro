//
//  StationOrderModel.m
//  LanTaiPro
//
//  Created by lantan on 14-6-3.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "StationOrderModel.h"

@implementation StationOrderModel


+ (NSDictionary *)mts_mapping
{
    return @{
             @"code": mts_key(order_code),
             @"name":mts_key(customer_name),
             @"num":mts_key(car_num),
             @"mobilephone":mts_key(customer_phone),
             @"car_model_name":mts_key(car_model),
             @"car_brand_name":mts_key(car_brand),
             @"buy_year":mts_key(car_year),
             @"sex":mts_key(customer_sex),
             @"distance":mts_key(car_distance),
             @"group_name":mts_key(customer_group),
             @"order_pro":mts_key(order_pro),
             @"used_staffs":mts_key(used_staffs),
             @"staff_store":mts_key(staff_store),
             @"property":mts_key(customer_property),
             @"id":mts_key(order_id),
             @"vin_code":mts_key(car_vin)
             };
    
}
+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}


@end
