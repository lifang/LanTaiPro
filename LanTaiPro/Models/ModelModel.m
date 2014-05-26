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
              @"questions": mts_key(name),
              @"questions": mts_key(brand_id),
              @"questions": mts_key(model_id)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}


@end
