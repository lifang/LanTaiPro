
//
//  SearchModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
+ (NSDictionary*)mts_mapping
{
    return  @{@"customer": mts_key(customerList),
              @"customer_cards": mts_key(packageCardList),
              @"discount_cards": mts_key(discountCardList),
              @"stored_cards": mts_key(svCardList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(customerList) : SearchCustomerModel.class,
             mts_key(packageCardList) : PackageCardModel.class,
             mts_key(discountCardList) : DiscountCardModel.class,
             mts_key(svCardList) : SvCardModel.class,
             };
}

@end
