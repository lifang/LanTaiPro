//
//  LTUserInfoViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTUserInfoViewController.h"
#import "UserNowOrderCell.h"
#import "UserNowOrderOpenCell.h"
#import "UIViewController+MJPopupViewController.h"
//下拉刷新
#import "SVPullToRefresh.h"

@interface LTUserInfoViewController ()

@end

@implementation LTUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - property
- (UserOrderModel *)userOrder
{
    if (!_userOrder) {
        _userOrder = [[UserOrderModel alloc]init];
    }
    return _userOrder;
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}
#pragma mark - 获取用户本月订单信息
- (void)testGetOrderInfos{
    NSDictionary *aDic = [Utility initWithJSONFile:@"userInfo"];
    [self.userOrder mts_setValuesForKeysWithDictionary:aDic];
    
    //本月订单概况
    self.monthOrderCount.text = [NSString stringWithFormat:@"%@",self.userOrder.orderCount];
    self.monthOrderMoney.text = [NSString stringWithFormat:@"%@",self.userOrder.orderMoney];
    
    [self.orderTable reloadData];
}
- (void)getOrderInfos {
    if (self.appDel.isReachable==NO) {
        [Utility errorAlert:@"请检查网络" dismiss:NO];
    }else {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kUserInfo];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:[LTDataShare sharedService].user.user_id forKey:@"user_id"];
        [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LTInterfaceBase request:params requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.userOrder mts_setValuesForKeysWithDictionary:dictionary];
                
                //本月订单概况
                self.monthOrderCount.text = [NSString stringWithFormat:@"%@",self.userOrder.orderCount];
                self.monthOrderMoney.text = [NSString stringWithFormat:@"%@",self.userOrder.orderMoney];
                
                [self.orderTable reloadData];
                
            });
            
        }errorBlock:^(NSString *notice){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Utility errorAlert:notice dismiss:NO];
            });
        }];
    }
}
#pragma mark - 头像设置圆的
- (void)roundView: (UIView *) view
{
    [view.layer setCornerRadius:(view.frame.size.height/2)];
    [view.layer setMasksToBounds:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //用户信息
    [self roundView:self.userImageView];
    [self.userImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,[LTDataShare sharedService].user.userImg]] placeholderImage:[UIImage imageNamed:@"nonPic"]];
    
    self.userNameLabel.text = [NSString stringWithFormat:@"%@",[LTDataShare sharedService].user.name];
    self.userPostLabel.text = [NSString stringWithFormat:@"%@",[LTDataShare sharedService].user.userPost];
    
    [self getOrderInfos];
    
    //下拉刷新
    __block LTUserInfoViewController *userViewControl = self;
    __block UITableView *table = self.orderTable;
    [_orderTable addPullToRefreshWithActionHandler:^{
        [userViewControl getOrderInfos];
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
    UILabel *header = [[UILabel alloc] initWithFrame:(CGRect){0,0,CGRectGetWidth(tableView.bounds),50}];
    [header setTextColor:[UIColor whiteColor]];
    header.backgroundColor = self.view.backgroundColor;
    [header setFont:[UIFont fontWithName:@"HiraginoSansGB-W6" size:26]];

    header.text = @"当前订单";
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userOrder.orderNowList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserNowOrderModel *userNowOrder = (UserNowOrderModel *)self.userOrder.orderNowList[indexPath.row];
    if (userNowOrder.isOpen) {
        static NSString * identifier = @"userNowOrderOpenCell";
        
        UserNowOrderOpenCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UserNowOrderOpenCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier userNowOrderModel:userNowOrder];
        }
        
        return cell;
        
    }else {
        static NSString * identifier = @"userNowOrderCell";
        UserNowOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UserNowOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.orderCodeLabel.text = [NSString stringWithFormat:@"%@",userNowOrder.orderCode];
        cell.orderNumLabel.text = [NSString stringWithFormat:@"%@",userNowOrder.orderNum];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserNowOrderModel *userNowOrder = (UserNowOrderModel *)self.userOrder.orderNowList[indexPath.row];
    if (userNowOrder.isOpen) {
        return 88+(userNowOrder.productList.count+1)*30;
    }else
        return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserNowOrderModel *userNowOrder = (UserNowOrderModel *)self.userOrder.orderNowList[indexPath.row];
    userNowOrder.isOpen = !userNowOrder.isOpen;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 弹出用户
- (IBAction)showUserBtnPressed:(id)sender {
    LTLocalUserViewController *localViewControl = [[LTLocalUserViewController alloc]initWithNibName:@"LTLocalUserViewController" bundle:nil];
    localViewControl.delegate = self;
    [self presentPopupViewController:localViewControl animationType:MJPopupViewAnimationSlideBottomTop width:140];
}

#pragma mark - LTLocalUserViewController代理
- (void)disMissViewControl:(LTLocalUserViewController *)viewControl
{
    __block LTLocalUserViewController *localViewControl = viewControl;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop dismissBlock:^(BOOL isFinish) {
        if (isFinish) {
            if (localViewControl.page==0) {
                [[AppDelegate shareIntance]showLogViewController];
            }else if(localViewControl.page==1){
                [[AppDelegate shareIntance] showRootViewController];
            }else if(localViewControl.page==2){
                
            }
            localViewControl = nil;
        }
    }];
}
@end
