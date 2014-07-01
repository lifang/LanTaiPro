//
//  DiscountCardOrderModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-27.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "DiscountCardOrderModel.h"

@implementation DiscountCardOrderModel

+ (NSDictionary*)mts_mapping
{
    return  @{
              @"discount_cards": mts_key(discountCardList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}
+ (NSDictionary*)mts_arrayClassMapping
{
    return @{
             mts_key(discountCardList) : DiscountCardModel.class,
             };
}

@end
