//
//  CarModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel
+ (NSDictionary *)mts_mapping
{
    return  @{
              @"car_id": mts_key(car_id),
              @"car_num": mts_key(carPlateNumber),
              @"order_id": mts_key(order_id),
              @"service_name": mts_key(serviceName),
              @"wo_status":mts_key(work_status),
              @"wo_id":mts_key(workOrder_id),
              @"station_id":mts_key(station_id),
              @"wo_started_at":mts_key(serviceStartTime),
              @"wo_ended_at":mts_key(serviceEndTime),
              @"cost_time":mts_key(cost_time)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}


@end
