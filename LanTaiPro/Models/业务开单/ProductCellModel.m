//
//  ProductCellModel.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ProductCellModel.h"

@implementation ProductCellModel

+ (NSDictionary *)mts_mapping
{
    return  @{
              @"id": mts_key(productId),
              @"name": mts_key(name),
              @"price": mts_key(price)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
