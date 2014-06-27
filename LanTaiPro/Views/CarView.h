//
//  CarView.h
//  LanTaiPro
//
//  Created by lantan on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationCarModel.h"

typedef enum {CARNOTHING,CARWAITTING,CARBEGINNING,CARPAYING,CARFINISHED} CarState;

@interface CarView : UIView<UIGestureRecognizerDelegate>


@property (nonatomic, assign) CGRect beforeMoiveRect;
@property (nonatomic, assign) CGRect parentViewRect;
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, assign) CarState state;
@property (nonatomic, assign) NSString *station_id;
@property (nonatomic, strong) UIView *coverView;




@property (nonatomic, strong)NSString *orderId;//订单id
@property (nonatomic, strong)NSString *workId;

@property (nonatomic, strong)StationCarModel *stationCarModel;

//@property (nonatomic,assign) CGRect beforeMoiveRect;
//@property (nonatomic,assign) CGRect parentViewRect;

@property (nonatomic, assign) CGSize offset;
@property (nonatomic, assign) CGPoint oldCenter;

-(void)initCarViewWithCarModel:(StationCarModel *)stationCarModel;
-(CarView *)copyCarView;


@end
