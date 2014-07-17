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
              @"is_new": mts_key(isNew),
              @"products": mts_key(productList),
              @"cus_card_id": mts_key(cus_card_id),
              
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
