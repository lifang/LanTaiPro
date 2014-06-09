//
//  BrandModel.m
//  LanTai
//
//  Created by comdosoft on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BrandModel.h"

@implementation BrandModel

+ (NSDictionary *)mts_mapping
{
    return  @{
              @"capital_id": mts_key(capital_id),
              @"name": mts_key(name),
              @"id": mts_key(brand_id),
              @"models": mts_key(modelList)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary *)mts_arrayClassMapping
{
    return @{mts_key(modelList) : ModelModel.class};
}
@end
