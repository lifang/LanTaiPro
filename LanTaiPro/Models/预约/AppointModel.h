//
//  AppointModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-21.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 一条预约信息
 */

#import "AppointproductModel.h"

@interface AppointModel : NSObject
///车牌
@property (nonatomic, strong) NSString *appointCarNum;
///车品牌
@property (nonatomic, strong) NSString *appointCarName;

///用户姓名
@property (nonatomic, strong) NSString *appointUserName;
///用户电话
@property (nonatomic, strong) NSString *appointUserPhone;
///用户是否vip
@property (nonatomic, strong) NSString *appointUserVip;
///用户邮箱
@property (nonatomic, strong) NSString *appointUserEmail;
///用户id
@property (nonatomic, strong) NSString *appointUserId;

///预约id
@property (nonatomic, strong) NSString *appointId;
///创建时间
@property (nonatomic, strong) NSString *appointCreatTime;
///预约订单状态
@property (nonatomic, strong) NSString *appointStatus;
///预约时间
@property (nonatomic, strong) NSString *appointResTime;
///预约项目
@property (nonatomic, strong) NSMutableArray *appointProductList;

@end
