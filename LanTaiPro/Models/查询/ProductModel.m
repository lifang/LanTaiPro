//
//  ProductModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

+ (NSDictionary*)mts_mapping
{
    return  @{@"products": mts_key(productList),
              @"cards": mts_key(cardList),
              @"services": mts_key(serviceList),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(productList) : ProductAndServiceModel.class,
             mts_key(cardList) : CardModel.class,
             mts_key(serviceList) : ProductAndServiceModel.class,
             };
}

@end
