//
//  PackageCardProductModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "PackageCardProductModel.h"

@implementation PackageCardProductModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"id": mts_key(productId),
              @"name": mts_key(name),
              @"product_num": mts_key(product_num),
              @"unused_num": mts_key(unused_num),
              @"selected_num": mts_key(selected_num),
              @"storage": mts_key(several_times),
              @"types": mts_key(types),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
