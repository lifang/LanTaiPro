//
//  LTMainViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 登录之后进入的页面的父类
 * 功能－－设置子viewController，页面切换
 * by－－－邱成西
 */

#import "LTMainViewLeftBar.h"
#import "LTSettingViewController.h"

@interface LTMainViewController : UIViewController <LTMainViewLeftBarDelegate,SettingViewControlDelegate>

@property (nonatomic) NSInteger currentPage;
///放置viewControllers的集合
@property (nonatomic, strong) NSArray *childenControllerArray;
///当前的viewController
@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, strong) LTMainViewLeftBar *leftTabBar;


-(void)changeFromController:(UIViewController*)fromViewControl toController:(UIViewController*)toViewControl;

@end
