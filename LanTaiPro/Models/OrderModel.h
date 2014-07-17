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
///订单投诉原因
@property (nonatomic, strong) NSString * reason;
///订单投诉要求
@property (nonatomic, strong) NSString * request;

+(NSMutableDictionary *)dictionaryFromModel:(OrderModel *)orderModel;

+(OrderModel *)orderModelFromDic:(NSDictionary *)aDic;
@end
