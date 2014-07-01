//
//  PackageOrderModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-27.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "PackageOrderModel.h"

@implementation PackageOrderModel

+ (NSDictionary*)mts_mapping
{
    return  @{
              @"package_cards": mts_key(packageCardList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
+ (NSDictionary*)mts_arrayClassMapping
{
    return @{
             mts_key(packageCardList) : PackageCardModel.class,
             };
}

@end
