//
//  LTSearchViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTSearchViewController.h"
#import "UIViewController+MJPopupViewController.h"



@interface LTSearchViewController ()

@end

@implementation LTSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - property
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}

-(XLCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView =[[XLCycleScrollView alloc] initWithFrame:(CGRect){0,100,688,924}];
        _scrollView.delegate = self;
        _scrollView.datasource = self;
        _scrollView.scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

-(LTMainViewController *)mainViewControl
{
    if (!_mainViewControl) {
        _mainViewControl = (LTMainViewController *)self.parentViewController;
    }
    return _mainViewControl;
}
-(UIView *)rollView
{
    if (!_rollView) {
        _rollView = [[UIView alloc] initWithFrame:CGRectMake(225, 90, 143, 13)];
        [_rollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"slider_line.png"]]];
    }
    return _rollView;
}
-(UILabel *)rollLabel
{
    if (!_rollLabel) {
        _rollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 13)];
        _rollLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slider.png"]];
        NSString *strPage = [NSString stringWithFormat:@"%d",  1];
        _rollLabel.text = strPage;
        _rollLabel.textColor = [UIColor whiteColor];
        [_rollLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W6" size:12.0f]];
        _rollLabel.textAlignment = NSTextAlignmentCenter;
        _rollLabel.center = CGPointMake(0, 6);
    }
    return _rollLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchView.layer.borderWidth = 1;
    
    
    //输入框添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchTextField];
    
    //筛选车牌
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shaixuanSure:) name:@"shaixuanFromSearchViewControl" object:nil];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self.view addSubview:self.scrollView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
//出现车牌选择框
-(void)selectCarNumber {
    NSArray *letterArray = [[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    for (int i=0; i<letterArray.count; i++) {
        NSString *str = letterArray[i];
        if ([str isEqualToString:self.searchTextField.text] || ([[str lowercaseString] isEqualToString:self.searchTextField.text])) {
            NSArray *array = [LTDataShare sharedService].sectionArray[i];
            if (array.count>0 && self.sxView == nil) {
                self.sxView = [[ShaixuanView alloc]initWithNibName:@"ShaixuanView" bundle:nil];
                self.sxView.view.frame = CGRectMake(self.searchView.frame.origin.x, 40+self.searchView.frame.origin.y, 0, 0);
                self.sxView.dataArray = array;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.35];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                self.sxView.view.frame = CGRectMake(self.searchView.frame.origin.x, 40+self.searchView.frame.origin.y, 287, 200);
                [self.view addSubview:self.sxView.view];
                [UIView commitAnimations];
                
            }
        }
    }
}

-(void)textFieldChanged:(NSNotification *)sender {
    UITextField *txtField = (UITextField *)sender.object;
    [LTDataShare sharedService].viewFrom = 1;
    if (txtField.text.length == 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self.sxView.view removeFromSuperview];
        self.sxView = nil;
        [UIView commitAnimations];
        
    }else if (txtField.text.length == 1) {
        [self selectCarNumber];
    }else if (txtField.text.length > 1) {
        [UIView animateWithDuration:0.35 animations:^{
            self.sxView.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.sxView.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.sxView.view removeFromSuperview];
                self.sxView = nil;
            }
        }];
    }
}

- (void)shaixuanSure:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    NSString *str = [dic objectForKey:@"name"];
    self.searchTextField.text = str;
    [UIView animateWithDuration:0.35 animations:^{
        self.sxView.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.sxView.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.sxView.view removeFromSuperview];
            self.sxView = nil;
        }
    }];
}



#pragma mark - 键盘的监听事件

- (void)keyBoardWillShow:(id)sender{
    if (self.searchTextField.text.length == 1) {
        [self selectCarNumber];
    }
}

- (void)keyBoardWillHide:(id)sender{
    [UIView animateWithDuration:0.35 animations:^{
        self.sxView.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.sxView.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.sxView.view removeFromSuperview];
            self.sxView = nil;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 搜索车牌或者手机号码

-(IBAction)searchButtonPressed:(id)sender
{
    if (self.searchTextField.text.length==0) {
        [Utility errorAlert:@"请输入车牌号码或者手机号码" dismiss:YES];
    }else {
        [self.searchTextField resignFirstResponder];
        if (self.searchTextField.text != self.searchText){
            if (self.appDel.isReachable==NO) {
                [Utility errorAlert:@"请检查网络" dismiss:NO];
            }else{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                NSString *is_car_num = @"";
                NSString *carNumRegex = @"[\u4E00-\u9FFF]+[A-Za-z]{1}+[A-Z0-9a-z]{5}";
                NSPredicate *carNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", carNumRegex];
                if (![carNumTest evaluateWithObject:self.searchTextField.text]) {
                    NSString *phoneRegex = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))|(((\\+86)|(86))?+\\d{11})$)";
                    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
                    if (![phoneTest evaluateWithObject:self.searchTextField.text]){
                        [Utility errorAlert:@"请输入正确的车牌号码或者手机号码!" dismiss:YES];
                    }else {
                        is_car_num = @"1";
                    }
                }else {
                    NSArray *array = [[NSArray alloc]initWithObjects:@"京",@"沪",@"津",@"渝",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新", nil];
                    
                    NSString *firstLetter = [self.searchTextField.text substringToIndex:1];
                    if (![array containsObject:firstLetter]) {
                        [Utility errorAlert:@"输入正确的车牌号码!" dismiss:YES];
                    }else {
                        is_car_num = @"0";
                    }
                }
                
                if (is_car_num.length != 0){
                    NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kSearch];
                    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
                    [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
                    [params setObject:self.searchTextField.text forKey:@"car_num"];
                    [params setObject:is_car_num forKey:@"is_car_num"];
                    
                    [LTInterfaceBase request:params requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            
                            ///保存搜索内容  避免重复搜索
                            self.searchText = self.searchTextField.text;
                            
                            [LTDataShare sharedService].searchModel = nil;
                            [LTDataShare sharedService].searchModel = [[SearchModel alloc]init];
                            //用户
                            CustomerListModel *customerObj = [[CustomerListModel alloc]init];
                            [customerObj mts_setValuesForKeysWithDictionary:dictionary];
                            
                            [LTDataShare sharedService].searchModel.customerList = customerObj.customerList;
                            
                            if ([LTDataShare sharedService].searchModel.customerList.count>0){
                                for (int i=0; i<[LTDataShare sharedService].searchModel.customerList.count; i++) {
                                    CustomerModel *customerModel = (CustomerModel *)[LTDataShare sharedService].searchModel.customerList[i];
                                    customerModel.orderType = OrderTypeWorking;
                                }
                            }
                            
                            if ([LTDataShare sharedService].searchModel.customerList.count<=1) {
                                self.scrollView.scrollView.scrollEnabled = NO;
                                [self.rollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                [self.rollView removeFromSuperview];
                            }else {
                                self.scrollView.scrollView.scrollEnabled = YES;
                                [self.rollView addSubview:self.rollLabel];
                                [self.view addSubview:self.rollView];
                                self.rollSize = 143.0 / ([LTDataShare sharedService].searchModel.customerList.count - 1);
                            }
                            
                            [self.scrollView reloadData];
                        });
                    }errorBlock:^(NSString *notice){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [Utility errorAlert:notice dismiss:YES];
                        });
                    }];
                }else {
                    [Utility errorAlert:@"请输入正确的车牌号码或者手机号码!" dismiss:YES];
                }
            }
        }
    }
}

#pragma mark - UIScrollView代理
- (NSInteger)numberOfPages
{
    if ([LTDataShare sharedService].searchModel.customerList.count>0){
        return [LTDataShare sharedService].searchModel.customerList.count;
    }else
        return 1;
}
- (UIView *)pageAtIndex:(NSInteger)index
{
    SearchCustomView *currentView = [[SearchCustomView alloc]initWithFrame:(CGRect){0,0,688,924}];
    currentView.delegate = self;
    currentView.pageIndex = index;
    
    return currentView;
}
-(void)scrollAtPage:(NSInteger)page
{
    if ([LTDataShare sharedService].searchModel.customerList.count>1){
        self.rollLabel.center = CGPointMake(self.rollSize * (page), 6);
        NSString *strPage = [NSString stringWithFormat:@"%d",page + 1];
        self.rollLabel.text = strPage;
    }
}

#pragma mark - SearchCustomView代理

- (void)dismisSearchCustomView:(SearchCustomView *)searchView
{
    self.serviceViewControl = (LTServiceBillingViewController *)self.mainViewControl.childViewControllers[2];
    
    self.mainViewControl.currentPage = 2;
    
    NSMutableArray *orderArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[LTDataShare sharedService].packageOrderArray.count; i++) {
        NSString *string = [LTDataShare sharedService].packageOrderArray[i];
        NSArray *array = [string componentsSeparatedByString:@"_"];
        
        PackageCardModel *package = (PackageCardModel *)[LTDataShare sharedService].searchModel.packageCardList[[array[0] integerValue]];
        PackageCardProductModel *packageProduct = (PackageCardProductModel *)package.productList[[array[1] integerValue]];
        
        OrderProductModel *product = [[OrderProductModel alloc]init];
        product.productId = packageProduct.productId;
        product.price = @"0";
        product.name = packageProduct.name;
        product.number = [array[4] integerValue];
        product.validNumber = 0;
        
        [orderArray addObject:product];
    }
    SearchCustomView *currentView = (SearchCustomView*)self.scrollView.scrollView.subviews[1];
    [self.serviceViewControl setCustomerModel:currentView.customerModel];
    self.serviceViewControl.isSearching = NO;
    self.serviceViewControl.orderArray = orderArray;
    [self.serviceViewControl setPackageCardList:[LTDataShare sharedService].searchModel.packageCardList];
}

- (void)presentCompliantViewControlWithDictionary:(NSDictionary *)aDic
{
    ComplaintViewController *complaintViewControl = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
    
    complaintViewControl.delegate = self;
    [complaintViewControl setInfoDic:aDic];
    
    [complaintViewControl willMoveToParentViewController:self.mainViewControl];
    [self.mainViewControl addChildViewController:complaintViewControl];
    [complaintViewControl didMoveToParentViewController:self.mainViewControl];
    
    [self presentPopupViewController:complaintViewControl animationType:MJPopupViewAnimationSlideBottomBottom width:80 ];
    
    complaintViewControl = nil;
}

//取消订单
-(void)cancelOrderWithOrderId:(NSString *)orderId
{
    if (self.appDel.isReachable==NO) {
        BOOL success = NO;//记录添加本地是否成功
        LTDB *db = [[LTDB alloc]init];
        OrderModel *orderModel = [db getLocalOrderInfoWhereOid:orderId];
        if (orderModel != nil){
            orderModel.order_status = [NSString stringWithFormat:@"%d",0];
            
            success = [db updateOrderInfoWithOrder:orderModel WhereOid:orderId];
        }else {
             orderModel = [[OrderModel alloc]init];
            orderModel.store_id = [LTDataShare sharedService].user.store_id;
            orderModel.order_id =[NSString stringWithFormat:@"%@",orderId];
            orderModel.order_status = [NSString stringWithFormat:@"%d",0];
            
            success = [db saveOrderDataToLocal:orderModel];
        }
        
        if (success) {
            [Utility errorAlert:@"订单已取消" dismiss:NO];
        }else {
            [Utility errorAlert:@"订单取消失败" dismiss:NO];
        }
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kServiceBillingMakeOrder];
        
        NSMutableDictionary *paramas = [[NSMutableDictionary alloc] init];

        [paramas setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
        [paramas setObject:orderId forKey:@"order_id"];
        
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
#pragma mark - 投诉页面代理
-(void)dismissComplaintViewControl:(ComplaintViewController *)complaintViewController
{
    __block ComplaintViewController *viewControl = complaintViewController;
    [self.mainViewControl dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop dismissBlock:^(BOOL isFinish){
        
        [viewControl removeFromParentViewController];
        viewControl = nil;
    }];
}
@end
