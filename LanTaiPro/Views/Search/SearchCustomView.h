//
//  SearchCustomView.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchModel.h"
#import "WYPopoverController.h"
#import "InfoViewController.h"

#import "WorkingOrderCell.h"
#import "OldOrderCell.h"
#import "PackageCardCell.h"
#import "DiscountCardCell.h"
#import "SvCardCell.h"

@interface SearchCustomView : UIView <UITextFieldDelegate,WYPopoverControllerDelegate,InfoViewControlDelegate,UITableViewDelegate,UITableViewDataSource,WorkingOrderCellDelegate,OldOrderCellDelegate,PackageCardCellDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *carNumField;
@property (nonatomic, weak) IBOutlet UITextField *phoneField;

@property (nonatomic, strong) WYPopoverController *popController;
@property (nonatomic, strong) InfoViewController *infoViewControl;

@property (nonatomic, strong) SearchCustomerModel *customerModel;

///套餐卡
@property (nonatomic, strong) NSMutableArray *packageCardList;
///打折卡
@property (nonatomic, strong) NSMutableArray *discountCardList;
///储值卡
@property (nonatomic, strong) NSMutableArray *svCardList;


@property (nonatomic, weak) IBOutlet UITableView *orderTable;

@property (nonatomic, assign) OrderTypes orderType;
+ (WYPopoverController *)popVC;
@end
