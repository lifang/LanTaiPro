//
//  LTAppointmentViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTAppointmentViewController.h"

//下拉刷新
#import "SVPullToRefresh.h"

@implementation LTAppointmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - property
- (AppointmentModel *)appointmentModel
{
    if (!_appointmentModel) {
        _appointmentModel = [[AppointmentModel alloc]init];
    }
    return _appointmentModel;
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}
#pragma mark - 获取预约信息
- (void)testGetAppointment{
    NSDictionary *aDic = [Utility initWithJSONFile:@"appointment"];
    [self.appointmentModel mts_setValuesForKeysWithDictionary:aDic];
    [self.appointmentTable reloadData];
}

- (void)getAppointmentInfos
{
    if (self.appDel.isReachable==NO) {
        [Utility errorAlert:@"请检查网络" dismiss:NO];
    }else {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kAppointmentInfo];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LTInterfaceBase request:params requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.appointmentModel mts_setValuesForKeysWithDictionary:dictionary];
                [self.appointmentTable reloadData];
            });
        }errorBlock:^(NSString *notice){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Utility errorAlert:notice dismiss:YES];
            });
        }];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isAccept = NO;
    [self testGetAppointment];
    
    //下拉刷新
    __block LTAppointmentViewController *appointViewControl = self;
    __block UITableView *table = self.appointmentTable;
    [_appointmentTable addPullToRefreshWithActionHandler:^{
        [appointViewControl testGetAppointment];
        [table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:(CGRect){0,0,CGRectGetWidth(tableView.bounds),50}];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-background.jpg"]];
    
    UIImageView *ImgView = [[UIImageView alloc]initWithFrame:(CGRect){10,10,30,30}];
    
    UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){50,10,200,30}];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:20];
    
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coverBtn.frame = headerView.frame;
    
    if (self.isAccept) {
        ImgView.image = [UIImage imageNamed:@"appoint-accept"];
        label.text = @"已受理预约单";
        [coverBtn addTarget:self action:@selector(showNormalList) forControlEvents:UIControlEventTouchUpInside];
    }else {
        ImgView.image = [UIImage imageNamed:@"appoint-normal"];
        label.text = @"已受理预约单";
        [coverBtn addTarget:self action:@selector(showAcceptList) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [headerView addSubview:ImgView];
    ImgView = nil;
    
    [headerView addSubview:label];
    label = nil;
    
    [headerView addSubview:coverBtn];
    coverBtn = nil;
    
    return headerView;
}
#pragma mark - header点击事件
-(void)showAcceptList
{
    self.isAccept = YES;
    [self.appointmentTable reloadData];
}
-(void)showNormalList
{
    self.isAccept = NO;
    [self.appointmentTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isAccept) {
        return self.appointmentModel.reservationsAccept.count;
    }else
        return self.appointmentModel.reservationsNormal.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"appointmentCell";
    
    AppointModel *appintModel = nil;
    if (self.isAccept) {
        appintModel = (AppointModel *)self.appointmentModel.reservationsAccept[indexPath.row];
    }else
        appintModel = (AppointModel *)self.appointmentModel.reservationsNormal[indexPath.row];
    
    AppointmentCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AppointmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier appoint:appintModel isAccept:self.isAccept];
    }
    cell.idxPath = indexPath;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppointModel *appintModel = nil;
    if (self.isAccept) {
        appintModel = (AppointModel *)self.appointmentModel.reservationsAccept[indexPath.row];
    }else{
        appintModel = (AppointModel *)self.appointmentModel.reservationsNormal[indexPath.row];
    }
    return 140+appintModel.appointProductList.count*30;
}
#pragma mark - cell的代理
//拒绝,受理,取消预约  store_id=1&reservation_id=1&types=4
-(void)buttonPressedWithBtn:(AppointButton *)btn
{
    if ([btn.type integerValue]==4) {
        
    }else {
        NSIndexPath *idxPath = btn.btnIndexPath;
        if (self.isAccept) {
            [self.appointmentModel.reservationsAccept removeObjectAtIndex:idxPath.row];
            [self.appointmentTable beginUpdates];
            [self.appointmentTable deleteRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.appointmentTable endUpdates];
            
            for (int i=idxPath.row; i<self.appointmentModel.reservationsAccept.count; i++) {
                NSIndexPath *tempIndex = [NSIndexPath indexPathForRow:i inSection:0];
                AppointmentCell *cell = (AppointmentCell *)[self.appointmentTable cellForRowAtIndexPath:tempIndex];
                cell.idxPath = tempIndex;
            }
        }else {
            [self.appointmentModel.reservationsNormal removeObjectAtIndex:idxPath.row];
            [self.appointmentTable beginUpdates];
            [self.appointmentTable deleteRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.appointmentTable endUpdates];
            
            for (int i=idxPath.row; i<self.appointmentModel.reservationsNormal.count; i++) {
                NSIndexPath *tempIndex = [NSIndexPath indexPathForRow:i inSection:0];
                AppointmentCell *cell = (AppointmentCell *)[self.appointmentTable cellForRowAtIndexPath:tempIndex];
                cell.idxPath = tempIndex;
            }
        }
    }
    DLog(@"############%d",btn.btnIndexPath.row);
    
    
    /*
    if (self.appDel.isReachable==NO) {
        [Utility errorAlert:@"请检查网络" dismiss:NO];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kAppointmentButton];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
        [params setObject:btn.reservation_id forKey:@"reservation_id"];
        [params setObject:btn.type forKey:@"types"];
        
        [LTInterfaceBase request:params requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.appointmentModel mts_setValuesForKeysWithDictionary:dictionary];
                [self.appointmentTable reloadData];
            });
        }errorBlock:^(NSString *notice){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Utility errorAlert:notice];
            });
        }];
    }
     */
}
-(void)confirmAcceptButtonPressed
{
    if (self.appDel.isReachable==NO) {
        [Utility errorAlert:@"请检查网络" dismiss:NO];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}
@end
