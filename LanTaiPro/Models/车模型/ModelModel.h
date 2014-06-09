//
//  ModelModel.h
//  LanTai
//
//  Created by comdosoft on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 汽车模型
 * 功能－－数据模型
 */
@interface ModelModel : NSObject

///模型名称
@property (nonatomic, strong) NSString *name;
///模型的父类品牌的id
@property (nonatomic, strong) NSString *brand_id;
///模型id
@property (nonatomic, strong) NSString *model_id;

@end
