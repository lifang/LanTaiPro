//
//  OrderProductModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-10.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderProductModel : NSObject

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) NSInteger number;//显示的总数量
@property (nonatomic, assign) NSInteger validNumber;//计算总价格的数量
@property (nonatomic, strong) NSString *types;
@property (nonatomic, strong) NSString *c_isNew;
@end
