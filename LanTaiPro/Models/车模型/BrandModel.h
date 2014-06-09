//
//  BrandModel.h
//  LanTai
//
//  Created by comdosoft on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelModel.h"

/**
 * 汽车品牌
 * 功能－－数据模型
 */
@interface BrandModel : NSObject

///品牌的父类标签id
@property (nonatomic, strong) NSString *capital_id;
///品牌名称
@property (nonatomic, strong) NSString *name;
///品牌id
@property (nonatomic, strong) NSString *brand_id;
///品牌对应模型列表
@property (nonatomic, strong) NSMutableArray *modelList;
@end
