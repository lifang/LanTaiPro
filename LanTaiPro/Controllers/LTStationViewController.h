//
//  LTStationViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "carCell.h"
#import "StaffsCell.h"
#import "OrderCell.h"
/**
 * 现场管理页面
 * 等待施工，正在施工，等待确认付款
 * by－－－黄小雪
 */


@interface LTStationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) AppDelegate *appDel;

@property (strong, nonatomic) IBOutlet UIScrollView *waitScrollView;//等待施工
@property (strong, nonatomic) IBOutlet UITableView *constructionTable;//正在施工table
@property (strong, nonatomic) IBOutlet UIScrollView *finshScrollView;//完成施工
@property (strong, nonatomic) IBOutlet UITableView *fastToOrderTable;//快速下单view中的tableView
@property (strong, nonatomic) IBOutlet UIView *orderInfoView;//订单详情
@property (strong, nonatomic) IBOutlet UIControl *leftViewCover;//覆盖在现场管理，显示了订单信息后的，左边部分的VIEW;
@property (strong, nonatomic) IBOutlet UITableView *staffTable;
@property (strong, nonatomic) IBOutlet UITableView *orderTable;

- (IBAction)tapLeftViewCover:(UIControl *)sender;//点击回到现场管理

@end
