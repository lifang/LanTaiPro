//
//  ProductAndServiceModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 产品或服务
 */

@interface ProductAndServiceModel : NSObject

@property (nonatomic, strong) NSString *p_id;
@property (nonatomic, strong) NSString *p_imageUrl;
@property (nonatomic, strong) NSString *p_description;
@property (nonatomic, strong) NSString *p_introduction;
@property (nonatomic, strong) NSString *p_name;
@property (nonatomic, strong) NSString *p_status;
@property (nonatomic, strong) NSString *p_types;
@property (nonatomic, strong) NSString *p_price;
@property (nonatomic, strong) NSString *p_selected;
@end
