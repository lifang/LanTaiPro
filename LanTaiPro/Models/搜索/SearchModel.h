//
//  SearchModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SearchCustomerModel.h"
#import "PackageCardModel.h"
#import "DiscountCardModel.h"
#import "SvCardModel.h"

typedef enum : NSUInteger {
    OrderTypeWorking=0,
    OrderTypeOld,
    OrderTypePackage,
    OrderTypeSvCard,
    OrderTypeDiscountCard
} OrderTypes;

@interface SearchModel : NSObject
///用户－－包含基本信息，进行中的订单，过往订单
@property (nonatomic, strong) NSMutableArray *customerList;
///套餐卡
@property (nonatomic, strong) NSMutableArray *packageCardList;
///打折卡
@property (nonatomic, strong) NSMutableArray *discountCardList;
///储值卡
@property (nonatomic, strong) NSMutableArray *svCardList;
@end
