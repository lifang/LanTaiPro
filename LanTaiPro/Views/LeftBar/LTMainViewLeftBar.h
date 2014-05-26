//
//  LTMainViewLeftBar.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 首页左侧的侧边栏
 * 侧边栏上面按钮添加点击事件
 * by－－－邱成西
 */

typedef enum{
    LTLeftBarItemTypeUserInfo=0,      //用户
    LTLeftBarItemTypeStation,         //工位
    LTLeftBarItemTypeServiceBilling,  //业务开单
    LTLeftBarItemTypeProduct,         //产品
    LTLeftBarItemTypeSearch,          //查询
    LTLeftBarItemTypeAppointment,     //预约
    LTLeftBarItemTypeSetting          //设置
}LTLeftBarItemTypes;

#import "LTLeftBarItem.h"

@protocol LTMainViewLeftBarDelegate;

@interface LTMainViewLeftBar : UIView

@property (nonatomic, assign) id<LTMainViewLeftBarDelegate>delegate;

@property (nonatomic, weak) IBOutlet LTLeftBarItem *userInfoItem;
@property (nonatomic, weak) IBOutlet LTLeftBarItem *stationItem;
@property (nonatomic, weak) IBOutlet LTLeftBarItem *serviceBillingItem;
@property (nonatomic, weak) IBOutlet LTLeftBarItem *productItem;
@property (nonatomic, weak) IBOutlet LTLeftBarItem *searchItem;
@property (nonatomic, weak) IBOutlet LTLeftBarItem *appointmentItem;
@property (nonatomic, weak) IBOutlet LTLeftBarItem *settingItem;

- (void)defaultSelected;
- (IBAction)userInfoItemPressed:(id)sender;
- (IBAction)stationItemPressed:(id)sender;
- (IBAction)serviceBillingItemPressed:(id)sender;
- (IBAction)productItemPressed:(id)sender;
- (IBAction)searchItemPressed:(id)sender;
- (IBAction)appointmentItemPressed:(id)sender;
- (IBAction)settingItemPressed:(id)sender;

@end

@protocol LTMainViewLeftBarDelegate <NSObject>

-(void)leftTabBar:(LTMainViewLeftBar*)tabBarView selectedItem:(LTLeftBarItemTypes)itemType;

@end