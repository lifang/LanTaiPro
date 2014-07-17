//
//  WorkingOrderCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchOrder.h"

/*
 施工中的单子：取消订单，付款，结束施工；付款后的施工中的单子：退单，结束施工； 等待施工的单子：取消订单，付款；付款后的等待施工的单子：退单；等待付款的单子：付款；
 */


@protocol WorkingOrderCellDelegate;

@interface WorkingOrderCell : UITableViewCell

@property (nonatomic, assign) id<WorkingOrderCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePeopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *techLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
///订单状态label
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) NSIndexPath *idxPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier workingOrder:(SearchOrder *)workOrder;

///付款
@property (nonatomic, weak) IBOutlet UIButton *payOrderButton;
///退单
@property (nonatomic, weak) IBOutlet UIButton *returnOrderButton;


@property (nonatomic, strong) NSMutableArray *buttonArray;
@end

@protocol WorkingOrderCellDelegate <NSObject>

-(void)payWorkingOrder:(WorkingOrderCell *)cell;
-(void)returnBackOrder:(WorkingOrderCell *)cell;

@end