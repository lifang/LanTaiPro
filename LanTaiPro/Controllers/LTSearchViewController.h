//
//  LTSearchViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShaixuanView.h"
#import "XLCycleScrollView.h"
#import "SearchCustomView.h"
#import "LTMainViewController.h"
#import "LTServiceBillingViewController.h"
#import "ComplaintViewController.h"

#import "CustomerListModel.h"
#import "WorkingOrderModel.h"
#import "CustomerModel.h"

#import "OrderViewController.h"//订单确认 付款页面

@interface LTSearchViewController : UIViewController<UITextFieldDelegate,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,SearchCustomViewDelegate,ComplaintDelegate,OrderViewControllerDelegate>

@property (nonatomic, strong) LTMainViewController *mainViewControl;
@property (nonatomic, strong) LTServiceBillingViewController *serviceViewControl;

@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
///筛选车牌
@property (nonatomic, strong) ShaixuanView *sxView;
///scrollView
@property (nonatomic, strong) XLCycleScrollView *scrollView;

///搜索的内容
@property (nonatomic, strong) NSString *searchText;

///滚动视图
@property (nonatomic, strong) UIView *rollView;
///滚动的按钮
@property (nonatomic, strong) UILabel *rollLabel;
///小按钮的滚动尺寸差值
@property (nonatomic, assign) float rollSize;


@property(nonatomic,strong) void (^payFinish)(BOOL isFinish);
@end
