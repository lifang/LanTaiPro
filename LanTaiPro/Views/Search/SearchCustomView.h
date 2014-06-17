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

@protocol SearchCustomViewDelegate;

@interface SearchCustomView : UIView <UITextFieldDelegate,WYPopoverControllerDelegate,InfoViewControlDelegate,UITableViewDelegate,UITableViewDataSource,WorkingOrderCellDelegate,OldOrderCellDelegate,PackageCardCellDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *carNumField;
@property (nonatomic, weak) IBOutlet UITextField *phoneField;

@property (nonatomic, strong) WYPopoverController *popController;
@property (nonatomic, strong) InfoViewController *infoViewControl;

@property (nonatomic, strong) SearchCustomerModel *customerModel;

@property (nonatomic, assign) id<SearchCustomViewDelegate>delegate;
///套餐卡
@property (nonatomic, strong) NSMutableArray *packageCardList;
///打折卡
@property (nonatomic, strong) NSMutableArray *discountCardList;
///储值卡
@property (nonatomic, strong) NSMutableArray *svCardList;

///车辆品牌
@property (nonatomic, strong) NSString *carBrand;
///车辆型号
@property (nonatomic, strong) NSString *carModel;


@property (nonatomic, weak) IBOutlet UITableView *orderTable;

@property (nonatomic, assign) OrderTypes orderType;
+ (WYPopoverController *)popVC;
@end

@protocol SearchCustomViewDelegate <NSObject>

- (void)dismisSearchCustomView:(SearchCustomView *)searchView;
@end
