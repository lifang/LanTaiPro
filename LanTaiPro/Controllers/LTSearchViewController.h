//
//  LTSearchViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchModel.h"
#import "ShaixuanView.h"
#import "XLCycleScrollView.h"
#import "SearchCustomView.h"
#import "LTMainViewController.h"
#import "LTServiceBillingViewController.h"

@interface LTSearchViewController : UIViewController<UITextFieldDelegate,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,SearchCustomViewDelegate>

@property (nonatomic, strong) LTMainViewController *mainViewControl;
@property (nonatomic, strong) LTServiceBillingViewController *serviceViewControl;

@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
///筛选车牌
@property (nonatomic, strong) ShaixuanView *sxView;

@property (nonatomic, strong) SearchModel *searchModel;
///scrollView
@property (nonatomic, strong) XLCycleScrollView *scrollView;

@end
