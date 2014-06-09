//
//  DiscountCardModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "DiscountCardModel.h"

@implementation DiscountCardModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"id": mts_key(disId),
              @"apply_content": mts_key(apply_content),
              @"description": mts_key(description),
              @"discount": mts_key(discount),
              @"name": mts_key(name),
              @"totle_price": mts_key(totle_price),
              @"products": mts_key(productList),
              @"ended": mts_key(ended),
              @"date_month": mts_key(date_month),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(productList) : DiscountCardProductModel.class,
             };
}

@end
