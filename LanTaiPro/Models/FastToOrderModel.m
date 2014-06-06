//
//  FastToOrderModel.m
//  LanTaiPro
//
//  Created by lantan on 14-6-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "FastToOrderModel.h"

@implementation FastToOrderModel
+(NSDictionary *)mts_mapping
{
    return @{
             @"id":mts_key(serviceId),
             @"name":mts_key(serviceName),
             @"price":mts_key(price)
             };
}
@end
