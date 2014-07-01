//
//  OldOrderCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-30.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchOrder.h"

@protocol OldOrderCellDelegate;

@interface OldOrderCell : UITableViewCell

@property (nonatomic, assign) id<OldOrderCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePeopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *techLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (nonatomic, strong) NSIndexPath *idxPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier oldOrder:(SearchOrder *)oldOrder;
@end

@protocol OldOrderCellDelegate <NSObject>

-(void)ComplaintOldOrder:(OldOrderCell *)cell;

@end
