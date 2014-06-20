//
//  LTStationViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StaffsCell.h"
#import "OrderCell.h"
#import "StationOrderModel.h"
#import "CarView.h"
#import "StationCarModel.h"
#import "StationModel.h"
#import "FastToOrderModel.h"
#import "ConstationCarView.h"
#import "DRScrollView.h"
#import "StationModel.h"
#import "FastToOrderCell.h"
#import "ServiceModel.h"
/**
 * 现场管理页面
 * 等待施工，正在施工，等待确认付款
 * by－－－黄小雪
 */


@interface LTStationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FastDelegate>
@property (nonatomic, strong) AppDelegate *appDel;

@property (strong, nonatomic) IBOutlet UIScrollView *waitScrollView;//等待施工
@property (strong, nonatomic) IBOutlet DRScrollView *constructionScrollView;

@property (strong, nonatomic) IBOutlet UIScrollView *finshScrollView;//完成施工
@property (strong, nonatomic) IBOutlet UITableView *fastToOrderTable;//快速下单view中的tableView
@property (strong, nonatomic) IBOutlet UIView *orderInfoView;//订单详情
@property (strong, nonatomic) IBOutlet UIControl *leftViewCover;//覆盖在现场管理，显示了订单信息后的，左边部分的VIEW;
@property (strong, nonatomic) IBOutlet UILabel *orderCode;
@property (strong, nonatomic) IBOutlet UILabel *customerName;
@property (strong, nonatomic) IBOutlet UILabel *carNum;
@property (strong, nonatomic) IBOutlet UILabel *customerPhone;
@property (strong, nonatomic) IBOutlet UILabel *customerProperty;
@property (strong, nonatomic) IBOutlet UILabel *customerSex;
@property (strong, nonatomic) IBOutlet UILabel *carVIN;
@property (strong, nonatomic) IBOutlet UILabel *carDistance;
@property (strong, nonatomic) IBOutlet UILabel *customerGroup;

@property (strong, nonatomic) IBOutlet UILabel *carBrandModel;
@property (strong, nonatomic) IBOutlet UILabel *carYear;

//技师
@property (strong, nonatomic) IBOutlet UILabel *seletedStaffs;

@property (strong, nonatomic)  UITableView *staffTable;//技师table
@property (strong, nonatomic)  UITableView *orderTable;//订单页面中订单table

@property (assign, nonatomic) BOOL isFirst;//是否第一次加载orderInfoView
@property (strong, nonatomic) IBOutlet UILabel *total;//总计

@property (strong, nonatomic) StationOrderModel *stationOrderModel;
@property (strong, nonatomic) ConstationCarView *constationCarView;
@property (strong, nonatomic) NSMutableArray *waitCarsArr,*waittingCarsArr;//等待施工的车辆
@property (strong, nonatomic) NSMutableArray *inConstructionCarsArr;//正在施工的车辆
@property (strong, nonatomic) NSMutableArray *finshedCarsArr,*finishedCarsArr;//等待确认付款的车辆
@property (strong, nonatomic) NSMutableDictionary *beginningCarsDic;//正在施工中的车辆DIC
@property (strong, nonatomic) NSArray *stationServiceArr;//工位信息;
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UIView *leftBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *sub_view;

@property (strong, nonatomic) CarView *carView;
@property (strong, nonatomic) CarView *moveCarView;
@property (strong, nonatomic) StationCarModel *stationCarModel;
@property (strong, nonatomic) StationModel *stationModel;
@property (strong, nonatomic) FastToOrderModel *fastToOrderModel;
@property (strong, nonatomic) NSArray *serviceArr;//快速下单服务Arr

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (assign, nonatomic) BOOL isScrollMiddleScrollView;
@property (strong, nonatomic) NSMutableArray *stationArray;
@property (nonatomic,strong) NSMutableArray *dataArray;//快速下单服务项目ARR

- (IBAction)tapLeftViewCover:(UIControl *)sender;//点击回到现场管理
- (IBAction)moveInconstructionCarView:(UIPanGestureRecognizer *)sender;

@end
