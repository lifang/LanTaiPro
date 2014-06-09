//
//  DiscountCardModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DiscountCardProductModel.h"

@interface DiscountCardModel : NSObject

@property (nonatomic, strong) NSString *disId;
@property (nonatomic, strong) NSString *apply_content;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *totle_price;
@property (nonatomic, strong) NSString *date_month;
@property (nonatomic, strong) NSString *ended;
@property (nonatomic, strong) NSMutableArray *productList;


@end
