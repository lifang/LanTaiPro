//
//  SvCardCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-3.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SvCardModel.h"

@interface SvCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabe;

@property (nonatomic, strong) UILabel *applyContentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier svCard:(SvCardModel *)svCard;
@end
