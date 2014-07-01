//
//  OrderModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+(NSMutableDictionary *)dictionaryFromModel:(OrderModel *)orderModel
{
    NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
    
    if (orderModel) {
        [aDic setObject:orderModel.store_id forKey:@"store_id"];
        [aDic setObject:orderModel.order_id forKey:@"order_id"];
        [aDic setObject:orderModel.order_is_please forKey:@"is_please"];
        [aDic setObject:orderModel.order_total_price forKey:@"total_price"];
        [aDic setObject:orderModel.order_prods forKey:@"prods"];
        [aDic setObject:orderModel.order_billing forKey:@"billing"];
        [aDic setObject:orderModel.order_pay_type forKey:@"pay_type"];
        [aDic setObject:orderModel.order_is_free forKey:@"is_free"];
        [aDic setObject:orderModel.order_status forKey:@"status"];
        [aDic setObject:orderModel.oprice forKey:@"oprice"];
        [aDic setObject:orderModel.content forKey:@"content"];
        [aDic setObject:orderModel.car_num_id forKey:@"car_num_id"];
        [aDic setObject:orderModel.car_brand forKey:@"brand"];
        [aDic setObject:orderModel.car_model forKey:@"model"];//
        [aDic setObject:orderModel.car_year forKey:@"year"];
        [aDic setObject:orderModel.car_distance forKey:@"cdistance"];
//        [aDic setObject:orderModel.car_num forKey:@"customer_id"];//
        [aDic setObject:orderModel.customer_id forKey:@"customer_id"];
        [aDic setObject:orderModel.customer_name forKey:@"userName"];
        [aDic setObject:orderModel.customer_phone forKey:@"phone"];
        [aDic setObject:orderModel.customer_sex forKey:@"sex"];
        [aDic setObject:orderModel.customer_property forKey:@"cproperty"];
        [aDic setObject:orderModel.customer_company forKey:@"cgroup_name"];
        [aDic setObject:orderModel.customer_vin forKey:@"vin"];
        [aDic setObject:orderModel.reason forKey:@"reason"];
        [aDic setObject:orderModel.request forKey:@"request"];
    }
    
    return aDic;
}
@end
