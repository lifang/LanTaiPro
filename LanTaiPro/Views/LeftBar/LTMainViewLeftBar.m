//
//  LTMainViewLeftBar.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTMainViewLeftBar.h"

@implementation LTMainViewLeftBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)defaultSelected
{
    [self unSelectedAllItems];
}

- (void)unSelectedAllItems
{
    self.userInfoItem.isSelected = NO;
    self.stationItem.isSelected = NO;
    self.serviceBillingItem.isSelected = NO;
    self.productItem.isSelected = NO;
    self.searchItem.isSelected = NO;
    self.appointmentItem.isSelected = NO;
    self.settingItem.isSelected = NO;
}

#pragma mark - 点击事件
- (IBAction)userInfoItemPressed:(id)sender {
    [self unSelectedAllItems];
    self.userInfoItem.isSelected = YES;
    [self.delegate leftTabBar:self selectedItem:LTLeftBarItemTypeUserInfo];
}
- (IBAction)stationItemPressed:(id)sender {
    [self unSelectedAllItems];
    self.stationItem.isSelected = YES;
    [self.delegate leftTabBar:self selectedItem:LTLeftBarItemTypeStation];
}
- (IBAction)serviceBillingItemPressed:(id)sender {
    [self unSelectedAllItems];
    self.serviceBillingItem.isSelected = YES;
    [self.delegate leftTabBar:self selectedItem:LTLeftBarItemTypeServiceBilling];
}
- (IBAction)productItemPressed:(id)sender {
    [self unSelectedAllItems];
    self.productItem.isSelected = YES;
    [self.delegate leftTabBar:self selectedItem:LTLeftBarItemTypeProduct];
}
- (IBAction)searchItemPressed:(id)sender {
    [self unSelectedAllItems];
    self.searchItem.isSelected = YES;
    [self.delegate leftTabBar:self selectedItem:LTLeftBarItemTypeSearch];
}
- (IBAction)appointmentItemPressed:(id)sender {
    [self unSelectedAllItems];
    self.appointmentItem.isSelected = YES;
    [self.delegate leftTabBar:self selectedItem:LTLeftBarItemTypeAppointment];
}
- (IBAction)settingItemPressed:(id)sender {
    [self unSelectedAllItems];
    self.settingItem.isSelected = YES;
    [self.delegate leftTabBar:self selectedItem:LTLeftBarItemTypeSetting];
}
@end
