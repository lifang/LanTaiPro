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
//@property (assign, nonatomic) BOOL firstTime;


@end
