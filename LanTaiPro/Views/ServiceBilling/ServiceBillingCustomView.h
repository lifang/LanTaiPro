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
#import "ServiceBillingPackageCellTableViewCell.h"
#import "ServiceBillingOrderCell.h"
#import "OrderProductModel.h"

#import "CustomerModel.h"

@interface ServiceBillingCustomView : UIView<UITextFieldDelegate,WYPopoverControllerDelegate,InfoViewControlDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *carNumField;
@property (nonatomic, weak) IBOutlet UITextField *phoneField;

@property (nonatomic, strong) WYPopoverController *popController;
@property (nonatomic, strong) InfoViewController *infoViewControl;

@property (nonatomic, strong) CustomerModel *customerModel;
///车辆品牌
@property (nonatomic, strong) NSString *carBrand;
///车辆型号
@property (nonatomic, strong) NSString *carModel;

- (id)initWithFrame:(CGRect)frame;
+ (WYPopoverController *)popVC;
@end
