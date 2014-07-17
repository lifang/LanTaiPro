//
//  LTServiceBillingViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//


/**
 * 开单界面
 * 查询页面下单跳转到该界面
 * 搜索页面套餐卡下单跳转该页面
 * 该页面直接下单
 * by－－－邱成西
 */

#import <UIKit/UIKit.h>
#import "XLCycleScrollView.h"
#import "ShaixuanView.h"
#import "SearchModel.h"
#import "ServiceBillingCell.h"
#import "BillingModel.h"
#import "ServiceBillingCustomView.h"
#import "OrderProductModel.h"

#import "Footer.h"
#import "Header.h"
#import "KeyViewController.h"
#import "OrderViewController.h"//订单确认 付款页面

#import "LTMainViewController.h"

#import "CustomerListModel.h"
#import "PackageOrderModel.h"

@interface LTServiceBillingViewController : UIViewController<UITextFieldDelegate,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ServiceBillingPackageCellDelegate,KeyViewControllerDelegate,OrderViewControllerDelegate>

@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;

@property (nonatomic, weak) IBOutlet UIView *leftView;
///筛选车牌
@property (nonatomic, strong) ShaixuanView *sxView;

@property (nonatomic, strong) SearchModel *searchModel;
///scrollView
@property (nonatomic, strong) XLCycleScrollView *scrollView;
@property (nonatomic, assign) BOOL isSearching;//判断用户信息是否是搜索
@property (nonatomic, strong) CustomerModel *customerModel;

@property (nonatomic, strong) BillingModel *billingModel;
///右侧
@property (nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, weak) IBOutlet UITableView *fastTable;
@property (nonatomic, strong) NSMutableArray *arrSelSection;
@property (nonatomic, assign) NSInteger tmpSection;
@property (nonatomic, weak) IBOutlet UITextField *productSearchTextField;

@property (nonatomic, assign) BOOL isSearch;//判断右边栏是否是搜索
@property (nonatomic, strong) NSMutableArray *searchArray;//右边栏搜索数据

//套餐卡
@property (nonatomic, strong) IBOutlet UIButton *packageBtn;
@property (nonatomic, strong) IBOutlet UITableView *packageTable;
@property (nonatomic, strong) NSMutableArray *packageCardList;
//订单
@property (nonatomic, strong) IBOutlet UITableView *orderTable;
@property (nonatomic, strong) Footer *footer;

@property (nonatomic, weak) IBOutlet UIButton *cancelOrderButton;
@property (nonatomic, weak) IBOutlet UIButton *confirmOrderButton;
@property (nonatomic, strong) NSMutableArray *orderArray;

@property (strong, nonatomic) NSString *sv_card_password;///设置密码
@property (assign, nonatomic) BOOL isExitSvcard;//判断是否存在储值卡
@property (nonatomic, strong) KeyViewController *keyViewController;

@property (nonatomic, strong) LTMainViewController *mainViewControl;

///滚动视图
@property (nonatomic, strong) UIView *rollView;
///滚动的按钮
@property (nonatomic, strong) UILabel *rollLabel;
///小按钮的滚动尺寸差值
@property (nonatomic, assign) float rollSize;
@end
