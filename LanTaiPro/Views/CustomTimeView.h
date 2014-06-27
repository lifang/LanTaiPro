//
//  CustomTimeView.h
//  LanTaiPro
//
//  Created by lantan on 14-6-17.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTimeView : UIView

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
- (id)init;
- (void)setup;
- (void)stop;

@end
