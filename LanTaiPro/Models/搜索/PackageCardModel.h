//
//  PackageCardModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PackageCardProductModel.h"

@interface PackageCardModel : NSObject

@property (nonatomic, strong) NSString *packageId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ended_at;
@property (nonatomic, strong) NSString *isNew;
@property (nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, strong) NSString *cus_card_id;//套餐卡与客户关联id
@end
