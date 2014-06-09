//
//  ProductSectionModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ProductSectionModel.h"

@implementation ProductSectionModel

+ (NSDictionary *)mts_mapping
{
    return  @{
              @"id": mts_key(productId),
              @"name": mts_key(name),
              @"products": mts_key(products),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary *)mts_arrayClassMapping
{
    return @{mts_key(products) : ProductCellModel.class};
}
@end
