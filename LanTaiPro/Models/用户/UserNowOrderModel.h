//
//  UserNowOrderModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 用户界面里面当前订单
 */

#import "UserNowOrderProductModel.h"

@interface UserNowOrderModel : NSObject

///订单id
@property (nonatomic, strong) NSString *orderId;
///订单号
@property (nonatomic, strong) NSString *orderCode;
///订单车牌号
@property (nonatomic, strong) NSString *orderNum;
///订单总价
@property (nonatomic, strong) NSString *orderPrice;
///订单里面产品数组
@property (nonatomic, strong) NSMutableArray *productList;

@property (nonatomic) BOOL isOpen;
@end
