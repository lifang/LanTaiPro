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

@protocol OrderViewControllerDelegate;

@interface OrderViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, assign) id<OrderViewControllerDelegate>delegate;

@property (nonatomic, weak) IBOutlet UITableView *orderTable;

@property (nonatomic, strong) NSMutableArray *payOrderArray;

@property (nonatomic, strong) SVSegmentedControl *svSegBtn;

@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic, weak) IBOutlet UISwitch *signSwitch;
@property (nonatomic, strong) DrawSignView *drawSignView;


@property (nonatomic, weak) IBOutlet UIButton *cancelPayBtn;
@property (nonatomic, weak) IBOutlet UIButton *confirmPayBtn;
@end

@protocol OrderViewControllerDelegate <NSObject>

-(void)dismissOrderViewController:(OrderViewController *)orderViewController;

@end