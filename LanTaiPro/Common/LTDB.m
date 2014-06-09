//
//  LTDB.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTDB.h"
@interface LTDB(DBPrivate)
-(UserModel *)userModelFromLocal:(FMResultSet *)rs;
-(CapitalModel *)capitalModelFromLocal:(FMResultSet *)rs;
-(BrandModel *)brandModelFromLocal:(FMResultSet *)rs;
-(ModelModel *)modelModelFromLocal:(FMResultSet *)rs;

@end
@implementation LTDB(DBPrivate)
-(UserModel *)userModelFromLocal:(FMResultSet *)rs
{
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
    
    return tempUser;
}
-(CapitalModel *)capitalModelFromLocal:(FMResultSet *)rs
{
    CapitalModel *capitalModel = [[CapitalModel alloc]init];
    capitalModel.capital_id = [rs stringForColumn:@"capital_id"];
    capitalModel.name = [rs stringForColumn:@"name"];
    return capitalModel;
}
-(BrandModel *)brandModelFromLocal:(FMResultSet *)rs
{
    BrandModel *brandModel = [[BrandModel alloc]init];
    brandModel.brand_id = [rs stringForColumn:@"model_id"];
    brandModel.capital_id = [rs stringForColumn:@"car_brand_id"];
    brandModel.name = [rs stringForColumn:@"name"];
    return brandModel;
}
-(ModelModel *)modelModelFromLocal:(FMResultSet *)rs
{
    ModelModel *modelModel = [[ModelModel alloc]init];
    modelModel.model_id = [rs stringForColumn:@"brand_id"];
    modelModel.brand_id = [rs stringForColumn:@"car_capital_id"];
    modelModel.name = [rs stringForColumn:@"name"];
    return modelModel;
}
@end


@implementation LTDB

#pragma mark - 保存用户信息
- (BOOL)saveUserDataToLocal:(UserModel *)user
{
    FMResultSet * rs = [self.db executeQuery:@"select * from user where user_id=?",user.user_id];
    
    BOOL isExit = NO;
    UserModel *tempUser = [[UserModel alloc]init];
    while ([rs next]) {
        tempUser = [self userModelFromLocal:rs];
        if ([tempUser.user_id integerValue]==[user.user_id integerValue]) {
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
    
    [self.db close];
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
        UserModel *tempUser = [self userModelFromLocal:rs];
        [mutableArray addObject:tempUser];
    }
    [rs close];
    [self.db close];
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


#pragma mark - 保存车辆品牌、模型信息
-(void)saveCarModelToLocal:(CarModel *)carModel
{
    [self.db executeUpdate:@"delete from carCapital"];
    [self.db executeUpdate:@"delete from carBrand"];
    [self.db executeUpdate:@"delete from carModel"];
    
    for (int i=0; i<carModel.carList.count; i++) {
        CapitalModel *capitalModel = (CapitalModel *)carModel.carList[i];
        [self.db executeUpdate:@"insert into carCapital (name , capital_id) values (?,?)",capitalModel.name,capitalModel.capital_id];
        
        for (int j=0; j<capitalModel.barndList.count; j++) {
            BrandModel *brandModel = (BrandModel *)capitalModel.barndList[j];
            [self.db executeUpdate:@"insert into carBrand (name , brand_id , car_capital_id ) values (?,?,?)",brandModel.name,brandModel.brand_id,brandModel.capital_id];
            
            for (int k=0; k<brandModel.modelList.count; k++) {
                ModelModel *model = (ModelModel *)brandModel.modelList[k];
                [self.db executeUpdate:@"insert into carModel (name , model_id , car_brand_id ) values (?,?,?)",model.name,model.model_id,model.brand_id];
            }
        }
    }
    
    [self.db close];
}

#pragma mark - 获取本地车品牌、型号
-(CarModel *)getLocalCarModel {
    CarModel *carModel = [[CarModel alloc]init];
    
    //索引
    NSMutableArray *carList = [[NSMutableArray alloc]init];
    FMResultSet * rs_capital = [self.db executeQuery:@"select * from carCapital"];
    while ([rs_capital next]){
        CapitalModel *capitalModel = [self capitalModelFromLocal:rs_capital];
        
        //品牌
        NSMutableArray *brandList = [[NSMutableArray alloc]init];
        FMResultSet * rs_brand = [self.db executeQuery:@"select * from carBrand where car_capital_id = ?",capitalModel.capital_id];
        while ([rs_brand next]){
            BrandModel *brandModel = [self brandModelFromLocal:rs_brand];
            
            //型号
            NSMutableArray *modelList = [[NSMutableArray alloc]init];
            FMResultSet * rs_model = [self.db executeQuery:@"select * from carModel where car_brand_id = ?",brandModel.brand_id];
            while ([rs_model next]){
                
                ModelModel *model = [self modelModelFromLocal:rs_model];
                [modelList addObject:model];
            }
            [rs_model close];
            
            brandModel.modelList = modelList;
            modelList= nil;
            
            [brandList addObject:brandModel];
        }
        capitalModel.barndList = brandList;
        brandList = nil;
        [rs_brand close];
        
        [carList addObject:capitalModel];
    }
    carModel.carList = carList;
    carList = nil;
    
    [rs_capital close];
    
    [self.db close];
    return carModel;
}
@end
