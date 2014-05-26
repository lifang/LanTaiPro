//
//  AppDelegate.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "AppDelegate.h"
#import "LTLogInViewController.h"

#import "LTMainViewController.h"
#import "LTUserInfoViewController.h"
#import "LTStationViewController.h"
#import "LTServiceBillingViewController.h"
#import "LTProductViewController.h"
#import "LTSearchViewController.h"
#import "LTAppointmentViewController.h"

#import <UIKit/UIFont.h>

@implementation AppDelegate

+ (AppDelegate *)shareIntance
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
//登录页面
- (void)showLogViewController
{
    LTLogInViewController *logView = [[LTLogInViewController alloc]initWithNibName:@"LTLogInViewController" bundle:nil];
    self.window.rootViewController = logView;
}
- (void)showRootViewController
{
    LTUserInfoViewController *userViewControl = [[LTUserInfoViewController alloc]initWithNibName:@"LTUserInfoViewController" bundle:nil];
    LTStationViewController *stationViewControl = [[LTStationViewController alloc]initWithNibName:@"LTStationViewController" bundle:nil];
    LTServiceBillingViewController *serviceViewControl = [[LTServiceBillingViewController alloc]initWithNibName:@"LTServiceBillingViewController" bundle:nil];
    LTProductViewController *productViewControl = [[LTProductViewController alloc]initWithNibName:@"LTProductViewController" bundle:nil];
    LTSearchViewController *searchViewControl = [[LTSearchViewController alloc]initWithNibName:@"LTSearchViewController" bundle:nil];
    LTAppointmentViewController *appointViewControl = [[LTAppointmentViewController alloc]initWithNibName:@"LTAppointmentViewController" bundle:nil];
    self.mainViewController = [[LTMainViewController alloc] init];
    self.mainViewController.childenControllerArray = @[userViewControl,stationViewControl,serviceViewControl,productViewControl,searchViewControl,appointViewControl];
    self.mainViewController.currentPage = 0;
    self.window.rootViewController = self.mainViewController;
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //设置statusBar白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    [self.hostReach startNotifier];  //开始监听，会启动一个run loop
    
    [self showLogViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

//连接改变
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    if(status == NotReachable)
    {
        self.isReachable = NO;
    }
    else
    {
        self.isReachable = YES;
    }
}
@end
