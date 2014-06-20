//
//  ConstationCarView.m
//  LanTaiPro
//
//  Created by lantan on 14-6-13.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ConstationCarView.h"
#import <QuartzCore/QuartzCore.h>



@implementation ConstationCarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.postionImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.postionImg setImage:[UIImage imageNamed:@"station-showLab"]];
        [self addSubview:self.postionImg];
        
        self.clockImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.clockImg setImage:[UIImage imageNamed:@"station-clock"]];
        [self addSubview:self.clockImg];
        
        self.arrowheadImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.arrowheadImg setImage:[UIImage imageNamed:@"station-btn"]];
        [self addSubview:self.arrowheadImg];
        
        self.devideImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.devideImg setImage:[UIImage imageNamed:@"station-divider"]];
        [self addSubview:self.devideImg];
        
        self.timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.timeLab.backgroundColor = [UIColor clearColor];
        self.timeLab.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:12];
        [self addSubview:self.timeLab];
        
        self.serviceNameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.serviceNameLab.backgroundColor = [UIColor clearColor];
        self.serviceNameLab.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:12];
        [self addSubview:self.serviceNameLab];
        
        self.postionNameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.postionNameLab.backgroundColor = [UIColor clearColor];
        self.postionNameLab.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:12];
        [self addSubview:self.postionNameLab];
        
        self.carView = [[CarView alloc]initWithFrame:CGRectZero];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.carView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.postionImg.frame = CGRectMake(16, 7, 102,43);
    self.clockImg.frame = CGRectMake(20, 55, 21, 21);
    self.timeLab.frame = CGRectMake(50, 55, 65, 21);
    self.postionNameLab.frame = CGRectMake(31, 18, 87, 21);
    self.serviceNameLab.frame = CGRectMake(342, 16, 100, 34);
    self.arrowheadImg.frame = CGRectMake(473, 25, 31, 35);
    self.devideImg.frame = CGRectMake(126, 72, 412, 1);
    self.carView.frame = CGRectMake(177, 13, 125, 51);
}

-(void)initConstationCarViewWithStationModel:(StationModel *)stationModel  AndStationCarModel:(StationCarModel *)stationCarModel AndType:(NSInteger)type
{
    self.postionNameLab.text = stationModel.name;
//    self.station_id = stationCarModel.station_id;
       if (type == 0) {
        
        self.carView.hidden = YES;
        self.clockImg.hidden = YES;
        self.arrowheadImg.hidden = YES;
        self.serviceNameLab.hidden = YES;
        self.timeLab.hidden = YES;
        self.isEmpty = YES;
        
    }
    else
    {
        if ([stationCarModel.station_id isEqualToString:stationModel.station_id]) {
            self.carView.hidden = NO;
            self.clockImg.hidden = NO;
            self.arrowheadImg.hidden = NO;
            self.serviceNameLab.hidden = NO;
            self.timeLab.hidden = NO;
            self.isEmpty = NO;
            
//            self.carView.carNumberLab.text = stationCarModel.carPlateNumber;
            self.serviceNameLab.text = stationCarModel.serviceName;
        }
       
    }
    
}
-(void)setIsEmpty:(BOOL)isEmpty
{
    _isEmpty = isEmpty;
    if (isEmpty) {
        self.cusTime.hidden = YES;
        self.carView.state = CARNOTHING;
        self.serviceNameLab.text = nil;
//        self.postionNameLab.text = nil;
        self.timeLab.text = @"00:00:00";
        self.serviceNameLab.text = nil;
        self.arrowheadImg.hidden = YES;
        
        [self.cusTime stop];
    }
    else{
        
        self.posinDateLab.text = self.posinDate;
        self.carView.state = CARBEGINNING;
        self.serviceNameLab.text = self.posinServeName;
        
        self.cusTime.timeLab = self.posinDateLab;
        self.cusTime.startTime = self.timeStart;
        self.cusTime.endTime = self.timeEnd;
        self.arrowheadImg.hidden = NO;
        [self.cusTime setup];
    }
    [self.cusTime setHidden:isEmpty];
}

-(BOOL)getIsEmpty
{
    return self.isEmpty;
}

-(void)setPosinName:(NSString *)posinName
{
    _posinName = posinName;
    self.postionNameLab.text = posinName;
}

-(void)setCarObj:(StationCarModel *)car
{
    if (car) {
        self.carView.carNumber = car.carPlateNumber;
        self.carView.state = CARBEGINNING;
        
        self.timeStart = [NSString stringWithFormat:@"%@",car.serviceStartTime];
        self.timeEnd = [NSString stringWithFormat:@"%@",car.serviceEndTime];
        
        self.posinServeName = car.serviceName;
        self.isEmpty = NO;
    }
    else
    {
        self.isEmpty = YES;
    }
}

-(CustomTimeView *)cusTime
{
    if (_cusTime) {
        _cusTime = [[CustomTimeView alloc]init];
    }
    return _cusTime;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
