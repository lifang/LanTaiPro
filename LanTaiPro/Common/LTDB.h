//
//  LTDB.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTDataBase.h"

/**
 * 数据库操作
 * 功能－－对表的增删改查
 */

#import "UserModel.h"
#import "CarModel.h"
#import "OrderModel.h"

@interface LTDB : LTDataBase

//保存用户信息
- (BOOL)saveUserDataToLocal:(UserModel *)user;
//获取用户信息
- (void)getLocalUserDataWithUserId:(NSString*)userId storeId:(NSString *)storeId completeBlock:(void (^)(NSArray *array))compleBlock;
//删除用户信息
- (BOOL)deleteLocalUser:(UserModel *)user;


//保存车辆品牌、模型信息
-(void)saveCarModelToLocal:(CarModel *)carModel;
//获取本地车品牌、型号
-(CarModel *)getLocalCarModel;


//保存订单信息至本地
- (BOOL)saveOrderDataToLocal:(OrderModel *)orderModel;
//获取本地订单信息
-(OrderModel *)getLocalOrderInfoWhereOid:(NSString *)orderId;
//更新投诉内容
-(BOOL)updateOrderInfoReason:(NSString *)reason Reaquest:(NSString *)request WhereOid:(NSString *)orderId;
//删除本地订单
-(BOOL)deleteDataFromOrder;
//更新订单信息
-(BOOL)updateOrderInfoWithOrder:(OrderModel *)orderModel WhereOid:(NSString *)orderId;
//获取所有订单信息
-(NSArray *)getLocalOrderInfo;
@end
