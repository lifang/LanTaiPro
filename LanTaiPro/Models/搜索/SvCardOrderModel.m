//
//  SvCardOrderModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-27.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SvCardOrderModel.h"

@implementation SvCardOrderModel

+ (NSDictionary*)mts_mapping
{
    return  @{
              @"sv_cards": mts_key(svCardList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
+ (NSDictionary*)mts_arrayClassMapping
{
    return @{
             mts_key(svCardList) : SvCardModel.class,
             };
}

@end
