//
//  BillingModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "BillingModel.h"

@implementation BillingModel

+ (NSDictionary *)mts_mapping
{
    return  @{
              @"productList": mts_key(productList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary *)mts_arrayClassMapping
{
    return @{mts_key(productList) : ProductSectionModel.class};
}

@end
