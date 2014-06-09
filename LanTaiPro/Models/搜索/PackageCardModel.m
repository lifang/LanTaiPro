//
//  PackageCardModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "PackageCardModel.h"

@implementation PackageCardModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"id": mts_key(packageId),
              @"name": mts_key(name),
              @"ended_at": mts_key(ended_at),
              @"products": mts_key(productList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(productList) : PackageCardProductModel.class,
             };
}

@end
