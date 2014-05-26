//
//  AppDelegate.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
///网络判断
#import "Reachability.h"

@class LTMainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
///网络监听所用
@property (retain, nonatomic) Reachability *hostReach;
///网络是否连接
@property (assign, nonatomic) BOOL isReachable;

@property (nonatomic, strong) LTMainViewController *mainViewController;

+(AppDelegate *)shareIntance;
- (void)showLogViewController;
- (void)showRootViewController;
@end
