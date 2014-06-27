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

#pragma mark - 获取当前时间
+ (NSString *)getNowDateFromatAnDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
    return timeString;
}


#pragma mark -水平左右画面抖动效果
+ (void)shakeViewHorizontal:(UIView*)viewToShake
{
    CGFloat t =2.0;
    //左右抖动效果
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

#pragma mark - 垂直上下画面抖动效果
+ (void)shakeViewVertical:(UIView*)viewToShake
{
    CGFloat t =2.0;
    
    //上下抖动效果
    CGAffineTransform translateMiddle  =CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0,t);
    CGAffineTransform translateTop =CGAffineTransformTranslate(CGAffineTransformIdentity,0.0,-t);
    
    viewToShake.transform = translateMiddle;
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        
        [UIView setAnimationRepeatCount:1.0];
        viewToShake.transform = translateTop;
        
    } completion:^(BOOL finished){
        if(finished){
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
                
            } completion:NULL];
        }
    }];
}

#pragma mark - 下拉显示logo
#warning 更改logo
+ (void)setLogoImageWithTable:(UITableView *)table
{
    UIView *view = [[UIView alloc]initWithFrame:(CGRect){0, -60, table.bounds.size.width, 60}];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:(CGRect){(table.frame.size.width-40)/2,10,40,40}];
    imgView.image = [UIImage imageNamed:@"userInfo-active"];
    [view addSubview:imgView];
    [table addSubview:view];
    imgView = nil;view=nil;
}

@end
