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
              @"status": mts_key(p_status),
              @"types": mts_key(p_types),
              @"sale_price":mts_key(p_price),
              @"isSelected": mts_key(p_selected),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
@end
