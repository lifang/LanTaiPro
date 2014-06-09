//
//  SearchCustomerModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SearchCustomerModel.h"

@implementation SearchCustomerModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"customer_id": mts_key(customer_id),
              @"birth": mts_key(customer_birth),
              @"name": mts_key(customer_name),
              @"mobilephone": mts_key(customer_phone),
              @"sex": mts_key(customer_sex),
              @"email": mts_key(customer_email),
              @"property": mts_key(customer_property),
              @"company":mts_key(customer_company),
              @"vin":mts_key(customer_vin),
              
              @"car_num_id": mts_key(customer_carNumId),
              @"brand_name": mts_key(customer_brandName),
              @"model_name": mts_key(customer_modelName),
              @"num": mts_key(customer_carNum),
              @"distance": mts_key(customer_distance),
              @"year": mts_key(customer_carYear),

              @"old_order": mts_key(oldOrderList),
              @"working_order": mts_key(workingOrderList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(oldOrderList) : SearchOrder.class,
             mts_key(workingOrderList) : SearchOrder.class,
             };
}

@end
