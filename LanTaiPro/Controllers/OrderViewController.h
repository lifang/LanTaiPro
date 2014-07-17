//
//  OrderViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-17.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVSegmentedControl.h"
#import "DrawSignView.h"

#import "OrderInfoObject.h"

#import "PaySeriviceCell.h"
#import "PaySvcardCell.h"
#import "PayPackagecardCell.h"

#import "LTMainViewController.h"
#import "ComplaintViewController.h"

#import "PayStyleViewController.h"

@protocol OrderViewControllerDelegate;

@interface OrderViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ComplaintDelegate,PayStyleViewDelegate>

@property (nonatomic, assign) id<OrderViewControllerDelegate>delegate;

@property (nonatomic, weak) IBOutlet UITableView *orderTable;

@property (nonatomic, strong) NSMutableDictionary *payDictionary;
///用户选择商品
@property (nonatomic, strong) NSMutableArray *buyOrderArray;
///优惠选择
@property (nonatomic, strong) NSMutableArray *preferentialArray;

//@property (nonatomic, strong) NSMutableArray *payOrderArray;
@property (nonatomic, strong) NSMutableArray *save_cardArray;
///满意度
@property (nonatomic, strong) SVSegmentedControl *svSegBtn;

@property (nonatomic, strong) AppDelegate *appDel;
///签名
@property (nonatomic, weak) IBOutlet UISwitch *signSwitch;
@property (nonatomic, strong) DrawSignView *drawSignView;


@property (nonatomic, weak) IBOutlet UIButton *cancelPayBtn;
@property (nonatomic, weak) IBOutlet UIButton *confirmPayBtn;
///订单总价
@property (nonatomic, assign) CGFloat total_count;
@property (nonatomic, assign) CGFloat total_count_temp;
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLab;

@property (nonatomic, weak) IBOutlet UILabel *nameLab,*phoneLab,*codeLab,*carNumLab,*timeLab,*statusLab,*prosLab;
@property (nonatomic, strong) OrderInfoObject *orderInfoObj;
@property (nonatomic, strong) LTMainViewController *mainViewControl;

///订单取消为O，订单确认为1，订单付款为2, 直接退出为-1
@property (nonatomic, assign) NSInteger order_type;

-(void)loadData:(NSDictionary *)aDic;

@end

@protocol OrderViewControllerDelegate <NSObject>

-(void)dismissOrderViewController:(OrderViewController *)orderViewController;

@end




