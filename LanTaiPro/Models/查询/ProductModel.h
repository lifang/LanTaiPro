//
//  ProductModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProductAndServiceModel.h"
#import "CardModel.h"

@interface ProductModel : NSObject

@property (nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, strong) NSMutableArray *cardList;
@property (nonatomic, strong) NSMutableArray *serviceList;

@end
