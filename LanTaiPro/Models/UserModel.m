//
//  UserModel.m
//  LanTai
//
//  Created by comdosoft on 13-12-16.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (UserModel *)userFromDictionary:(NSDictionary *)aDic
{
    UserModel *user = [[UserModel alloc]init];
    
    [user setUser_id:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"user_id"]]];
    [user setUserName:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"username"]]];
    [user setUserImg:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"photo"]]];
    [user setUserPost:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"position"]]];
    [user setUserPartment:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"department"]]];
    [user setUserCashAuth:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"cash_auth"]]];
    [user setName:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"name"]]];
    [user setStore_id:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"store_id"]]];
    [user setStoreName:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"store_name"]]];
    
    return user;
}
@end
