//
//  UserNowOrderProductModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 用户界面里面当前订单里面包含的产品
 */

@interface UserNowOrderProductModel : NSObject

///产品名称
@property (nonatomic, strong) NSString *p_name;
///产品所在订单id
@property (nonatomic, strong) NSString *p_orderId;
///产品数量
@property (nonatomic, strong) NSString *p_number;
///产品单价
@property (nonatomic, strong) NSString *p_price;
///产品成本价
@property (nonatomic, strong) NSString *p_t_price;
///产品总价
@property (nonatomic, strong) NSString *p_totalPrice;

@end
