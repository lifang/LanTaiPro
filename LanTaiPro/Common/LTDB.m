//
//  LTDB.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTDB.h"

@implementation LTDB

#pragma mark - 保存用户信息
- (BOOL)saveUserDataToLocal:(UserModel *)user
{
    FMResultSet * rs = [self.db executeQuery:@"select * from user where user_id=?",user.user_id];
    
    BOOL isExit = NO;
    UserModel *tempUser = [[UserModel alloc]init];
    while ([rs next]) {
        tempUser.user_id = [rs stringForColumn:@"user_id"];
        if ([tempUser.user_id integerValue]==[user.user_id integerValue]) {
            tempUser.userName = [rs stringForColumn:@"userName"];
            tempUser.userImg = [rs stringForColumn:@"userImg"];
            tempUser.userPost = [rs stringForColumn:@"userPost"];
            tempUser.userPartment = [rs stringForColumn:@"userPartment"];
            tempUser.name = [rs stringForColumn:@"name"];
            tempUser.userCashAuth = [rs stringForColumn:@"userCashAuth"];
            tempUser.store_id = [rs stringForColumn:@"store_id"];
            tempUser.storeName = [rs stringForColumn:@"storeName"];
            tempUser.kHost = [rs stringForColumn:@"kHost"];
            isExit = YES;
            break;
        }
    }
    [rs close];
    
    if (isExit==YES) {//存在  判断属性有无改变
        if ([tempUser.userCashAuth integerValue]!=[user.userCashAuth integerValue] || ![tempUser.userPost isEqualToString:user.userPost] || ![tempUser.userPartment isEqualToString:user.userPartment] || [tempUser.store_id integerValue]!=[user.store_id integerValue] || ![tempUser.storeName isEqualToString:user.storeName]) {
            return [self.db executeUpdate:@"update user set userCashAuth=?,store_id=?,storeName=?,userPartment=?,userPost=? where user_id= ?",user.userCashAuth,user.store_id,user.storeName,user.userPartment,user.userPost,user.user_id];
        }
    }else {//不存在  直接保存
        BOOL res = [self.db executeUpdate:@"insert into user (user_id,userName,userImg,userPost,userPartment,name,userCashAuth,store_id,storeName,kHost) values (?,?,?,?,?,?,?,?,?,?)",user.user_id,user.userName,user.userImg,user.userPost,user.userPartment,user.name,user.userCashAuth,user.store_id,user.storeName,user.kHost];
        return res;
    }
    return YES;
}

#pragma mark - 获取用户信息
- (void)getLocalUserDataWithUserId:(NSString*)userId storeId:(NSString *)storeId completeBlock:(void (^)(NSArray *array))compleBlock
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    FMResultSet * rs;
    if(userId!=nil){//查询的登录用户信息
        rs = [self.db executeQuery:@"select * from user where user_id=? and store_id=?",userId,storeId];
    }else {//查询门店下用户信息
        rs = [self.db executeQuery:@"select * from user where store_id=?",storeId];
    }
    while ([rs next]) {
        UserModel *tempUser = [[UserModel alloc]init];
        tempUser.user_id = [rs stringForColumn:@"user_id"];
        tempUser.userName = [rs stringForColumn:@"userName"];
        tempUser.userImg = [rs stringForColumn:@"userImg"];
        tempUser.userPost = [rs stringForColumn:@"userPost"];
        tempUser.userPartment = [rs stringForColumn:@"userPartment"];
        tempUser.name = [rs stringForColumn:@"name"];
        tempUser.userCashAuth = [rs stringForColumn:@"userCashAuth"];
        tempUser.store_id = [rs stringForColumn:@"store_id"];
        tempUser.storeName = [rs stringForColumn:@"storeName"];
        tempUser.kHost = [rs stringForColumn:@"kHost"];
        [mutableArray addObject:tempUser];
    }
    [rs close];
    if (compleBlock) {
        compleBlock(mutableArray);
    }
}

#pragma mark - 删除用户信息
- (BOOL)deleteLocalUser:(UserModel *)user
{
    BOOL res = [self.db executeUpdate:@"delete from user where user_id = ?",user.user_id];
    return res;
}
@end
