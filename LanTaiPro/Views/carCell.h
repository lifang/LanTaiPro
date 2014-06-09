//
//  carCell.h
//  LanTaiPro
//
//  Created by lantan on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"
#import "StationModel.h"

@interface carCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *stationNameLab;
@property (strong, nonatomic) IBOutlet UILabel *stationTimeLab;
@property (strong, nonatomic) IBOutlet UILabel *carNumLab;
@property (strong, nonatomic) IBOutlet UILabel *serviceNameLab;
@property (strong, nonatomic) IBOutlet UIButton *checkOrderBtn;
@property (strong, nonatomic) IBOutlet UIImageView *clockImg;
@property (strong, nonatomic) IBOutlet UIImageView *carImg;
@property (strong, nonatomic) NSString *stationId;
@property (strong, nonatomic) NSString *orderId;

-(void)initCarCellWithCarModel:(CarModel *)carModel;
-(void)initcarcellStation:(StationModel *)carModel;
@end
