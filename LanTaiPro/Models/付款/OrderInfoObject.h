//
//  OrderInfoObject.h
//  LanTaiPro
//
//  Created by comdosoft on 14-7-9.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>
//订单信息
@interface OrderInfoObject : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *carNum;
@property (nonatomic, strong) NSString *creatTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *proNames;
@property (nonatomic, strong) NSString *totalPrice;
@property (nonatomic, strong) NSString *isPleased;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *carNumId;
@end
