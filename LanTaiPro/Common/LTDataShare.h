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

@interface LTDataShare : NSObject

@property (nonatomic, strong) UserModel *user;
///数据库地址
@property (nonatomic, strong) NSString *hostString;
///记录点击设置标签之前的标签
@property (nonatomic, assign) LTLeftBarItemTypes leftBarType;

+ (LTDataShare *)sharedService;

@end
