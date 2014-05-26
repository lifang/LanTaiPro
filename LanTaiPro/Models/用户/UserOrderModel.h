//
//  UserOrderModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 用户界面里面本月概况－－当前订单数组
 */

#import "UserNowOrderModel.h"
@interface UserOrderModel : NSObject

///本月完成订单
@property (nonatomic, strong) NSString *orderCount;
///本月销售额
@property (nonatomic, strong) NSString *orderMoney;
///当前订单数组
@property (nonatomic, strong) NSMutableArray *orderNowList;
@end
