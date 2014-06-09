//
//  SvCardModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SvCardModel.h"

@implementation SvCardModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"last_time": mts_key(last_time),
              @"description": mts_key(description),
              @"id": mts_key(svCardId),
              @"name": mts_key(name),
              @"totle_price": mts_key(totle_price),
              @"records": mts_key(recordList),
              @"apply_content": mts_key(apply_content),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(recordList) : SvCardProductModel.class,
             };
}

@end
