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

@interface LTDB : LTDataBase

//保存用户信息
- (BOOL)saveUserDataToLocal:(UserModel *)user;
//获取用户信息
- (void)getLocalUserDataWithUserId:(NSString*)userId storeId:(NSString *)storeId completeBlock:(void (^)(NSArray *array))compleBlock;
//删除用户信息
- (BOOL)deleteLocalUser:(UserModel *)user;

@end
