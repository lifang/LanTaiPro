//
//  CustomerModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-27.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "CustomerModel.h"

@implementation CustomerModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"customer_id": mts_key(customer_id),
              @"name": mts_key(customer_name),
              @"mobilephone": mts_key(customer_phone),
              @"sex": mts_key(customer_sex),
              @"email": mts_key(customer_email),
              @"property": mts_key(customer_property),
              @"group_name":mts_key(customer_company),
              @"vin":mts_key(customer_vin),
              
              @"car_num_id": mts_key(customer_carNumId),
              @"brand_name": mts_key(customer_brandName),
              @"model_name": mts_key(customer_modelName),
              @"num": mts_key(customer_carNum),
              @"distance": mts_key(customer_distance),
              @"year": mts_key(customer_carYear),
              
              @"brand_id": mts_key(customer_brandId),
              @"model_id": mts_key(customer_modelId),
              
              @"working_orders":mts_key(workingOrderList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{
             mts_key(workingOrderList) : SearchOrder.class,
             };
}

+(NSMutableDictionary *)dictionaryFromModel:(CustomerModel *)customerModel
{
    NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
    
    if (customerModel) {
        if (customerModel.customer_id != nil) {
            [aDic setObject:customerModel.customer_id forKey:@"customer_id"];
        }
        if (customerModel.customer_name != nil) {
            [aDic setObject:customerModel.customer_name forKey:@"name"];
        }
        if (customerModel.customer_carNum != nil) {
            [aDic setObject:customerModel.customer_carNum forKey:@"num"];
        }
        if (customerModel.customer_phone != nil) {
            [aDic setObject:customerModel.customer_phone forKey:@"mobilephone"];
        }
        if (customerModel.customer_modelId != nil) {
            [aDic setObject:customerModel.customer_modelId forKey:@"model_id"];
        }
        if (customerModel.customer_carNumId != nil) {
            [aDic setObject:customerModel.customer_carNumId forKey:@"car_num_id"];
        }
        if (customerModel.customer_carYear != nil) {
            [aDic setObject:customerModel.customer_carYear forKey:@"year"];
        }
        if (customerModel.customer_distance != nil) {
            [aDic setObject:customerModel.customer_distance forKey:@"distance"];
        }
        if (customerModel.customer_company != nil) {
            [aDic setObject:customerModel.customer_company forKey:@"group_name"];
        }
        if (customerModel.customer_vin != nil) {
            [aDic setObject:customerModel.customer_vin forKey:@"vin"];
        }
        if (customerModel.customer_property != nil) {
            [aDic setObject:customerModel.customer_property forKey:@"property"];
        }
        if (customerModel.customer_sex != nil) {
            [aDic setObject:customerModel.customer_sex forKey:@"sex"];
        }
    }
    
    return aDic;
}


@end
