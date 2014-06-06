//
//  CarView.h
//  LanTaiPro
//
//  Created by lantan on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

@interface CarView : UIView

@property (strong, nonatomic)UILabel *carNumberLab;//车牌
@property (strong, nonatomic)UIImageView *carImageView;
@property (nonatomic, strong)NSString *stationId;//工位ID
@property (nonatomic, strong)NSString *orderId;//订单id
@property (nonatomic, strong)NSString *workId;
@property (nonatomic, strong)CarModel *carModel;
-(void)initCarViewWithCarModel:(CarModel *)carModel;


@end
