//
//  LTMainViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTMainViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface LTMainViewController ()

@end

@implementation LTMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-background.jpg"]];
    //设置左边栏
    NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"LTMainViewLeftBar" owner:self options:nil];
    self.leftTabBar = (LTMainViewLeftBar*)[bundles objectAtIndex:0];
    self.leftTabBar.delegate = self;
    self.leftTabBar.frame = (CGRect){0,0,80,1024};
    [self.view addSubview:self.leftTabBar];
    [self.leftTabBar defaultSelected];
    
    self.leftTabBar.userInfoItem.isSelected = YES;
    //设置子controller
    self.currentViewController = [self.childenControllerArray objectAtIndex:self.currentPage];
    if (self.currentViewController) {
        self.currentViewController.view.frame = (CGRect){80,0,688,1024};
        [self.view addSubview:self.currentViewController.view];
    }
}

#pragma mark - 子controller之间切换
-(void)changeFromController:(UIViewController*)fromViewControl toController:(UIViewController*)toViewControl
{
    if (!fromViewControl || !toViewControl) {
        return;
    }
    if (fromViewControl == toViewControl) {
        return;
    }
    toViewControl.view.frame =  (CGRect){80,0,688,1024};
    [self transitionFromViewController:fromViewControl toViewController:toViewControl duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
    } completion:^(BOOL finished) {
        if (finished) {
            self.currentViewController = toViewControl;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 侧边栏代理
-(void)leftTabBar:(LTMainViewLeftBar*)tabBarView selectedItem:(LTLeftBarItemTypes)itemType
{
    if (itemType == LTLeftBarItemTypeSetting) {
        LTSettingViewController *settingViewControl = [[LTSettingViewController alloc]initWithNibName:@"LTSettingViewController" bundle:nil];
        settingViewControl.delegate = self;
        [settingViewControl willMoveToParentViewController:self];
        [self addChildViewController:settingViewControl];
        [settingViewControl didMoveToParentViewController:self];
        [self presentPopupViewController:settingViewControl animationType:MJPopupViewAnimationSlideBottomTop width:140];
    }else {
        [LTDataShare sharedService].leftBarType = itemType;
        if (itemType < self.childenControllerArray.count) {
            [self changeFromController:self.currentViewController toController:[self.childenControllerArray objectAtIndex:itemType]];
        }
    }
}

#pragma mark - 设置界面
-(void)dismissSettingViewControl:(LTSettingViewController *)viewControl
{
    [self.leftTabBar defaultSelected];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop dismissBlock:^(BOOL isFinish) {
        
        LTLeftBarItemTypes itemType = [LTDataShare sharedService].leftBarType;
        switch (itemType) {
            case LTLeftBarItemTypeUserInfo:
                self.leftTabBar.userInfoItem.isSelected = YES;
                break;
            case LTLeftBarItemTypeStation:
                self.leftTabBar.stationItem.isSelected = YES;
                break;
            case LTLeftBarItemTypeServiceBilling:
                self.leftTabBar.serviceBillingItem.isSelected = YES;
                break;
            case LTLeftBarItemTypeProduct:
                self.leftTabBar.productItem.isSelected = YES;
                break;
            case LTLeftBarItemTypeSearch:
                self.leftTabBar.searchItem.isSelected = YES;
                break;
            case LTLeftBarItemTypeAppointment:
                self.leftTabBar.appointmentItem.isSelected = YES;
                break;
                
            default:
                break;
        }
    }];
}
#pragma mark - progerty
-(void)setChildenControllerArray:(NSArray *)childenControllerArray
{
    if (_childenControllerArray != childenControllerArray) {
        for (UIViewController *controller in childenControllerArray) {
            [self addChildViewController:controller];
        }
    }
    _childenControllerArray = childenControllerArray;
}
@end
