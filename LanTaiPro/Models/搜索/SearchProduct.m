
//
//  SearchProduct.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SearchProduct.h"

@implementation SearchProduct

+ (NSDictionary*)mts_mapping
{
    return  @{@"name": mts_key(name),
              @"price": mts_key(price),
              @"pro_num": mts_key(pro_num),
              @"total_price": mts_key(total_price),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
