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
              @"specified_time": mts_key(capital_id),
              @"questions": mts_key(name),
              @"questions": mts_key(brand_id),
              @"questions": mts_key(modelList)
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
