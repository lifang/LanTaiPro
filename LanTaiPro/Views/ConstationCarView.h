//
//  ConstationCarView.h
//  LanTaiPro
//
//  Created by lantan on 14-6-13.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarView.h"
#import "StationCarModel.h"
#import "StationModel.h"
#import "CustomTimeView.h"

@protocol  ConstationCarViewDelegate;

@interface ConstationCarView : UIView

@property(assign, nonatomic) NSString *station_id;
@property(strong, nonatomic) NSString *order_id;
@property(strong, nonatomic) NSString *posinName;
@property(strong, nonatomic) NSString *posinDate;
@property(strong, nonatomic) NSString *posinCarNumber;
@property(strong, nonatomic) NSString *posinServeName;
@property(assign, nonatomic) BOOL isEmpty;
@property(strong, nonatomic) CarView *carView;
@property(strong, nonatomic) CustomTimeView *cusTime;
@property(strong, nonatomic) NSString *timeStart;
@property(strong, nonatomic) NSString *timeEnd;
@property(assign, nonatomic) NSTimeInterval touchTimer;

@property (strong, nonatomic) UIImageView *postionImg;
@property (strong, nonatomic) UIImageView *clockImg;
@property (strong, nonatomic) UIImageView *arrowheadImg;
@property (strong, nonatomic) UIImageView *devideImg;
@property (strong, nonatomic) UILabel *timeLab;
//@property (strong, nonatomic) CarView *carView;
//@property (strong, nonatomic) CustomTimeView *cusTime;
//@property (strong, nonatomic) NSString *timeStart;
//@property (strong, nonatomic) NSString *timeEnd;
//@property (assign, nonatomic) NSTimeInterval touchTimer;
@property (strong, nonatomic) UILabel *serviceNameLab;
@property (strong, nonatomic) UILabel *postionNameLab;
@property(nonatomic,strong) UILabel *posinDateLab;

@property (weak, nonatomic)id<ConstationCarViewDelegate> delegate;

//@property (strong, nonatomic) NSString *station_id;
//@property (assign, nonatomic) BOOL isEmpty;

-(void)initConstationCarViewWithStationModel:(StationModel *)stationModel  AndStationCarModel:(StationCarModel *)stationCarModel AndType:(NSInteger)type;
-(void)setCarObj:(StationCarModel *)car;
@end

@protocol ConstationCarViewDelegate <NSObject>

-(void)singleTapConstationCarView:(ConstationCarView *)constationCarView;

@end
