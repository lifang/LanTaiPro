//
//  LTStationViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//


#import "LTStationViewController.h"
#import "ServiceModel.h"
#import "DataService.h"
#import "FastToOrderCell.h"

#define SELETED 100
#define UNSELETED 1000
#define CARVIEWWIDTH 125
#define CARVIEWHIGHT 30
#define LEFTVIEW_WIDTH 538
#define LEFTVIEW_HEIGHT 1003
#define WAITSCROLLVIEW_HEIGHT 80
#define FINSHSCROLLVIEW_HEIGHT 90
#define CONSTRUCTIONSCROLLVIEW_HEIGHT 79

#define CELL_WIDHT  200
#define CELL_POSION_WIDHT  260
#define CELL_HEIGHT 80
#define CELL_PADDING 10
#define SCROLLVIEW_LEFT_PADDING 10
#define SERVE_ITEM_HEIGHT 50

@interface LTStationViewController ()

@property (nonatomic,strong) NSMutableArray *posionItemArr;
@property (nonatomic,assign) BOOL isScrollMiddleScrollView;
@end

@implementation LTStationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.fastToOrderTable.backgroundColor = [UIColor clearColor];
    
    self.orderInfoView.frame = CGRectMake(-1024, 45, 588, 1003);
    self.leftViewCover.frame = CGRectMake(-1024, 45, 100, 1003);

    self.isFirst = YES;
    
    [self.waitScrollView setShowsHorizontalScrollIndicator:NO];
    [self.finshScrollView setShowsHorizontalScrollIndicator:NO];
    [self.constructionScrollView setShowsVerticalScrollIndicator:NO];

    [self getData];
    
    self.panGesture = [[UIPanGestureRecognizer alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSeletedStaffs:) name:@"showSeletedStaffs" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTotal:) name:@"showTotal" object:nil];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    CGFloat cellHeiht = 44;
    return cellHeiht;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
        if ([tableView isEqual:self.orderTable]) {
        return self.stationOrderModel.order_pro.count;
    }
    else if ([tableView isEqual:self.staffTable]) {
        if (self.stationOrderModel.staff_store.count%2 == 0) {
            return self.stationOrderModel.staff_store.count/2;
        }
        else
        {
            return self.stationOrderModel.staff_store.count/2 + 1;
        }
    }
    else if([tableView isEqual:self.fastToOrderTable])
    {
               return self.dataArray.count;
        
        
    }
    else
    {
        return  10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //快速下单中table
    if ([tableView isEqual:self.fastToOrderTable]) {
       
        static NSString *CellIdentifier = @"cellIden";
        FastToOrderCell *cell = (FastToOrderCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell = [[FastToOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        ServiceModel *service = (ServiceModel *)[self.dataArray objectAtIndex:indexPath.row];
        [cell.serveBt setTitle:service.name forState:UIControlStateNormal];
        cell.path = indexPath;
        cell.backgroundColor = [UIColor clearColor];
        if (indexPath.row == 0) {
            cell.isSelected = YES;
        }
        return cell;

       }
    //选择技师table
    if ([tableView isEqual:self.staffTable]) {
        static NSString *identifier = @"staffCell";
        StaffsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[StaffsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        NSArray *arr = [self getsubNSArrayFromStaffStore:self.stationOrderModel.staff_store andIndex:indexPath];
        [cell initStaffsCell:arr AndUsedStaffsDic:self.stationOrderModel.used_staffs];
        [tableView setSeparatorColor:[UIColor clearColor]];
        return cell;
    }

    //订单界面中显示订单的包含的项目或产品的table
    if ([tableView isEqual:self.orderTable]) {
        
        static NSString *identifier = @"orderCell";
        OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
             cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        NSDictionary *orderProDic = [[NSDictionary alloc]initWithDictionary:[self.stationOrderModel.order_pro objectAtIndex:indexPath.row]];
        [cell initOrderCell:orderProDic];
        [tableView setSeparatorColor:[UIColor clearColor]];
        return cell;
    }
    else
    {
        return nil;
    }
}

//获取从后台传过来的，该订单对应的技师
-(void)getUsedStaff:(NSMutableArray *)usedStaff
{
    for (int i = 0; i < self.stationOrderModel.used_staffs.count; i ++) {
        NSDictionary *usedStaffDic = [[NSDictionary alloc]initWithDictionary:[self.stationOrderModel.used_staffs objectAtIndex:i]];
        if (i == 0) {
             [[DataService sharedService].staffNameStr appendString:[NSString stringWithFormat:@"%@",[usedStaffDic objectForKey:@"name"]]];
        }
        else
        {
             [[DataService sharedService].staffNameStr appendString:[NSString stringWithFormat:@" %@",[usedStaffDic objectForKey:@"name"]]];
        }
       
        [[DataService sharedService].staffIdArr addObject:[NSString stringWithFormat:@"%@",[usedStaffDic objectForKey:@"id"]]];
    }

}
//把stafffStore,2个元素作为一个新的数组返回
-(NSArray *)getsubNSArrayFromStaffStore:(NSMutableArray *)staffStore andIndex:(NSIndexPath *)index;
{
    NSRange range;
    if (index.row*2 == self.stationOrderModel.staff_store.count -1) {
        range = NSMakeRange(index.row*2,1);
    }
    else
    {
        range = NSMakeRange(index.row*2,2);
    }
    return [self.stationOrderModel.staff_store subarrayWithRange:range];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if ([tableView isEqual:self.fastToOrderTable]) {
         [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
        //快速下单选择的服务Dic
        NSDictionary *seletedServiceDic = [[NSDictionary alloc]initWithDictionary:[self.serviceArr objectAtIndex:indexPath.row]];
        NSLog(@"----%@",seletedServiceDic);
    }
}

- (IBAction)singleTapConstationCarView:(UITapGestureRecognizer *)sender;
{
    CGPoint point = [sender locationInView:self.constructionScrollView];
        for (UIView *subView in [self.constructionScrollView subviews]) {
            if ([subView isKindOfClass:[ConstationCarView class]]) {
                
                ConstationCarView  *constationCarView = (ConstationCarView*)subView;
//                CGRect carRect = [subView convertRect:constationCarView.frame toView:self.constructionScrollView];
               
                CGRect carRect = [subView convertRect:subView.frame toView:self.constructionScrollView];
                if ([subView isKindOfClass:[ConstationCarView class]] && CGRectContainsPoint(carRect, point) )
                {

                    self.constationCarView = (ConstationCarView*)subView;
                    [self checkOrder:self.constationCarView];
                    break;
                }
        }
    }

}
//点击正在施工中的按钮，查看订单详情
-(void)checkOrder:(ConstationCarView  *)constationCarView;
{
   
//    CGPoint point = [constationCarView locationInView:self.leftView];
//    NSString *pointStr = NSStringFromCGPoint(point);
//     NSLog(@"%@",pointStr);
    NSLog(@"%@",constationCarView.station_id);
    
    [self testGetorderInfo];
    self.orderInfoView.frame = CGRectMake(100, 45, 588, 1003);
    
    self.leftViewCover.frame = CGRectMake(5, 45, 100, 1003);
    
    [self initInfoView];
    [DataService sharedService].staffNameStr = [[NSMutableString alloc]init];
    [DataService sharedService].stationTotal = [[NSMutableString alloc]init];
    [DataService sharedService].staffIdArr = [[NSMutableArray alloc]init];

    [self getUsedStaff:self.stationOrderModel.used_staffs];
    if (self.isFirst) {
        self.staffTable = [[UITableView alloc]initWithFrame:CGRectMake(29, 581, 510, 307)];
        self.orderTable = [[UITableView alloc]initWithFrame:CGRectMake(29, 229, 510, 247)];
        
        self.orderTable.backgroundColor = [UIColor clearColor];
        self.staffTable.backgroundColor = [UIColor clearColor];
        
        self.staffTable.delegate = self;
        self.staffTable.dataSource = self;
        self.orderTable.delegate = self;
        self.orderTable.dataSource = self;
        [self.orderInfoView addSubview:self.staffTable];
        [self.orderInfoView addSubview:self.orderTable];
       
        self.isFirst = NO;
    }
    else
    {
        [self.orderTable reloadData];
        [self.staffTable reloadData];
        
    }
     self.seletedStaffs.text = [DataService sharedService].staffNameStr;
  }

//显示已选择的技师
-(void)showSeletedStaffs:(NSNotification *)notification
{
    self.seletedStaffs.text = [DataService sharedService].staffNameStr;
}
//显示总计
-(void)showTotal:(NSNotification *)notification
{
    self.total.text = [DataService sharedService].stationTotal;
}
//测试infoview
- (void)testGetorderInfo{
    NSDictionary *aDic = [Utility initWithJSONFile:@"order_details"];
    [self.stationOrderModel mts_setValuesForKeysWithDictionary:aDic];

}
//测试现场管理主界面,给waitCarsArr，stationServiceArr，inConstructionCarsArr，finshedCarsArr赋值
//workOrderFlag:0等待施工，1正在施工，2等待确认付款
-(void)testConstruction:(NSInteger)workOrderFlag
{
    NSDictionary *constrDic = [Utility initWithJSONFile:@"construction"];
    NSDictionary *workOrdersDic = [[NSDictionary alloc]initWithDictionary:[constrDic objectForKey:@"work_orders"]];
    NSLog(@"%@",constrDic);
    if (workOrderFlag == 0) {
        self.waitCarsArr = [[NSMutableArray alloc]initWithArray:[workOrdersDic objectForKey:[NSString stringWithFormat:@"%d",workOrderFlag]]];
        
       self.stationServiceArr = [[NSArray alloc]initWithArray:[constrDic objectForKey:@"station_ids"]];
        
        self.serviceArr = [[NSArray alloc]initWithArray:[constrDic objectForKey:@"services"]];
    }

    else if(workOrderFlag == 1)
    {
        self.inConstructionCarsArr = [[NSMutableArray alloc]initWithArray:[workOrdersDic objectForKey:[NSString stringWithFormat:@"%d",workOrderFlag]]];
    }
    else
    {
        self.finshedCarsArr = [[NSMutableArray alloc]initWithArray:[workOrdersDic objectForKey:[NSString stringWithFormat:@"%d",workOrderFlag]]];
    }
}

//对等待施工，正在施工的车辆，等待确认付款的车辆赋值
-(void)setCarviewWithCarsArr:(NSMutableArray *)carsArr andWorkOrderFlag:(NSInteger)workOrderFlag
{
    self.stationCarModel = [[StationCarModel alloc]init];
    if (workOrderFlag == 0) {
        if (self.waitCarsArr.count > 4) {
            self.waitScrollView.contentSize = CGSizeMake(self.waitCarsArr.count*CARVIEWWIDTH, WAITSCROLLVIEW_HEIGHT);
        }
        else
        {
            self.waitScrollView.contentSize = CGSizeMake(LEFTVIEW_WIDTH, WAITSCROLLVIEW_HEIGHT);
        }
        for (int i = 0; i<self.waitCarsArr.count; i++) {
            NSDictionary *waitCarsDic = [[NSDictionary alloc]initWithDictionary:[self.waitCarsArr objectAtIndex:i]];
            [self.stationCarModel mts_setValuesForKeysWithDictionary:waitCarsDic];
            self.carView = [[CarView alloc]init];
            [self.carView initCarViewWithCarModel:self.stationCarModel];
            self.carView.frame = CGRectMake(10+i*CARVIEWWIDTH, 5, CARVIEWWIDTH, CARVIEWHIGHT);
            [self.waitScrollView addSubview:self.carView];
        }
    }
    if (workOrderFlag == 2) {
            if (self.finshedCarsArr.count > 4) {
                self.finshScrollView.contentSize = CGSizeMake(self.finshedCarsArr.count*CARVIEWWIDTH, FINSHSCROLLVIEW_HEIGHT);
            }
            else
            {
                self.finshScrollView.contentSize = CGSizeMake(LEFTVIEW_WIDTH, FINSHSCROLLVIEW_HEIGHT);
            }

        for (int i = 0; i < self.finshedCarsArr.count; i++) {
            NSDictionary *finshedCarsDic = [[NSDictionary alloc]initWithDictionary:[self.finshedCarsArr objectAtIndex:i]];
             [self.stationCarModel mts_setValuesForKeysWithDictionary:finshedCarsDic];
            self.carView = [[CarView alloc]init];
            [self.carView initCarViewWithCarModel:self.stationCarModel];
            self.carView.frame = CGRectMake(10+i*CARVIEWWIDTH, 10, CARVIEWWIDTH, CARVIEWHIGHT);
            [self.finshScrollView addSubview:self.carView];
        }
        NSLog(@"_________%@",self.stationCarModel);
    }
    if (workOrderFlag == 1) {
        if (self.stationServiceArr.count > 9) {
            self.constructionScrollView.contentSize = CGSizeMake(LEFTVIEW_WIDTH, self.stationServiceArr.count * CONSTRUCTIONSCROLLVIEW_HEIGHT);
        }
        else
        {
             self.constructionScrollView.contentSize = CGSizeMake(LEFTVIEW_WIDTH,715);
        }
       
            for (int i = 0; i < self.serviceArr.count; i ++) {
                    ConstationCarView *constationCarView = [[ConstationCarView alloc]init];

            NSDictionary *stationServiceDic = [[NSDictionary alloc]initWithDictionary:[self.serviceArr objectAtIndex:i]];
             [self.stationModel mts_setValuesForKeysWithDictionary:stationServiceDic];
            [constationCarView initConstationCarViewWithStationModel:self.stationModel AndStationCarModel:nil AndType:0];
           
            if (i < self.inConstructionCarsArr.count) {
                NSDictionary *inConstructionCarsDic = [[NSDictionary alloc]initWithDictionary:[self.inConstructionCarsArr objectAtIndex:i]];
                [self.stationCarModel mts_setValuesForKeysWithDictionary:inConstructionCarsDic];
                [constationCarView initConstationCarViewWithStationModel:self.stationModel AndStationCarModel:self.stationCarModel AndType:1];

            }
            
            constationCarView.frame = CGRectMake(0, 10+79*i, 538, 79);
            [self.constructionScrollView addSubview:constationCarView];
            
        }
        
    }
   }

//消除cell选择痕迹
- (void)deselect
{
    [self.fastToOrderTable deselectRowAtIndexPath:[self.fastToOrderTable indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)tapLeftViewCover:(UIControl *)sender {
    self.orderInfoView.frame = CGRectMake(-1024, 45, 588, 1003);
    self.leftViewCover.frame = CGRectMake(-1024, 45, 100, 1003);
}
#pragma mark - property
- (StationOrderModel *)stationOrderModel
{
    if (!_stationOrderModel) {
        _stationOrderModel = [[StationOrderModel alloc]init];
    }
    return _stationOrderModel;
}

-(StationCarModel *)stationCarModel
{
    if (!_stationCarModel) {
        _stationCarModel = [[StationCarModel alloc]init];
    }
    return _stationCarModel;
}


-(FastToOrderModel *)fastToOrderModel
{
    if (!_fastToOrderModel) {
        _fastToOrderModel = [[FastToOrderModel alloc]init];
    }
    return _fastToOrderModel;
}

-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}
//初始化infoView
-(void)initInfoView
{
    NSString *carBrand = self.stationOrderModel.car_brand;
    NSString *carModel = self.stationOrderModel.car_model;
    self.carBrandModel.text = [NSString stringWithFormat:@"%@ %@",carBrand,carModel];
    
    NSInteger sexInt = [self.stationOrderModel.customer_sex integerValue];
    if (sexInt == 1) {
        self.customerSex.text = @"女";
    }
    else
    {
        self.customerSex.text = @"男";
    }
    
    NSInteger propertyInt = [self.stationOrderModel.customer_property integerValue];
    if (propertyInt == 0) {
        self.customerProperty.text = @"个人";
        self.customerGroup.text = @" ";
    }
    else
    {
        self.customerProperty.text = @"单位";
        
    }
    self.orderCode.text = self.stationOrderModel.order_code;
    self.customerName.text = self.stationOrderModel.customer_name;
    self.carNum.text = self.stationOrderModel.car_num;
    self.customerPhone.text = self.stationOrderModel.customer_phone;
    self.carYear.text = self.stationOrderModel.car_year;
    self.carDistance.text = self.stationOrderModel.car_distance;
    self.customerGroup.text = self.stationOrderModel.customer_group;
    self.carVIN.text = self.stationOrderModel.car_vin;
   
    
}

- (IBAction)moveInconstructionCarView:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.constructionScrollView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        for (UIView *subView in [self.constructionScrollView subviews]) {
            if ([subView isKindOfClass:[ConstationCarView class]]) {
                
                CarView *carView = [((ConstationCarView*)subView) carView];
                CGRect carRect = [subView convertRect:carView.frame toView:self.constructionScrollView];
                if ([subView isKindOfClass:[ConstationCarView class]] && CGRectContainsPoint(carRect, point) && ![((ConstationCarView *)subView) isEmpty]) {
                    
                    self.moveCarView = [carView copyCarView];
                    self.constationCarView = (ConstationCarView*)subView;
                    self.moveCarView.station_id= self.constationCarView.station_id;
                    NSLog(@"----------%@",self.moveCarView.station_id);
                    [self.leftBackgroundView addSubview:self.moveCarView];
                    self.moveCarView.beforeMoiveRect = carRect;
                    self.moveCarView.parentViewRect = subView.frame;
                    [self.moveCarView setHidden:YES];
                    self.constationCarView.isEmpty = YES;
                    self.isScrollMiddleScrollView = NO;
                    break;
                }
            }
        }
    }
    else
        if (sender.state == UIGestureRecognizerStateEnded) {
            if (self.moveCarView) {
                //drag down
//                if (CGRectGetMaxX(self.moveCarView.frame) - CGRectGetMinX(self.finshScrollView.frame) > 20) {
                 if ((self.constructionScrollView.contentOffset.y) - CGRectGetMinX(self.finshScrollView.frame) > 20) {
                [self moveCarViewFromBeginningScrollViewIntoBottomRightScrollView:self.moveCarView
                 ];
                }else
                {
                    //drag exchang
                  [self exchangeBeginningCarCellViewPositionWithTouchView:self.moveCarView];
                }
                
                self.moveCarView.frame = self.moveCarView.beforeMoiveRect;
                [self.moveCarView removeFromSuperview];
                self.moveCarView = nil;
                self.constationCarView = nil;
            }
            
        }
    

    else{
        if (self.moveCarView) {
            CGPoint movepoint = [sender locationInView:self.leftBackgroundView];
            if (CGRectGetMaxY(self.leftView.frame) < CGRectGetMaxY(self.moveCarView.frame) ) {
                [self.constructionScrollView startScrollContentWithStep:79/4];
                self.isScrollMiddleScrollView = YES;
            }else
                if (CGRectGetMinY(self.moveCarView.frame) <= 0 && !self.isScrollMiddleScrollView) {
                    [self.constructionScrollView startScrollContentWithStep:-79/4];
                    self.isScrollMiddleScrollView = YES;
                }else
                    if (self.isScrollMiddleScrollView) {
                        if (movepoint.y < self.moveCarView.center.y && CGRectGetMaxY(self.leftBackgroundView.frame) <= CGRectGetMaxY(self.moveCarView.frame)) {
                            [self.constructionScrollView stopScroll];
                            self.moveCarView.center = movepoint;
                            self.isScrollMiddleScrollView = NO;
                        }else
                            if (movepoint.y > self.moveCarView.center.y && CGRectGetMinY(self.moveCarView.frame) <= 0) {
                                [self.constructionScrollView stopScroll];
                                self.moveCarView.center = movepoint;
                                self.isScrollMiddleScrollView = NO;
                            }else{
                                self.moveCarView.center = (CGPoint){(CGRectGetMaxY(self.moveCarView.frame) < CGRectGetMaxY(self.leftBackgroundView.frame) || CGRectGetMinY(self.moveCarView.frame) >=0)?movepoint.y:self.moveCarView.center.y,movepoint.x};
                            }
                    }
                    else{
                        self.moveCarView.center = movepoint;
                        [self.moveCarView setHidden:NO];
                    }
        }
    }

}

-(void)moveCarViewFromBeginningScrollViewIntoBottomRightScrollView:(CarView *)carView{
    StationCarModel *carObj = [self.beginningCarsDic objectForKey:[NSString stringWithFormat:@"%@",carView.station_id]];
    [self.finishedCarsArr insertObject:carObj atIndex:0];
    [self.beginningCarsDic removeObjectForKey:[NSString stringWithFormat:@"%@",carView.station_id]];
    
    CGRect rect = (CGRect){CELL_PADDING,CELL_PADDING,CELL_WIDHT,CELL_HEIGHT};
    for (UIView *subView in [self.finshScrollView subviews]) {
        [subView removeFromSuperview];
    }
    for (int index = 0; index < [self.finishedCarsArr count]; index++) {
        CarView *view = [[CarView alloc] init];
        view.frame = (CGRect){CELL_PADDING+(CELL_WIDHT+CELL_PADDING)*(index-1),CELL_PADDING*2,CELL_WIDHT,CELL_HEIGHT-CELL_PADDING*4};
        view.tag = index;
        StationCarModel *obj = [self.finishedCarsArr objectAtIndex:index];
        view.carNumber = obj.carPlateNumber;
        view.state = CARPAYING;
//        view.delegate = self;
        if (index == 0) {
            [view setHidden:YES];
        }
        [self.finshScrollView addSubview:view];
    }
    
    self.finshScrollView.tag = -1;
    [UIView animateWithDuration:0.5 animations:^{
        for (int index = 0; index < [self.finishedCarsArr count]; index++) {
            CarView *view = (CarView*)[self.finshScrollView viewWithTag:index];
            view.frame = CGRectMake(10+index*CARVIEWWIDTH, 15, CARVIEWWIDTH, CARVIEWHIGHT);
        }
        carView.frame = [self.finshScrollView convertRect:rect toView:self.leftBackgroundView];
    } completion:^(BOOL finished) {
        CarView *view = (CarView*)[self.finshScrollView viewWithTag:0];
        [view setHidden:NO];
        [carView removeFromSuperview];
        self.finshScrollView.contentSize = (CGSize){(CELL_WIDHT+CELL_PADDING)*[self.finishedCarsArr count]+CELL_PADDING,CGRectGetHeight(self.finshScrollView.frame)};
        [self didMoveCarCellFromBeginningScrollViewToBottomLeftScrollViewCellPosionFromIndex:[carView.station_id intValue] toIndex:0 orCarObj:carObj];
    }];
}

#pragma mark 施工完成

static NSString *work_order_id = nil;
static NSMutableDictionary *finish_dic = nil;
-(void)didMoveCarCellFromBeginningScrollViewToBottomLeftScrollViewCellPosionFromIndex:(int)from toIndex:(int)to orCarObj:(StationCarModel*)fromObj{

    {
        finish_dic = [[NSMutableDictionary alloc]init];
        [finish_dic setObject:[NSString stringWithFormat:@"%d",from] forKey:@"from"];
        [finish_dic setObject:[NSString stringWithFormat:@"%d",to] forKey:@"to"];
        [finish_dic setObject:fromObj forKey:@"carObj"];
        work_order_id = fromObj.workOrder_id;
    }
}

-(void)getData{
    NSDictionary *constrDic = [Utility initWithJSONFile:@"construction"];

    [self setRespondtext:constrDic];

    
}
-(void)setRespondtext:(NSDictionary *)jsonObject {
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            if ([[jsonData objectForKey:@"status"]intValue] == 0) {
                //工位数组
                NSArray *station_array = [jsonData objectForKey:@"station_ids"];
                               
                self.stationArray = [[NSMutableArray alloc]init];
                
                if (station_array.count>0) {
                    for (int k=0; k<station_array.count; k++) {
                        NSDictionary *s_dic = [station_array objectAtIndex:k];
                        StationModel *stationM = [[StationModel alloc]init];
                        stationM.station_id = [s_dic objectForKey:@"id"];
                        stationM.name = [s_dic objectForKey:@"name"];
                        [self.stationArray addObject:stationM];
                    }
                }
                [self setBegningScrollViewContextWithPosionCount:self.stationArray];
                //服务
                NSArray *result_array = [NSArray arrayWithArray:[jsonData objectForKey:@"services"]];
                self.dataArray = [[NSMutableArray alloc]init];
                ServiceModel *service = [[ServiceModel alloc]init];

                if (result_array.count>0) {
                    for (int i=0; i<result_array.count; i++) {
                        NSDictionary *dic = [result_array objectAtIndex:i];
                        
                        
                        service.service_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                        service.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                        service.price = [NSString stringWithFormat:@"%@.00元",[dic objectForKey:@"price"]];
                       
                        [self.dataArray addObject:service];
                        
                    }
                }
               
                [self.fastToOrderTable reloadData];
                //订单的数组
                NSDictionary *order_dic = [jsonData objectForKey:@"work_orders"];
                [self setStationDataWithDic:order_dic];
     
            }
        }
    }
}

-(void)setBegningScrollViewContextWithPosionCount:(NSArray *)array {
    for (UIView *posion in self.posionItemArr) {
        [posion removeFromSuperview];
    }
    [self.posionItemArr removeAllObjects];
    
    for (int index = 0; index < [array count]; index++) {
        
         self.constructionScrollView.contentSize = CGSizeMake(LEFTVIEW_WIDTH, [array count] * CONSTRUCTIONSCROLLVIEW_HEIGHT);
        
        ConstationCarView *view = [[ConstationCarView alloc] init];
        view.tag = -1;
        StationModel *ss = (StationModel *)[array objectAtIndex:index];
        view.station_id= ss.station_id;
        view.isEmpty = YES;
        view.posinName = ss.name;
        view.frame = [self getBeginningScrollViewItemRectWithIndex:index];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        [self.constructionScrollView addSubview:view];
        [self.posionItemArr addObject:view];
    }
}

-(void)addGestureToConstationCarView:(ConstationCarView *)constationCarView
{
  
//    CGPoint point = [sender locationInView:self.constructionScrollView];
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        for (UIView *subView in [self.constructionScrollView subviews]) {
//            if ([subView isKindOfClass:[ConstationCarView class]]) {
//                
//                CarView *carView = [((ConstationCarView*)subView) carView];
//                CGRect carRect = [subView convertRect:carView.frame toView:self.constructionScrollView];
//                if ([subView isKindOfClass:[ConstationCarView class]] && CGRectContainsPoint(carRect, point)  ) {
//                    
//                    self.moveCarView = [carView copyCarView];
//                    self.constationCarView = (ConstationCarView*)subView;
//                    self.moveCarView.station_id= self.constationCarView.station_id;
//                    NSLog(@"----------%@",self.moveCarView.station_id);
//                    [self.leftBackgroundView addSubview:self.moveCarView];
//                    self.moveCarView.beforeMoiveRect = carRect;
//                    self.moveCarView.parentViewRect = subView.frame;
//                    [self.moveCarView setHidden:YES];
//                    self.constationCarView.isEmpty = YES;
//                    self.isScrollMiddleScrollView = NO;
//                    break;
//                }
//            }
//        }
//    }

//    if (!constationCarView.isEmpty) {
//        constationCarView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkOrder:)];
////        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]init];
//        [constationCarView addGestureRecognizer:singleTap];
//      
////         NSLog(@"%@_________%@",constationCarView.order_id,constationCarView.station_id);
//    }
   
   }

#pragma mark 重置工位情况
-(void)setStationDataWithDic:(NSDictionary *)order_dic {
    self.waittingCarsArr = [[NSMutableArray alloc]init];
    self.beginningCarsDic = [[NSMutableDictionary alloc]init];
    self.finishedCarsArr = [[NSMutableArray alloc]init];
    
    //排队等候
    if (![[order_dic objectForKey:@"0"]isKindOfClass:[NSNull class]] && [order_dic objectForKey:@"0"]!= nil) {
        NSArray *waiting_array = [order_dic objectForKey:@"0"];
        if (waiting_array.count>0) {
            for (int i=0; i<waiting_array.count; i++) {
                NSDictionary *resultt = [waiting_array objectAtIndex:i];
                StationCarModel *order = [self setAttributeWithDictionary:resultt];
                [self.waittingCarsArr addObject:order];
            }
        }
    }
    [self setWaittingScrollViewContext];
    //施工中
    if (![[order_dic objectForKey:@"1"]isKindOfClass:[NSNull class]] && [order_dic objectForKey:@"1"]!= nil) {
        NSArray *working_array = [order_dic objectForKey:@"1"];
        if (working_array.count>0) {
            for (int i=0; i<working_array.count; i++) {
                NSDictionary *resultt = [working_array objectAtIndex:i];
                StationCarModel *order = [self setAttributeWithDictionary:resultt];
                [self.beginningCarsDic setValue:order forKey:order.station_id];
                
            }
        }
    }
    [self moveCarIntoCarPosion];
    //等待付款
    if (![[order_dic objectForKey:@"2"]isKindOfClass:[NSNull class]] && [order_dic objectForKey:@"2"]!= nil) {
        NSArray *finish_array = [order_dic objectForKey:@"2"];
        if (finish_array.count>0) {
            for (int i=0; i<finish_array.count; i++) {
                
                NSDictionary *resultt = [finish_array objectAtIndex:i];
                StationCarModel *order = [self setAttributeWithDictionary:resultt];
                [self.finishedCarsArr addObject:order];

            }
        }
    }
    [self setFinishedScrollViewContext];
}

-(CGRect)getBeginningScrollViewItemRectWithIndex:(int)index{
        return (CGRect){0,10+79*index,538,79};
}

-(StationCarModel *)setAttributeWithDictionary:(NSDictionary *)result {
    
    StationCarModel *order = [[StationCarModel alloc]init];
    
    order.carPlateNumber = [NSString stringWithFormat:@"%@",[result objectForKey:@"car_num"]];
    order.order_id = [NSString stringWithFormat:@"%@",[result objectForKey:@"order_id"]];
    order.status =[NSString stringWithFormat:@"%@",[result objectForKey:@"status"]];
    if (![[result objectForKey:@"station_id"]isKindOfClass:[NSNull class]] && [result objectForKey:@"station_id"]!=nil) {
        order.station_id =[NSString stringWithFormat:@"%@",[result objectForKey:@"station_id"]];
    }
    order.serviceName = [NSString stringWithFormat:@"%@",[result objectForKey:@"service_name"]];
    order.lastTime = [NSString stringWithFormat:@"%@",[result objectForKey:@"cost_time"]];
    order.workOrder_id = [NSString stringWithFormat:@"%@",[result objectForKey:@"wo_id"]];
    if (![[result objectForKey:@"wo_started_at"]isKindOfClass:[NSNull class]] && [result objectForKey:@"wo_started_at"]!=nil) {
        order.serviceStartTime = [NSString stringWithFormat:@"%@",[result objectForKey:@"wo_started_at"]];
    }
    if (![[result objectForKey:@"wo_ended_at"]isKindOfClass:[NSNull class]] && [result objectForKey:@"wo_ended_at"]!=nil) {
        order.serviceEndTime = [NSString stringWithFormat:@"%@",[result objectForKey:@"wo_ended_at"]];
    }
    return order;
}

-(void)setWaittingScrollViewContext{
    for (UIView *subView in [self.waitScrollView subviews]) {
        [subView removeFromSuperview];
    }
    for (int index = 0; index < [self.waittingCarsArr count]; index++) {
        CarView *view = [[CarView alloc] init];
        view.frame = CGRectMake(CELL_PADDING+(CELL_WIDHT+CELL_PADDING)*index, 30, CELL_WIDHT, self.waitScrollView.frame.size.height-CELL_PADDING*4);
        view.frame = CGRectMake(10+index*CARVIEWWIDTH, 5, CARVIEWWIDTH, CARVIEWHIGHT);
        view.tag = index;
        StationCarModel *obj = [self.waittingCarsArr objectAtIndex:index];
        view.carNumber = obj.carPlateNumber;
        view.state = CARWAITTING;
        
        [self.waitScrollView addSubview:view];
    }
    self.waitScrollView.contentSize = CGSizeMake((CELL_WIDHT+CELL_PADDING)*self.waittingCarsArr.count+CELL_PADDING, self.waitScrollView.frame.size.height);
}

-(void)moveCarIntoCarPosion{
    
    for (int index = 0; index < [self.posionItemArr count]; index++) {
        ConstationCarView *posion = [self.posionItemArr objectAtIndex:index];
//        posion.isEmpty = NO;
        StationModel *ss = (StationModel *)[self.stationArray objectAtIndex:index];
        StationCarModel *obj = [self.beginningCarsDic objectForKey:[NSString stringWithFormat:@"%@",ss.station_id]];
       
        [posion setCarObj:obj];
         [self addGestureToConstationCarView:posion];
    }
}

-(void)setFinishedScrollViewContext{
    for (UIView *subView in [self.finshScrollView subviews]) {
        [subView removeFromSuperview];
    }
    for (int index = 0; index < [self.finishedCarsArr count]; index++) {
        CarView *view = [[CarView alloc] init];
        StationCarModel *obj = [self.finishedCarsArr objectAtIndex:index];
        view.carNumber = obj.carPlateNumber;
        view.state = CARPAYING;
        view.frame = CGRectMake(10+index*CARVIEWWIDTH, 15, CARVIEWWIDTH, CARVIEWHIGHT);
        view.tag = index;
        [self.finshScrollView addSubview:view];
    }
    self.finshScrollView.contentSize = CGSizeMake((CELL_WIDHT+CELL_PADDING)*self.finishedCarsArr.count+CELL_PADDING,self.finshScrollView.frame.size.height);
}

-(NSMutableArray *)posionItemArr{
    if (!_posionItemArr) {
        _posionItemArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _posionItemArr;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)exchangeBeginningCarCellViewPositionWithTouchView:(CarView*)touchView{
    for (ConstationCarView *subView in self.posionItemArr) {
        CGRect scrollRect = [self.leftBackgroundView convertRect:touchView.frame toView:self.constructionScrollView];
        if (CGRectContainsRect(subView.frame,scrollRect) && subView.station_id !=touchView.station_id) {
            
            StationCarModel *obj1 = [self.beginningCarsDic objectForKey:[NSString stringWithFormat:@"%@",touchView.station_id]];
            StationCarModel *obj2 = [self.beginningCarsDic objectForKey:[NSString stringWithFormat:@"%@",subView.station_id]];
            [self.beginningCarsDic setValue:obj1 forKey:[NSString stringWithFormat:@"%@",subView.station_id]];
            [self.beginningCarsDic setValue:obj2 forKey:[NSString stringWithFormat:@"%@",touchView.station_id]];
            [self.constationCarView setCarObj:obj2];
            [subView setCarObj:obj1];
            [self didExchangeBeginningCarCellPosionFromIndex:[touchView.station_id intValue] toIndex:[subView.station_id intValue] orFromCarObj:obj1 toCarObj:obj2];
            return;
        }
    }
    
    [self.constationCarView setIsEmpty:NO];
    
}

#pragma mark 调整工位
static NSString *work_order_id_station_id = nil;
static NSMutableDictionary *work_dic = nil;
-(void)didExchangeBeginningCarCellPosionFromIndex:(int)from toIndex:(int)to orFromCarObj:(StationCarModel*)fromObj toCarObj:(StationCarModel*)toObj{
    {
        work_dic = [[NSMutableDictionary alloc]init];
        [work_dic setObject:[NSString stringWithFormat:@"%d",from] forKey:@"from"];
        [work_dic setObject:[NSString stringWithFormat:@"%d",to] forKey:@"to"];
        [work_dic setObject:fromObj forKey:@"fromObj"];
        if (toObj) {
            work_order_id_station_id = [NSString stringWithFormat:@"%@_%@,%@_%@",toObj.workOrder_id,fromObj.station_id,fromObj.workOrder_id,toObj.station_id];
            
            [work_dic setObject:toObj forKey:@"toObj"];
        }else {
            work_order_id_station_id = [NSString stringWithFormat:@"%@_%d",fromObj.workOrder_id,to];
        }
        
        if (work_order_id_station_id) {
        }
    }
}


@end
