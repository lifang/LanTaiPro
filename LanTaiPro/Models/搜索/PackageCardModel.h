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
@property (nonatomic, strong) NSMutableArray *productList;

@end
