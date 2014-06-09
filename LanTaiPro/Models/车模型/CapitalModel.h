//
//  CapitalModel.h
//  LanTai
//
//  Created by comdosoft on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrandModel.h"

/**
 * 汽车品牌字母标签
 * 功能－－数据模型
 */
@interface CapitalModel : NSObject

///标签id
@property (nonatomic, strong) NSString *capital_id;
///标签名称
@property (nonatomic, strong) NSString *name;
///标签对应的品牌列表
@property (nonatomic, strong) NSMutableArray *barndList;

@end
