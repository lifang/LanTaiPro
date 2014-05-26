//
//  AppointproductModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-21.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 预约项目
 */
@interface AppointproductModel : NSObject

///a_p_:appoint_product_项目id
@property (nonatomic, strong) NSString *a_p_id;

///a_p_:appoint_product_项目基本价格
@property (nonatomic, strong) NSString *a_p_basePrice;

///a_p_:appoint_product_项目
@property (nonatomic, strong) NSString *a_p_isService;

///a_p_:appoint_product_项目名称
@property (nonatomic, strong) NSString *a_p_name;

///a_p_:appoint_product_项目对应预约信息id
@property (nonatomic, strong) NSString *a_p_reservationId;

///a_p_:appoint_product_项目销售价格
@property (nonatomic, strong) NSString *a_p_salePrice;

///a_p_:appoint_product_项目
@property (nonatomic, strong) NSString *a_p_types;

@end
