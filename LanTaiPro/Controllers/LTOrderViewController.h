//
//  LTOrderViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 通过搜索后下单，订单确认页面
 */

#import "ProductOrderCell.h"
#import "ProductModel.h"

@protocol LTOrderViewControlDelegate;

@interface LTOrderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) id<LTOrderViewControlDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, assign) NSInteger classifyType;

@property (nonatomic, weak) IBOutlet UITableView *orderTable;
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLabel;

-(void)loadData:(NSMutableArray *)array type:(NSInteger)type;
@end

@protocol LTOrderViewControlDelegate <NSObject>

- (void)disMissOrderViewControl:(LTOrderViewController *)viewControl;

@end
