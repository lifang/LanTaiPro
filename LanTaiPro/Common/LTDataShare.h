//
//  LTDataShare.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 单列模式
 */

#import "UserModel.h"
#import "LTMainViewLeftBar.h"
#import "CarModel.h"
#import "SearchModel.h"

@interface LTDataShare : NSObject

@property (nonatomic, strong) UserModel *user;
///数据库地址
@property (nonatomic, strong) NSString *hostString;
///记录点击设置标签之前的标签
@property (nonatomic, assign) LTLeftBarItemTypes leftBarType;

///匹配车牌号前2位数组
@property (nonatomic, strong) NSMutableArray *matchArray;
@property (nonatomic, strong) NSMutableArray *sectionArray;

///车辆品牌、型号
@property (nonatomic, strong) CarModel *carModel;

///套餐卡选择产品下单  
@property (nonatomic, strong) NSMutableArray *packageOrderArray;

///业务开单-右侧边栏选择
@property (nonatomic, strong) NSMutableArray *billingProductArray;

///车牌或手机搜索框
@property (nonatomic, assign) NSInteger viewFrom;

///搜索用户页面
@property (nonatomic, strong) SearchModel *searchModel;

///工位情况
@property (nonatomic, strong) NSMutableDictionary *stationDic;

+ (LTDataShare *)sharedService;

@end
