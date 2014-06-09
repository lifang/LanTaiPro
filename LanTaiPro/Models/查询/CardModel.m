//
//  CardModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "CardModel.h"

@implementation CardModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"id": mts_key(c_id),
              @"img_url": mts_key(c_imageUrl),
              @"name": mts_key(c_name),
              @"type": mts_key(c_type),
              @"description": mts_key(c_description),
              @"price": mts_key(c_price),
              @"isseleted": mts_key(c_selected),
              @"products": mts_key(c_product),
              @"brand": mts_key(c_brand),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
