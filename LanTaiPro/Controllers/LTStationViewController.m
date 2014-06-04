//
//  LTStationViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTStationViewController.h"
#define SELETED 100
#define UNSELETED 1000

@interface LTStationViewController ()

@end

@implementation LTStationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    [DataService sharedService].staffIdArr = [[NSMutableArray alloc]init];
    
    
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
        return 3;
    }
    if ([tableView isEqual:self.orderTable]) {
        return self.stationOrderModel.order_pro.count;
    }
    if ([tableView isEqual:self.staffTable]) {
        if (self.stationOrderModel.staff_store.count%2 == 0) {
            return self.stationOrderModel.staff_store.count/2;
        }
        else
        {
            return self.stationOrderModel.staff_store.count/2 + 1;
        }
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
        cell.textLabel.text = @"洗车服务";
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
        [cell.checkOrderBtn addTarget:self action:@selector(checkOrder:) forControlEvents:UIControlEventTouchUpInside];
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
   
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

//点击正在施工中的按钮，查看订单详情
-(void)checkOrder:(UIButton *)sender
{
    [self testGetorderInfo];
    self.orderInfoView.frame = CGRectMake(100, 45, 588, 1003);
    
    self.leftViewCover.frame = CGRectMake(5, 45, 100, 1003);
    
    [self initInfoView];
    [DataService sharedService].staffNameStr = [[NSMutableString alloc]init];
    [DataService sharedService].stationTotal = [[NSMutableString alloc]init];

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

- (void)testGetorderInfo{
    NSDictionary *aDic = [Utility initWithJSONFile:@"order_details"];
    [self.stationOrderModel mts_setValuesForKeysWithDictionary:aDic];

}

//消除cell选择痕迹
- (void)deselect
{
    [self.fastToOrderTable deselectRowAtIndexPath:[self.fastToOrderTable indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
