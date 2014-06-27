//
//  LTProductViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 产品，卡类，服务搜索下单页面
 */

#import "ProductCell.h"
#import "ProductModel.h"
#import "LTImageViewController.h"
#import "LTOrderViewController.h"
#import "LTMainViewController.h"

#import "LTServiceBillingViewController.h"


@interface LTProductViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ProductCellDelegate,LTOrderViewControlDelegate>

@property (nonatomic, strong) AppDelegate *appDel;
//分类
@property (nonatomic, assign) NSInteger classifyType;
@property (nonatomic, weak) IBOutlet UIButton *productButton;
@property (nonatomic, weak) IBOutlet UIButton *cardButton;
@property (nonatomic, weak) IBOutlet UIButton *serviceButton;

@property (nonatomic, weak) IBOutlet UITextField *searchText;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;

@property (nonatomic, weak) IBOutlet UITableView *productTable;

@property (nonatomic, weak) IBOutlet UIButton *cancelOrderButton;
@property (nonatomic, weak) IBOutlet UIButton *confirmOrderButton;

@property (nonatomic, strong) ProductModel *productModel;

///记录选中的数组
@property (nonatomic, strong) NSMutableArray *selectedArray;
///大图
@property (nonatomic, strong) LTImageViewController *productImgViewControl;

@property (nonatomic, strong) LTMainViewController *mainViewControl;
@property (nonatomic, strong) LTServiceBillingViewController *serviceViewControl;

@end
