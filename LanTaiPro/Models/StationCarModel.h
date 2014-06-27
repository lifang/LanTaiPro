//
//  StationCarModel.h
//  LanTaiPro
//
//  Created by lantan on 14-6-9.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationCarModel : NSObject

@property (strong, nonatomic) NSString *car_id;
@property (strong, nonatomic) NSString *carPlateNumber;
@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSString *station_id;
@property (strong, nonatomic) NSString *serviceName;
@property (strong, nonatomic) NSString *lastTime;
@property (strong, nonatomic) NSString *workOrder_id;
@property (strong, nonatomic) NSString *serviceStartTime;
@property (strong, nonatomic) NSString *serviceEndTime;
@property (strong, nonatomic) NSString *work_status;
@property (strong, nonatomic) NSString *cost_time;
@property (strong, nonatomic) NSString *status;

@end
