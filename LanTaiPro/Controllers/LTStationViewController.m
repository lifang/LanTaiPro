//
//  LTStationViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTStationViewController.h"
#import "CarModel.h"

#define SELETED 100
#define UNSELETED 1000
#define CARVIEWWIDTH 125
#define CARVIEWHIGHT 30
#define LEFTVIEW_WIDTH 538
#define WAITSCROLLVIEW_HEIGHT 80
#define FINSHSCROLLVIEW_HEIGHT 90

@interface LTStationViewController ()

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
//    self.orderInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userBackground"]];
    self.isFirst = YES;
    
    for (int i = 0; i < 3; i++) {
           [self testConstruction:i];
    }
    [self setCarviewWithCarsArr:self.waitCarsArr andWorkOrderFlag:0];
    [self setCarviewWithCarsArr:self.finshedCarsArr andWorkOrderFlag:2];
    
    [self.waitScrollView setShowsHorizontalScrollIndicator:NO];
    [self.finshScrollView setShowsHorizontalScrollIndicator:NO];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSeletedStaffs:) name:@"showSeletedStaffs" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTotal:) name:@"showTotal" object:nil];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    CGFloat cellHeiht = 44;
    if ([tableView isEqual:self.constructionTable]) {
        cellHeiht = 79;
    }
    return cellHeiht;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if ([tableView isEqual:self.constructionTable]) {
        return self.stationServiceArr.count;
    }
    else if ([tableView isEqual:self.orderTable]) {
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
        return self.serviceArr.count;
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
        NSString *identifier = @"fastToOrderCell";
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
         NSDictionary *serviceDic = [[NSDictionary alloc]initWithDictionary:[self.serviceArr objectAtIndex:indexPath.row]];
        [self.fastToOrderModel mts_setValuesForKeysWithDictionary:serviceDic];
        
        cell.textLabel.text = self.fastToOrderModel.serviceName;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:17];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [tableView setSeparatorColor:[UIColor clearColor]];
        return cell;
       }
    //正在施工的中的table
    if ([tableView isEqual:self.constructionTable]) {
        NSString *identifier = @"carCell";
        carCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[carCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [tableView setSeparatorColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *stationServiceDic = [[NSDictionary alloc]initWithDictionary:[self.stationServiceArr objectAtIndex:indexPath.row]];
        [self.stationModel mts_setValuesForKeysWithDictionary:stationServiceDic];
        [cell initcarcellStation:self.stationModel];
       
        if (indexPath.row < self.inConstructionCarsArr.count) {
             NSDictionary *inConstructionCarsDic = [[NSDictionary alloc]initWithDictionary:[self.inConstructionCarsArr objectAtIndex:indexPath.row]];
             [self.carModel mts_setValuesForKeysWithDictionary:inConstructionCarsDic];
            [cell initCarCellWithCarModel:self.carModel];
        }
//        [cell.checkOrderBtn addTarget:self action:@selector(checkOrder:) forControlEvents:UIControlEventTouchUpInside];
        return  cell;
    }
    //选择技师table
    if ([tableView isEqual:self.staffTable]) {
        NSString *identifier = @"staffCell";
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
        
        NSString *identifier = @"orderCell";
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
    if ([tableView isEqual:self.constructionTable]) {
        if (self.inConstructionCarsArr.count >indexPath.row) {
            [self checkOrder];
        }
    }
}

//点击正在施工中的按钮，查看订单详情
-(void)checkOrder
{
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

//对等待施工，等待确认付款的车辆赋值
-(void)setCarviewWithCarsArr:(NSMutableArray *)carsArr andWorkOrderFlag:(NSInteger)workOrderFlag
{
    self.carModel = [[CarModel alloc]init];
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
            [self.carModel mts_setValuesForKeysWithDictionary:waitCarsDic];
            self.carView = [[CarView alloc]init];
            [self.carView initCarViewWithCarModel:self.carModel];
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
             [self.carModel mts_setValuesForKeysWithDictionary:finshedCarsDic];
            self.carView = [[CarView alloc]init];
            [self.carView initCarViewWithCarModel:self.carModel];
            self.carView.frame = CGRectMake(10+i*CARVIEWWIDTH, 10, CARVIEWWIDTH, CARVIEWHIGHT);
            [self.finshScrollView addSubview:self.carView];


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

-(CarModel *)carModel
{
    if (!_carModel) {
        _carModel = [[CarModel alloc]init];
    }
    return _carModel;
}

-(StationModel*)stationModel
{
    if (!_stationModel) {
        _stationModel = [[StationModel alloc]init];
    }
    return _stationModel;
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
    
}
@end
