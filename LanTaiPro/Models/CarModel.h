//
//  CarModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 * 汽车
 * 功能－－数据模型
 */
@interface CarModel : NSObject

///
@property (nonatomic, strong) NSString *car_id;
@property (nonatomic, strong) NSString *carPlateNumber;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *station_id;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSString *lastTime;
@property (nonatomic, strong) NSString *workOrder_id;
@property (nonatomic, strong) NSString *serviceStartTime;
@property (nonatomic, strong) NSString *serviceEndTime;
@property (nonatomic, strong) NSString *status;

@end
