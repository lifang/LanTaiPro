
//
//  DiscountCardProductModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "DiscountCardProductModel.h"

@implementation DiscountCardProductModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"id": mts_key(productId),
              @"name": mts_key(name),
              @"sale_price": mts_key(sale_price),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
