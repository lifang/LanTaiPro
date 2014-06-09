//
//  SearchOrder.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchProduct.h"

@interface SearchOrder : NSObject

@property (nonatomic, strong) NSString *car_num_id;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSString *staff_name;
@property (nonatomic, strong) NSMutableArray *productList;
@end
