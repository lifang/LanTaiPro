//
//  ServiceBillingCustomView.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "InfoViewController.h"

#import "SearchModel.h"
#import "PackageCardCell.h"

@interface ServiceBillingCustomView : UIView<UITextFieldDelegate,WYPopoverControllerDelegate,InfoViewControlDelegate,UITableViewDelegate,UITableViewDataSource,PackageCardCellDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *carNumField;
@property (nonatomic, weak) IBOutlet UITextField *phoneField;

@property (nonatomic, strong) WYPopoverController *popController;
@property (nonatomic, strong) InfoViewController *infoViewControl;

@property (nonatomic, strong) SearchCustomerModel *customerModel;

@property (nonatomic, strong) UITableView *packageTable;
///套餐卡
@property (nonatomic, strong) NSMutableArray *packageCardList;

+ (WYPopoverController *)popVC;
@end
