//
//  StationModel.h
//  LanTai
//
//  Created by comdosoft on 13-10-21.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 工位
 * 功能－－数据模型
 */
@interface StationModel : NSObject

///工位id
@property (nonatomic, strong) NSString *station_id;
///工位名称
@property (nonatomic, strong) NSString *name;

@end
