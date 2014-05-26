//
//  LTDataBase.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

/**
 * 数据库
 * 功能－－创建并保存数据库，创建表
 */
@interface LTDataBase : NSObject

@property (nonatomic, strong) FMDatabase *db;

@end
