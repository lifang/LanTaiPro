//
//  OrderCell.h
//  LanTaiPro
//
//  Created by lantan on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *serviceLab;//服务项目
@property (strong, nonatomic) IBOutlet UILabel *unitPriceLab;//单价
@property (strong, nonatomic) IBOutlet UILabel *numLab;//数量
@property (strong, nonatomic) IBOutlet UILabel *subTotalLab;//小计

@end
