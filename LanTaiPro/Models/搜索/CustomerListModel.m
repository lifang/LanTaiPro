//
//  CustomerListModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-27.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "CustomerListModel.h"

@implementation CustomerListModel

+ (NSDictionary*)mts_mapping
{
    return  @{
              @"customer": mts_key(customerList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
+ (NSDictionary*)mts_arrayClassMapping
{
    return @{
             mts_key(customerList) : CustomerModel.class,
             };
}

@end
