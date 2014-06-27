//
//  UserModel.h
//  LanTai
//
//  Created by comdosoft on 13-12-16.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 用户
 * 功能－－数据模型
 */
@interface UserModel : NSObject

///用户id
@property (nonatomic, strong) NSString *user_id;
///用户手机
@property (nonatomic, strong) NSString *userName;
///用户头像
@property (nonatomic, strong) NSString *userImg;
///用户职位
@property (nonatomic, strong) NSString *userPost;
///用户部门
@property (nonatomic, strong) NSString *userPartment;
///用户姓名
@property (nonatomic, strong) NSString *name;
///用户付款权限
@property (nonatomic, strong) NSString *userCashAuth;
///用户对应门店id
@property (nonatomic, strong) NSString *store_id;
///用户对应门店名称
@property (nonatomic, strong) NSString *storeName;
///门店对应的数据库地址
@property (nonatomic, strong) NSString *kHost;

+ (UserModel *)userFromDictionary:(NSDictionary *)aDic;
@end
