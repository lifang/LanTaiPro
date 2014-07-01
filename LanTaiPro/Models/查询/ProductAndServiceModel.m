//
//  ProductAndServiceModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ProductAndServiceModel.h"

@implementation ProductAndServiceModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"id": mts_key(p_id),
              @"img_url": mts_key(p_imageUrl),
              @"description": mts_key(p_description),
              @"introduction": mts_key(p_introduction),
              @"name": mts_key(p_name),
              @"types": mts_key(p_types),
              @"sale_price":mts_key(p_price),
              @"isseleted": mts_key(p_selected),
              @"storage": mts_key(p_num),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
@end
