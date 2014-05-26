//
//  OrderModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 订单
 * 功能－－数据模型
 */
@interface OrderModel : NSObject

///订单对应门店id
@property (nonatomic, strong) NSString * store_id;
///订单id
@property (nonatomic, strong) NSString * order_id;
///订单满意度
@property (nonatomic, strong) NSString * order_is_please;
///订单总价
@property (nonatomic, strong) NSString * order_total_price;
///订单商品
@property (nonatomic, strong) NSString * order_prods;
///订单发票
@property (nonatomic, strong) NSString * order_billing;
///订单付款类型
@property (nonatomic, strong) NSString * order_pay_type;
///订单是否免费
@property (nonatomic, strong) NSString * order_is_free;
///订单状态
@property (nonatomic, strong) NSString * order_status;
///订单实际付款价格
@property (nonatomic, strong) NSString * oprice;
@property (nonatomic, strong) NSString * content;



///订单对应车牌id
@property (nonatomic, strong) NSString * car_num_id;
///订单对应车品牌
@property (nonatomic, strong) NSString * car_brand;
///订单对应车购买年份
@property (nonatomic, strong) NSString * car_year;
///订单对应车行驶里程
@property (nonatomic, strong) NSString * car_distance;


///订单对应用户id
@property (nonatomic, strong) NSString * customer_id;
///订单对应用户生日
@property (nonatomic, strong) NSString * customer_birth;
///订单对应用户姓名
@property (nonatomic, strong) NSString * customer_name;
///订单对应用户手机
@property (nonatomic, strong) NSString * customer_phone;
///订单对应用户性别
@property (nonatomic, strong) NSString * customer_sex;
///订单对应用户属性
@property (nonatomic, strong) NSString * customer_property;
///订单对应用户单位
@property (nonatomic, strong) NSString * customer_company;

///订单投诉原因
@property (nonatomic, strong) NSString * reason;
///订单投诉要求
@property (nonatomic, strong) NSString * request;

@end
