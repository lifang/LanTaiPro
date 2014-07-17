//
//  SearchCustomView.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//


/**
 * 搜索车牌或者手机号码页面
 * 信息
 * 进行中订单
 * 订单记录
 * 套餐卡
 * 打折卡
 * 储值卡
 * by－－－邱成西
 */

#import <UIKit/UIKit.h>

#import "SearchModel.h"
#import "WYPopoverController.h"
#import "InfoViewController.h"

#import "WorkingOrderCell.h"
#import "OldOrderCell.h"
#import "PackageCardCell.h"
#import "DiscountCardCell.h"
#import "SvCardCell.h"
#import "SearchOrder.h"

#import "CustomerModel.h"

#import "WorkingOrderModel.h"
#import "OldOrderModel.h"
#import "PackageOrderModel.h"
#import "SvCardOrderModel.h"
#import "DiscountCardOrderModel.h"

//付款成功后
typedef void(^FinishCallBack)(BOOL isFinish);

@protocol SearchCustomViewDelegate;

@interface SearchCustomView : UIView <UITextFieldDelegate,WYPopoverControllerDelegate,InfoViewControlDelegate,UITableViewDelegate,UITableViewDataSource,WorkingOrderCellDelegate,OldOrderCellDelegate,PackageCardCellDelegate>

@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *carNumField;
@property (nonatomic, weak) IBOutlet UITextField *phoneField;

@property (nonatomic, strong) WYPopoverController *popController;
@property (nonatomic, strong) InfoViewController *infoViewControl;

@property (nonatomic, strong) CustomerModel *customerModel;

@property (nonatomic, assign) id<SearchCustomViewDelegate>delegate;
///车辆品牌
@property (nonatomic, strong) NSString *carBrand;
///车辆型号
@property (nonatomic, strong) NSString *carModel;


@property (nonatomic, weak) IBOutlet UITableView *orderTable;

@property (nonatomic, assign) OrderTypes orderType;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign) BOOL isRefreshing;
+ (WYPopoverController *)popVC;
@end

@protocol SearchCustomViewDelegate <NSObject>
//套餐卡下单
- (void)dismisSearchCustomView:(SearchCustomView *)searchView;
//投诉
- (void)presentCompliantViewControlWithDictionary:(NSDictionary *)aDic;
//付款
-(void)payOrderWithDic:(NSDictionary *)aDic finishBlock:(FinishCallBack)finishBlock;
@end
