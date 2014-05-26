//
//  Utility.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "Utility.h"
#import <objc/runtime.h>

#define kTitle @"提示"
@implementation Utility

#pragma mark - 提示
+ (void)errorAlert:(NSString *)message
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:kTitle message:message];
    [alert show];
    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(closeAlert:) userInfo:alert repeats:NO];
}

+ (void)closeAlert:(NSTimer*)timer {
    [(BlockAlertView*)timer.userInfo performDismissal];
}

#pragma mark - 解析json文件
+ (Class)JSONParserClass {
    return objc_getClass("NSJSONSerialization");
}

+ (NSDictionary *)initWithJSONFile:(NSString *)jsonPath {
    Class JSONSerialization = [Utility JSONParserClass];
    NSAssert(JSONSerialization != NULL, @"No JSON serializer available!");
    
    NSError *jsonParsingError = nil;
    NSString *path = [[NSBundle mainBundle]pathForResource:jsonPath ofType:@"json"];
    NSDictionary *dataObject = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:&jsonParsingError];
    return dataObject;
}
@end
