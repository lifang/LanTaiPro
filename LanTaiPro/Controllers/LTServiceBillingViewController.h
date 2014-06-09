//
//  LTServiceBillingViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCycleScrollView.h"
#import "ShaixuanView.h"

#import "ServiceBillingCell.h"
#import "BillingModel.h"
#import "ServiceBillingCustomView.h"

@interface LTServiceBillingViewController : UIViewController<UITextFieldDelegate,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;

@property (nonatomic, weak) IBOutlet UIView *leftView;
///筛选车牌
@property (nonatomic, strong) ShaixuanView *sxView;

///scrollView
@property (nonatomic, strong) XLCycleScrollView *scrollView;


@property (nonatomic, strong) BillingModel *billingModel;
///右侧
@property (nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, weak) IBOutlet UITableView *fastTable;
@property (nonatomic, strong) NSMutableArray *arrSelSection;
@property (nonatomic, assign) NSInteger tmpSection;
@property (nonatomic, weak) IBOutlet UITextField *productSearchTextField;


@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) NSMutableArray *searchArray;

@end
