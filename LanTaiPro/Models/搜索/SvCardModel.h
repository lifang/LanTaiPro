//
//  SvCardModel.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SvCardProductModel.h"

@interface SvCardModel : NSObject
@property (nonatomic, strong) NSString *apply_content;
@property (nonatomic, strong) NSString *last_time;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *svCardId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *totle_price;
@property (nonatomic, strong) NSMutableArray *recordList;

@end
