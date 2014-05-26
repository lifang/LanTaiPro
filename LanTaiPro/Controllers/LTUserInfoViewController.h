//
//  LTUserInfoViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 用户页面
 * 用户信息－－－－－头像，姓名，职位
 * 本月订单概况－－－本月订单，本月销售额
 * 当前订单－－－－－订单号，车牌，项目，数量，单价，小计，总计
 * by－－－邱成西
 */

#import "UserOrderModel.h"
#import "UserNowOrderModel.h"
#import "LTLocalUserViewController.h"

@interface LTUserInfoViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,LocalUserViewControlDelegate>

@property (nonatomic, strong) AppDelegate *appDel;
///用户
@property (nonatomic, weak) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *userPostLabel;
///本月订单概况
@property (nonatomic, weak) IBOutlet UILabel *monthOrderCount;
@property (nonatomic, weak) IBOutlet UILabel *monthOrderMoney;
///当前订单
@property (nonatomic, weak) IBOutlet UITableView *orderTable;

@property (nonatomic, strong) UserOrderModel *userOrder;

@property (nonatomic, strong) NSDictionary *dictionary;
@end
