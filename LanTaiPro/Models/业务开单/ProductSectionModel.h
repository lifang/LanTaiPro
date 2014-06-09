//
//  ProductSectionModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductCellModel.h"

@interface ProductSectionModel : NSObject

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *products;
@end
