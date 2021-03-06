//
//  PayStyleViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-19.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "PayStyleViewController.h"


const CGFloat kScroll1ObjHeight	= 40;
const CGFloat kScroll1ObjWidth	= 120;

@interface PayStyleViewController ()

@end

@implementation PayStyleViewController

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
-(SVSegmentedControl *)segBtn
{
    if (!_segBtn) {
        _segBtn = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"现金",@"储值卡", @"免单",nil]];
        [_segBtn addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        _segBtn.crossFadeLabelsOnDrag = YES;
        _segBtn.thumb.tintColor = [UIColor redColor];
        _segBtn.frame = CGRectMake(90, 90, 244, 40);
        _segBtn.backgroundImage = [UIImage imageNamed:@"payType"];
        _segBtn.isCanSelected = YES;
        _segBtn.selectedIndex = 0;
    }
    return _segBtn;
}
#pragma mark - 支付方式
- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl
{
    if (segmentedControl.selectedIndex == 0)//现金
    {
        [self pay:0];
    }
    else if (segmentedControl.selectedIndex == 1 && self.orderDic)//储值卡
    {
//        if(self.save_cardArray.count==0) {
//            [Utility errorAlert:@"您没有合适的储值卡" dismiss:YES];
//        }else {
        [UIView transitionFromView:self.payStyleView
                            toView:self.cardView
                          duration: 1.0f
                           options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                        completion:^(BOOL finished) {
                            if (finished) {
                                self.pageValue = 1;
                                [self.view bringSubviewToFront:self.quitButton];
                            }
                        }
         ];
//        }
    }
    else if (segmentedControl.selectedIndex == 2)//免单
    {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:kTitle message:@"确定免单?"];
        
        [alert setCancelButtonWithTitle:@"" block:nil];
        [alert addButtonWithTitle:@"" block:^{
            [self pay:5];
        }];
        [alert show];
    }
}

#pragma mark - 退出
-(IBAction)quitPayViewcontrol:(id)sender
{
    self.isSuccess = NO;
    [self.delegate dismissPayStyleViewController:self];
}

#pragma mark - 储值卡按钮
- (void)layoutScrollButtons
{
	UIButton *btn = nil;
	NSArray *subviews = [self.scrollView subviews];
    
	CGFloat curXLoc = 0;
	for (btn in subviews)
	{
		if ([btn isKindOfClass:[UIButton class]] && btn.tag >= 0)
		{
			CGRect frame = btn.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			btn.frame = frame;
			
			curXLoc += (kScroll1ObjWidth);
		}
	}
	[self.scrollView setContentSize:CGSizeMake((self.save_cardArray.count * kScroll1ObjWidth), [self.scrollView bounds].size.height)];
}

#pragma mark - 对储值卡余额排序
- (void)bubbleSort:(NSMutableArray *)array
{
    int i, y;
    BOOL bFinish = YES;
    for (i = 1; i<= [array count] && bFinish; i++) {
        bFinish = NO;
        for (y = (int)[array count]-1; y>=i; y--) {
            NSDictionary * sv_dic1 = (NSDictionary *)[array objectAtIndex:y];
            NSDictionary * sv_dic2 = (NSDictionary *)[array objectAtIndex:y-1];
            if (([[sv_dic1 objectForKey:@"l_price"] floatValue] - [[sv_dic2 objectForKey:@"l_price"] floatValue])>0.000001) {
                [array exchangeObjectAtIndex:y-1 withObjectAtIndex:y];
                bFinish = YES;
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImage.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImage.image = [[UIImage imageNamed:@"alert-window"]stretchableImageWithLeftCapWidth:0 topCapHeight:38];
    self.backgroundImage.layer.masksToBounds = YES;
    self.backgroundImage.layer.shadowRadius = 5;
    
    [self.payStyleView addSubview:self.segBtn];
    [self.view sendSubviewToBack:self.backgroundImage];
    [self.view sendSubviewToBack:self.cardView];
    [self.view sendSubviewToBack:self.passView];
    [self.view bringSubviewToFront:self.quitButton];
    self.sv_relation_id = nil;
    
    self.payType = -1;
    self.pageValue = 0;
    self.codeBtn.userInteractionEnabled = YES;
    
    /////////////////////////////////////////对储值卡按金额由高到低排序
    [self bubbleSort:self.save_cardArray];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    UIButton *button = nil;
	NSArray *subviews = [self.scrollView subviews];
	for (button in subviews)
	{
		if ([button isKindOfClass:[UIButton class]])
		{
            [button removeFromSuperview];
		}
	}
    for(int i = 0; i < [self.save_cardArray count]; i++){
        NSDictionary * sv_dic = [self.save_cardArray objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"%@",[sv_dic objectForKey:@"card_name"]] forState:UIControlStateNormal];
        btn.tag = i;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cardbuttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            //计算余额
            CGFloat left_price = [[sv_dic objectForKey:@"l_price"]floatValue];
            if (left_price - [[self.orderDic objectForKey:@"total_price"]floatValue]>=0) {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
                self.sv_relation_id = [NSString stringWithFormat:@"%@",[sv_dic objectForKey:@"customer_save_id"]];
            }else {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
            }
        }else {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
        }
        
        CGRect rect = btn.frame;
        rect.size.height = kScroll1ObjHeight;
        rect.size.width = kScroll1ObjWidth;
        btn.frame = rect;
        
        [self.scrollView addSubview:btn];
    }
    [self layoutScrollButtons];
    
}

#pragma mark - 选择储值卡
-(void)cardbuttonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSDictionary * sv_dic = [self.save_cardArray objectAtIndex:button.tag];
    //计算余额
    CGFloat left_price = [[sv_dic objectForKey:@"l_price"]floatValue];
    if (left_price - [[self.orderDic objectForKey:@"total_price"]floatValue]>=0) {
        self.sv_relation_id = [NSString stringWithFormat:@"%@",[sv_dic objectForKey:@"customer_save_id"]];
        
        for(UIButton *btn in [self.scrollView subviews]){
            if ([btn isKindOfClass:[UIButton class]]){
                if(btn.tag == button.tag){
                    [UIView animateWithDuration:0.5f animations:^{
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
                    }];
                }else{
                    [UIView animateWithDuration:0.5f animations:^{
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
                    }];
                }
            }
        }
    }else {
        [Utility errorAlert:@"此卡余额不足!" dismiss:YES];
    }
    DLog(@"sv = %@",self.sv_relation_id);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 支付：type
- (void)pay:(int)type
{
    self.payType = type;
    if (self.orderDic) {
        NSString *billing = @"1";
        if (self.billingBtn.isOn) {
            billing = @"1";
        }else{
            billing = @"0";
        }
        NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithDictionary:self.orderDic];
        [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
        [params setObject:billing forKey:@"billing"];
        [params setObject:[NSNumber numberWithInt:self.payType] forKey:@"pay_type"];
        
        if (self.payType == 5) {
            [params setObject:[NSNumber numberWithInt:1] forKey:@"is_free"];
        }else if (self.payType == 1){
            [params setObject:[NSNumber numberWithInt:0] forKey:@"is_free"];
            [params setObject:[NSString stringWithFormat:@"%@",self.sv_relation_id] forKey:@"csrid"];
            [params setObject:self.txtPwd.text forKey:@"password"];
        }else {
            [params setObject:[NSNumber numberWithInt:0] forKey:@"is_free"];
        }
        
        if (self.appDel.isReachable==NO) {
            if (self.payType == 1) {
                [Utility errorAlert:@"无网络情况下不支持储值卡付款" dismiss:YES];
            }else{
                BOOL isFinish = NO;
                LTDB *db = [[LTDB alloc]init];
                OrderModel *orderModel = [db getLocalOrderInfoWhereOid:[params objectForKey:@"order_id"]];
                if (orderModel != nil) {
                    orderModel.order_is_please = [NSString stringWithFormat:@"%@",[params objectForKey:@"is_please"]];
                    orderModel.order_total_price = [NSString stringWithFormat:@"%@",[params objectForKey:@"total_price"]];
                    orderModel.order_prods = [NSString stringWithFormat:@"%@",[params objectForKey:@"prods"]];
                    orderModel.order_billing = [NSString stringWithFormat:@"%@",[params objectForKey:@"billing"]];
                    orderModel.order_pay_type = [NSString stringWithFormat:@"%@",[params objectForKey:@"pay_type"]];
                    orderModel.order_is_free = [NSString stringWithFormat:@"%@",[params objectForKey:@"is_free"]];
                    orderModel.order_status = [NSString stringWithFormat:@"%d",1];
                }else {
                    orderModel = [OrderModel orderModelFromDic:params];
                    orderModel.order_status = [NSString stringWithFormat:@"%d",1];
                }
                
                isFinish = [db saveOrderDataToLocal:orderModel];
                
                if (isFinish) {
                    self.isSuccess = YES;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissPayStyleViewController:)]) {
                        [self.delegate dismissPayStyleViewController:self];
                    }
                }else {
                    [Utility errorAlert:@"付款失败!" dismiss:NO];
                }
            }
        }else{
            [MBProgressHUD showHUDAddedTo:self.appDel.window animated:YES];
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kPayByAPP];

            [LTInterfaceBase request:params requestUrl:urlString method:@"POST" completeBlock:^(NSDictionary *dictionary) {
                NSDictionary *stationDic = [dictionary objectForKey:@"work_orders"];
                [LTDataShare sharedService].stationDic = [NSMutableDictionary dictionaryWithDictionary:stationDic];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];

                    self.isSuccess = YES;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissPayStyleViewController:)]) {
                        [self.delegate dismissPayStyleViewController:self];
                    }
                });
            } errorBlock:^(NSString *notice) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
                    [Utility errorAlert:notice dismiss:YES];
                });
            }];
            
        }
    }
}

#pragma mark - 页面返回

-(IBAction)goBackBtnPressed:(id)sender
{
    if (self.pageValue == 1) {
        [UIView transitionFromView:self.cardView
                            toView:self.payStyleView
                          duration: 1.0f
                           options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                        completion:^(BOOL finished) {
                            if (finished) {
                                self.pageValue = 0;
                                [self.view bringSubviewToFront:self.quitButton];
                            }
                        }
         ];
    }else if (self.pageValue == 2) {
        [UIView transitionFromView:self.passView
                            toView:self.cardView
                          duration: 1.0f
                           options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                        completion:^(BOOL finished) {
                            if (finished) {
                                self.pageValue = 1;
                                [self.view bringSubviewToFront:self.quitButton];
                            }
                        }
         ];
    }
}

#pragma mark  储值卡付款页面

- (IBAction)clickCardSureBtn:(id)sender
{
    [self.txtPwd resignFirstResponder];
    if (self.sv_relation_id != nil) {
        NSString *regexCall = @"\\d{6}";
        NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
        if ([predicateCall evaluateWithObject:self.txtPwd.text]) {
            if (self.appDel.isReachable==NO) {
                [Utility errorAlert:@"请检查网络" dismiss:YES];
            }else{
                [self pay:1];
            }
        }else {
            [Utility errorAlert:@"请输入正确的密码!" dismiss:YES];
        }
    }else {
        [Utility errorAlert:@"请先选择储值卡!" dismiss:YES];
    }
}

#pragma mark 修改储值卡密码页面
//修改密码
-(IBAction)clickPassword:(id)sender
{
//    if (self.sv_relation_id != nil) {
        [UIView transitionFromView:self.cardView
                            toView:self.passView
                          duration: 1.0f
                           options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                        completion:^(BOOL finished) {
                            if (finished) {
                                self.pageValue = 2;
                                [self.view bringSubviewToFront:self.quitButton];
                                
                            }
                        }
         ];
//    }else {
//        [Utility errorAlert:@"请先选择储值卡!" dismiss:YES];
//    }
}

//获取验证码
-(IBAction)codeBtnPressed:(id)sender
{
    if (self.appDel.isReachable==NO) {
        [Utility errorAlert:@"请检查网络" dismiss:YES];
    }else {
        [MBProgressHUD showHUDAddedTo:self.appDel.window animated:YES];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kAppointmentButton];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:self.sv_relation_id forKey:@"cid"];
        
        [LTInterfaceBase request:params requestUrl:urlString method:@"POST" completeBlock:^(NSDictionary *dictionary){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
                [Utility errorAlert:@"验证码已发送" dismiss:YES];
            });
        }errorBlock:^(NSString *notice){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
                [Utility errorAlert:notice dismiss:YES];
            });
        }];
    }
}

//取消修改密码
-(IBAction)cancleBtnPressed:(id)sender
{
    [UIView transitionFromView:self.passView
                        toView:self.cardView
                      duration: 1.0f
                       options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.pageValue = 1;
                            [self.view bringSubviewToFront:self.quitButton];
                        }
                    }
     ];
}

-(IBAction)passSureBtnPressed:(id)sender
{
    [self.pTxt1 resignFirstResponder];
    [self.pTxt2 resignFirstResponder];
    [self.cTxt resignFirstResponder];
    NSString *regexCall = @"\\d{6}";
    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
    if ([predicateCall evaluateWithObject:self.pTxt1.text]) {
        if ([self.pTxt1.text isEqualToString:self.pTxt2.text]) {
            if (self.cTxt.text.length>0) {
                if (self.appDel.isReachable==NO) {
                    [Utility errorAlert:@"请检查网络" dismiss:YES];
                }else {
                    [MBProgressHUD showHUDAddedTo:self.appDel.window animated:YES];
                    
                    NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kAppointmentButton];
                    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
                    [params setObject:self.sv_relation_id forKey:@"cid"];
                    [params setObject:self.cTxt.text forKey:@"verify_code"];
                    [params setObject:self.pTxt1.text forKey:@"n_password"];
                    
                    [LTInterfaceBase request:params requestUrl:urlString method:@"POST" completeBlock:^(NSDictionary *dictionary){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
                            
                            [Utility errorAlert:@"密码修改成功!" dismiss:YES];
                            
                            [UIView transitionFromView:self.passView
                                                toView:self.cardView
                                              duration: 1.0f
                                               options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                                            completion:^(BOOL finished) {
                                                if (finished) {
                                                    self.pageValue = 1;
                                                    [self.view bringSubviewToFront:self.quitButton];
                                                }
                                            }
                             ];
                        });
                    }errorBlock:^(NSString *notice){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
                            [Utility errorAlert:notice dismiss:YES];
                        });
                    }];
                }
            }else {
                [Utility errorAlert:@"请输入验证码!" dismiss:YES];
            }
        }else {
            [Utility errorAlert:@"请设置两次密码一致!" dismiss:YES];
        }
    }else {
        [Utility errorAlert:@"请设置6位数字密码!" dismiss:YES];
    }
    
}

@end
