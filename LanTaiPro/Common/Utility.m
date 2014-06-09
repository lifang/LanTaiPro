//
//  Utility.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "Utility.h"
#import <objc/runtime.h>
#import "pinyin.h"

#define kTitle @"提示"
@implementation Utility

#pragma mark - 提示
+ (void)errorAlert:(NSString *)message dismiss:(BOOL)animated
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:kTitle message:message];
    if (!animated) {
        [alert addButtonWithTitle:@"" block:nil];
    }else {
        [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(closeAlert:) userInfo:alert repeats:NO];
    }
    [alert show];
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

#pragma mark - 匹配车牌前2个字

+(NSMutableArray *)matchArray {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 27; i++) [array addObject:[NSMutableArray array]];
    NSString *nameSection = nil;
    for (int m=0; m<[[LTDataShare sharedService].matchArray count]; m++) {
        
        nameSection = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([[[LTDataShare sharedService].matchArray objectAtIndex:m] characterAtIndex:0])] uppercaseString];
        NSUInteger firstLetterLoc = [ALPHA rangeOfString:[nameSection substringToIndex:1]].location;
        if (firstLetterLoc != NSNotFound)
            [[array objectAtIndex:firstLetterLoc] addObject:[[LTDataShare sharedService].matchArray objectAtIndex:m]];
    }
    return array;
}
@end
