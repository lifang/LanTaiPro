//
//  CarView.m
//  LanTaiPro
//
//  Created by lantan on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "CarView.h"


@implementation CarView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.carImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.carImageView setImage:[UIImage imageNamed:@"Car"]];
        [self addSubview:self.carImageView];
        
        self.carNumberLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.carNumberLab.backgroundColor = [UIColor clearColor];
        self.carNumberLab.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:12];
//        self.carNumberLab.text = @"SU12345";
        
        [self addSubview:self.carNumberLab];
        self.carModel = [[CarModel alloc]init];
        NSLog(@"--------%@",self.carModel);
        [self initCarViewWithCarModel:self.carModel];
    }
    return self;
}

-(void)initCarViewWithCarModel:(CarModel *)carModel
{
    self.carNumberLab.text = carModel.carPlateNumber;
    self.stationId =carModel.station_id;
    self.orderId = carModel.order_id;
    self.workId = carModel.workOrder_id;
}

- (void)layoutSubviews
{
    self.carImageView.frame = CGRectMake(0, 25, 125, 30);
    self.carNumberLab.frame = CGRectMake(33, 0, 77, 21);
}

@end
