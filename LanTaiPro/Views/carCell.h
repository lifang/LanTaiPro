//
//  carCell.h
//  LanTaiPro
//
//  Created by lantan on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface carCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *stationNameLab;
@property (strong, nonatomic) IBOutlet UILabel *stationTimeLab;
@property (strong, nonatomic) IBOutlet UILabel *carNumLab;
@property (strong, nonatomic) IBOutlet UILabel *serviceNameLab;
@property (strong, nonatomic) IBOutlet UIButton *checkOrderBtn;
@property (strong, nonatomic) IBOutlet UIImageView *clockImg;
@property (strong, nonatomic) IBOutlet UIImageView *carImg;

@end
