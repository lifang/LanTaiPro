//
//  CardModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * 卡类
 */
@interface CardModel : NSObject

@property (nonatomic, strong) NSString *c_id;
@property (nonatomic, strong) NSString *c_imageUrl;
@property (nonatomic, strong) NSString *c_name;
@property (nonatomic, strong) NSString *c_type;
@property (nonatomic, strong) NSString *c_description;
@property (nonatomic, strong) NSString *c_price;
@property (nonatomic, strong) NSString *c_selected;

@property (nonatomic, strong) NSString *c_product;
@property (nonatomic, strong) NSString *c_brand;

@end
