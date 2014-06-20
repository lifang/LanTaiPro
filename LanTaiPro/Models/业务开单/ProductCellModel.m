//
//  ProductCellModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ProductCellModel.h"

@implementation ProductCellModel

+ (NSDictionary *)mts_mapping
{
    return  @{
              @"id": mts_key(productId),
              @"name": mts_key(name),
              @"sale_price": mts_key(price),
              @"several_times": mts_key(several_times),
              @"types": mts_key(types),
              @"isseleted": mts_key(selected),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
