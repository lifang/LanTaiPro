//
//  StationOrderModel.h
//  LanTaiPro
//
//  Created by lantan on 14-6-3.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 orderInfoView的数据模型，
 保存对应订单客户信息
 */

@interface StationOrderModel : NSObject
///订单对应门店id
@property (nonatomic, strong) NSString * store_id;
///订单id
@property (nonatomic, strong) NSString * order_id;
//订单code
@property (nonatomic, strong) NSString * order_code;
//订单对应用户姓名
@property (nonatomic, strong) NSString * customer_name;
//车牌
@property (nonatomic, strong) NSString * car_num;
//电话
@property (nonatomic, strong) NSString * customer_phone;
///订单对应车牌id
@property (nonatomic, strong) NSString * car_num_id;
///订单对应车品牌
@property (nonatomic, strong) NSString * car_brand;
//订单对应车型号
@property (nonatomic, strong) NSString * car_model;
///订单对应车购买年份
@property (nonatomic, strong) NSString * car_year;
///订单对应用户属性
@property (nonatomic, strong) NSString * customer_property;
///订单对应用户性别
@property (nonatomic, strong) NSString * customer_sex;
///订单对应的车辆的发动机编号
@property(nonatomic, strong) NSString * car_vin;
///订单对应车行驶里程
@property (nonatomic, strong) NSString * car_distance;
///订单对应用户单位
@property (nonatomic, strong) NSString * customer_group;

//订单对应项目
@property (nonatomic, strong) NSMutableArray *order_pro;
//当前门店所有的技师
@property (nonatomic, strong) NSMutableArray *staff_store;
//当前订单对应的技师
@property (nonatomic, strong) NSMutableArray *used_staffs;

@end
