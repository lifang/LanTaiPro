//
//  AppointmentModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-21.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 预约信息
 */

#import "AppointModel.h"

@interface AppointmentModel : NSObject

@property (nonatomic, strong) NSMutableArray *reservationsNormal;
///已经受理的
@property (nonatomic, strong) NSMutableArray *reservationsAccept;

@end
