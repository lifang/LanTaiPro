//
//  LTSettingViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-19.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 设置页面
 * by－－－邱成西
 */
#import "OrderModel.h"

@protocol SettingViewControlDelegate ;

@interface LTSettingViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic, assign) id<SettingViewControlDelegate>delegate;
@property (nonatomic, weak) IBOutlet UITableView *myTable;

@end

@protocol SettingViewControlDelegate <NSObject>

-(void)dismissSettingViewControl:(LTSettingViewController *)viewControl;

@end