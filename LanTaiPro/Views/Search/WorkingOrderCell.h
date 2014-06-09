//
//  WorkingOrderCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchOrder.h"

@protocol WorkingOrderCellDelegate;

@interface WorkingOrderCell : UITableViewCell

@property (nonatomic, assign) id<WorkingOrderCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePeopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *techLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier workingOrder:(SearchOrder *)workOrder;
@end

@protocol WorkingOrderCellDelegate <NSObject>

-(void)cancelWorkingOrder:(WorkingOrderCell *)cell;
-(void)confirmWorkingOrder:(WorkingOrderCell *)cell;

@end