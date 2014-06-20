//
//  StationCarModel.m
//  LanTaiPro
//
//  Created by lantan on 14-6-9.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "StationCarModel.h"

@implementation StationCarModel

+(NSDictionary *)mts_mapping
{
    return @{
             @"car_id":mts_key(car_id),
             @"car_num":mts_key(carPlateNumber),
             @"cost_time":mts_key(cost_time),
             @"order_id":mts_key(order_id),
             @"service_name":mts_key(serviceName),
             @"station_id":mts_key(station_id),
//             @"status":mts_key(work_status),
             @"wo_ended_at":mts_key(serviceEndTime),
             @"wo_id":mts_key(workOrder_id),
             @"wo_started_at":mts_key(serviceStartTime),
             @"wo_status":mts_key(work_status)
             };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
