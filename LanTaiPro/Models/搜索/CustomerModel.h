//
//  CustomerModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-27.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchModel.h"
#import "SearchOrder.h"

@interface CustomerModel : NSObject

///用户id
@property (nonatomic, strong) NSString * customer_id;//

///用户姓名
@property (nonatomic, strong) NSString * customer_name;//
///用户手机
@property (nonatomic, strong) NSString * customer_phone;//
///用户性别
@property (nonatomic, strong) NSString * customer_sex;//
///用户邮箱
@property (nonatomic, strong) NSString * customer_email;//
///用户属性
@property (nonatomic, strong) NSString * customer_property;
///用户单位
@property (nonatomic, strong) NSString * customer_company;
@property (nonatomic, strong) NSString * customer_vin;


///车品牌
@property (nonatomic, strong) NSString * customer_brandName;//
@property (nonatomic, strong) NSString * customer_brandId;
///车型号
@property (nonatomic, strong) NSString * customer_modelName;//
@property (nonatomic, strong) NSString * customer_modelId;
///车id
@property (nonatomic, strong) NSString * customer_carNumId;//
///车牌
@property (nonatomic, strong) NSString * customer_carNum;//
///车购买年份
@property (nonatomic, strong) NSString * customer_carYear;//
///车行驶里程
@property (nonatomic, strong) NSString * customer_distance;//

@property (nonatomic, assign) OrderTypes orderType;

///进行中订单
@property (nonatomic, strong) NSMutableArray *workingOrderList;
///过往消费记录
@property (nonatomic, strong) NSMutableArray *oldOrderList;

+(NSMutableDictionary *)dictionaryFromModel:(CustomerModel *)customerModel;
@end
