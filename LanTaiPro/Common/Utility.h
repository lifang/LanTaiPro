//
//  Utility.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockAlertView.h"

@interface Utility : NSObject

+ (void)errorAlert:(NSString *)message dismiss:(BOOL)animated;
+ (NSDictionary *)initWithJSONFile:(NSString *)jsonPath;
+(NSMutableArray *)matchArray;
@end
