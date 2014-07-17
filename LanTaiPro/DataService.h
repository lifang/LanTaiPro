//
//  DataService.h
//  LanTaiPro
//
//  Created by lantan on 14-6-4.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject


+ (DataService *)sharedService;

@property (strong, nonatomic) NSMutableArray *staffIdArr;//选择技师的id
@property (strong, nonatomic) NSMutableString *staffNameStr;//选择技师的Name
@property (strong, nonatomic) NSMutableString *stationTotal;//现场管理中，订单页面中总计
///判断 number_id 是否加载数据；
@property (nonatomic,assign) BOOL first;
///套餐卡
@property (nonatomic,strong) NSMutableArray *row_id_countArray;
///活动打折卡
@property (nonatomic,strong) NSMutableArray *row_id_numArray;
///选择产品价格／服务的id
@property (nonatomic,strong) NSMutableDictionary *price_id;
///选择产品服务的id 和数量
@property (nonatomic,strong) NSMutableDictionary *number_id;
///活动
@property (nonatomic,strong) NSMutableArray *saleArray;
///保存打折卡优惠信息
@property (nonatomic,strong) NSMutableArray *svcardArray;//row_id_numArray
@end
