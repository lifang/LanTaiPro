//
//  CapitalModel.m
//  LanTai
//
//  Created by comdosoft on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CapitalModel.h"

@implementation CapitalModel

+ (NSDictionary *)mts_mapping
{
    return  @{
              @"specified_time": mts_key(capital_id),
              @"questions": mts_key(name),
              @"questions": mts_key(barndList)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary *)mts_arrayClassMapping
{
    return @{mts_key(barndList) : BrandModel.class};
}

@end
