//
//  UserNowOrderOpenCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserNowOrderModel.h"
#import "UserNowOrderProductModel.h"

@interface UserNowOrderOpenCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *orderCodeLabel;
@property (nonatomic, strong) IBOutlet UILabel *orderNumLabel;
@property (nonatomic, strong) UIView *lineView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier userNowOrderModel:(UserNowOrderModel *)userNowOrder;
@end
