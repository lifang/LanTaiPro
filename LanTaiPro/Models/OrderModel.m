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
        
        [aDic setObject:orderModel.reason forKey:@"reason"];
        [aDic setObject:orderModel.request forKey:@"request"];
    }
    
    return aDic;
}

+(OrderModel *)orderModelFromDic:(NSDictionary *)aDic
{
    OrderModel *orderModel = [[OrderModel alloc]init];
    
    orderModel.store_id = [LTDataShare sharedService].user.store_id;
    orderModel.order_id = [NSString stringWithFormat:@"%@",[aDic objectForKey:@"order_id"]];
    orderModel.order_is_please = [NSString stringWithFormat:@"%@",[aDic objectForKey:@"is_please"]];
    orderModel.order_total_price = [NSString stringWithFormat:@"%@",[aDic objectForKey:@"total_price"]];
    orderModel.order_prods = [NSString stringWithFormat:@"%@",[aDic objectForKey:@"prods"]];
    orderModel.order_billing = [NSString stringWithFormat:@"%@",[aDic objectForKey:@"billing"]];
    orderModel.order_pay_type = [NSString stringWithFormat:@"%@",[aDic objectForKey:@"pay_type"]];
    orderModel.order_is_free = [NSString stringWithFormat:@"%@",[aDic objectForKey:@"is_free"]];
    
    return orderModel;
}
@end
