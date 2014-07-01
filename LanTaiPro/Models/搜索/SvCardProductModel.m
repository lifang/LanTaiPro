//
//  SvCardProductModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SvCardProductModel.h"

@implementation SvCardProductModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"created_at": mts_key(created_at),
              @"customer_card_id": mts_key(customer_card_id),
              @"left_price": mts_key(left_price),
              @"types": mts_key(types),
              @"use_price": mts_key(use_price),
              @"use_price": mts_key(origin_price),
              @"use_price": mts_key(products),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
