//
//  ModelModel.m
//  LanTai
//
//  Created by comdosoft on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ModelModel.h"

@implementation ModelModel

+ (NSDictionary *)mts_mapping
{
    return  @{
              @"name": mts_key(name),
              @"car_brand_id": mts_key(brand_id),
              @"id": mts_key(model_id)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}


@end
