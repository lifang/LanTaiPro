//
//  ComplaintViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-18.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ComplaintViewController.h"

@interface ComplaintViewController ()

@end

@implementation ComplaintViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}

-(void)setInfoDic:(NSDictionary *)infoDic
{
    _infoDic = infoDic;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.lblCode.text = [self.infoDic objectForKey:ComplaintCode];
    self.lblCarNum.text = [self.infoDic objectForKey:ComplaintCarNum];
    self.lblProduct.text = [self.infoDic objectForKey:ComplaintProds];
    
    [self.reasonView becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSubmit:(id)sender
{
    [self.reasonView resignFirstResponder];
    [self.requestView resignFirstResponder];
    
    if (self.reasonView.text.length==0){
        [Utility errorAlert:@"请输入投诉理由" dismiss:YES];
    }else if (self.requestView.text.length==0){
        [Utility errorAlert:@"请输入您的建议或要求" dismiss:YES];
    }else {
        if (self.appDel.isReachable==NO) {
            BOOL success = NO;//记录添加本地是否成功
            LTDB *db = [[LTDB alloc]init];
            OrderModel *orderModel = [db getLocalOrderInfoWhereOid:[self.infoDic objectForKey:ComplaintOrderId]];
            if (orderModel != nil) {
                success = [db updateOrderInfoReason:self.reasonView.text Reaquest:self.requestView.text WhereOid:[self.infoDic objectForKey:ComplaintOrderId]];
            }else {
                orderModel = [[OrderModel alloc]init];
                
                orderModel.store_id = [LTDataShare sharedService].user.store_id;
                orderModel.order_id =[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:ComplaintOrderId]];
                orderModel.order_is_please = [NSString stringWithFormat:@"%d",0];
                orderModel.reason =[NSString stringWithFormat:@"%@",self.reasonView.text];
                orderModel.request =[NSString stringWithFormat:@"%@",self.requestView.text];
                orderModel.order_status = [NSString stringWithFormat:@"%d",2];
                
                success = [db saveOrderDataToLocal:orderModel];
            }
            if (success) {
                if ([self.delegate respondsToSelector:@selector(dismissComplaintViewControl:)]) {
                    [self.delegate dismissComplaintViewControl:self];
                }
            }else {
                [Utility errorAlert:@"添加评论失败" dismiss:YES];
            }
            
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kServiceBillingMakeOrder];
            
            NSMutableDictionary *paramas = [[NSMutableDictionary alloc] init];
            
            [paramas setObject:self.reasonView.text forKey:@"reason"];
            [paramas setObject:self.requestView.text forKey:@"request"];
            [paramas setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
            [paramas setObject:[self.infoDic objectForKey:ComplaintOrderId] forKey:@"order_id"];
            
            [LTInterfaceBase request:paramas requestUrl:urlString method:@"POST" completeBlock:^(NSDictionary *dictionary) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    
                });
            } errorBlock:^(NSString *notice) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    [Utility errorAlert:notice dismiss:YES];
                });
            }];
        }
    }
}

-(IBAction)clickCancle:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dismissComplaintViewControl:)]) {
        [self.delegate dismissComplaintViewControl:self];
    }
}
@end
