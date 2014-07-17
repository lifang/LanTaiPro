//
//  LTServiceBillingViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTServiceBillingViewController.h"
#import "UIViewController+MJPopupViewController.h"

#define FOOTER @"orderTableViewFooter"
//下拉刷新
#import "SVPullToRefresh.h"

@implementation LTServiceBillingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - property
-(NSMutableArray *)searchArray
{
    if(!_searchArray){
        _searchArray = [[NSMutableArray alloc]init];
    }
    return _searchArray;
}
-(SearchModel *)searchModel
{
    if (!_searchModel) {
        _searchModel = [[SearchModel alloc]init];
    }
    return _searchModel;
}
-(BillingModel *)billingModel
{
    if (!_billingModel){
        _billingModel = [[BillingModel alloc]init];
    }
    return _billingModel;
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}

-(XLCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView =[[XLCycleScrollView alloc] initWithFrame:(CGRect){0,60,526,210}];
        _scrollView.delegate = self;
        _scrollView.datasource = self;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}
-(NSMutableArray *)arrSelSection {
    if (!_arrSelSection) {
        _arrSelSection = [[NSMutableArray alloc]init];
    }
    return _arrSelSection;
}

-(KeyViewController *)keyViewController
{
    if (!_keyViewController) {
        _keyViewController = [[KeyViewController alloc]initWithNibName:@"KeyViewController" bundle:nil];
        _keyViewController.delegate = self;
    }
    return _keyViewController;
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
        _rollView = [[UIView alloc] initWithFrame:CGRectMake(150, 43, 143, 13)];
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


-(void)setOrderArray:(NSMutableArray *)orderArray
{
    _orderArray = orderArray;
    if (_orderArray.count>0) {
        self.orderTable.hidden = NO;
        self.cancelOrderButton.hidden = NO;
        self.confirmOrderButton.hidden = NO;
        
        CGFloat totalPrice = 0;
        for (int i=0; i<_orderArray.count; i++) {
            OrderProductModel *object = (OrderProductModel *)_orderArray[i];
            
            //TODO:套餐卡
            if (self.packageCardList.count>0) {
                BOOL isExit = NO;
                for (int k=0; k<self.packageCardList.count; k++) {
                    PackageCardModel *package = (PackageCardModel *)self.packageCardList[k];
                    
                    for (int j=0; j<package.productList.count; j++) {
                        PackageCardProductModel *packagePro = (PackageCardProductModel *)package.productList[j];
                        
                        if ([packagePro.productId intValue]==[object.productId intValue] && [packagePro.types intValue]==[object.types intValue] && [packagePro.unused_num intValue]>0 && [packagePro.selected_num intValue]<[packagePro.unused_num intValue]) {
                            isExit = YES;
                            
                            if (object.validNumber > [packagePro.unused_num intValue]) {
                                object.validNumber -= [packagePro.unused_num intValue];
                                packagePro.selected_num = packagePro.unused_num;
                                totalPrice += [object.price floatValue]*object.validNumber;
                            }else {
                                packagePro.selected_num = [NSString stringWithFormat:@"%d",object.validNumber];
                                object.validNumber = 0;
                            }
                            

                            NSString *string = [NSString stringWithFormat:@"%d_%d_%@_%@_%@",k,j,package.cus_card_id,packagePro.productId,packagePro.selected_num];
                            if (![LTDataShare sharedService].packageOrderArray){
                                [LTDataShare sharedService].packageOrderArray = [[NSMutableArray alloc]init];
                                [[LTDataShare sharedService].packageOrderArray addObject:string];
                            }else {
                                BOOL isExit = NO;
                                if ([LTDataShare sharedService].packageOrderArray.count>0){
                                    for (int i=0; i<[LTDataShare sharedService].packageOrderArray.count; i++) {
                                        NSString *str = [LTDataShare sharedService].packageOrderArray[i];
                                        NSArray *array = [str componentsSeparatedByString:@"_"];
                                        if ([array[2] intValue]==[package.cus_card_id intValue] && [array[3] intValue]==[packagePro.productId intValue]) {
                                            [[LTDataShare sharedService].packageOrderArray replaceObjectAtIndex:i withObject:string];
                                            isExit = YES;
                                            break;
                                        }
                                    }
                                }
                                
                                if (isExit == NO) {
                                    [[LTDataShare sharedService].packageOrderArray addObject:string];
                                }
                            }
                            
                            [package.productList replaceObjectAtIndex:j withObject:packagePro];
                            
                            [self.packageCardList replaceObjectAtIndex:k withObject:package];

                            [self.packageTable reloadData];
                            
                            [_orderArray replaceObjectAtIndex:i withObject:object];
                            break;
                        }
                    }
                }
                if (isExit==NO) {
                    totalPrice += [object.price floatValue]*object.validNumber;
                }
            }else {
                totalPrice += [object.price floatValue]*object.validNumber;
            }
        }
        self.footer.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",totalPrice];
    }else {
        self.orderTable.hidden = YES;
        self.cancelOrderButton.hidden = YES;
        self.confirmOrderButton.hidden = YES;
    }
    [self.orderTable reloadData];
}
//从其他页面跳住到开单界面
-(void)setCustomerModel:(CustomerModel *)customerModel
{
    [self.searchModel.customerList removeAllObjects];
    
    if (customerModel != nil) {
        _customerModel = customerModel;
        
        [self.searchModel.customerList addObject:_customerModel];
    }
    
    [self.scrollView reloadData];
    self.scrollView.scrollView.scrollEnabled = NO;
    [self.rollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.rollView removeFromSuperview];
}

-(void)setPackageCardList:(NSMutableArray *)packageCardList
{
    if (packageCardList != nil) {
        _packageCardList = packageCardList;
        if (_packageCardList.count>0) {
            self.packageTable.hidden=NO;
            self.packageBtn.hidden = NO;
        }else {
            self.packageTable.hidden=YES;
            self.packageBtn.hidden = YES;
        }
    }else {
        self.packageTable.hidden=YES;
        self.packageBtn.hidden = YES;
    }
    
    [self.packageTable reloadData];
}
#pragma mark - 获取右侧快速下单
- (void)getRightProductList
{
    if (self.appDel.isReachable==NO) {
        [Utility errorAlert:@"请检查网络" dismiss:NO];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kServiceBillingProduct];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
        
        [LTInterfaceBase request:params requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.billingModel mts_setValuesForKeysWithDictionary:dictionary];
                
                [self.fastTable reloadData];
            });
        } errorBlock:^(NSString *notice) {
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
    self.searchView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchView.layer.borderWidth = 1;
    
    self.packageBtn.hidden = YES;
    self.packageTable.hidden = YES;
    
    self.leftView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftViewBack"]];
    self.isSearch = NO;
    
    
    [self getRightProductList];
    [self.leftView addSubview:self.scrollView];
    
    self.footer = [[Footer alloc]initWithReuseIdentifier:FOOTER];
    [self.orderTable setTableFooterView:self.footer];
    [self.leftView bringSubviewToFront:self.orderTable];
    
    [self.leftView bringSubviewToFront:self.packageTable];
    [self.leftView bringSubviewToFront:self.packageBtn];
    
    self.orderTable.hidden = YES;
    self.cancelOrderButton.hidden = YES;
    self.confirmOrderButton.hidden = YES;
    
    //右边栏  下拉刷新
    __block LTServiceBillingViewController *viewControl = self;
    __block UITableView *table = self.fastTable;
    [_fastTable addPullToRefreshWithActionHandler:^{
        [viewControl getRightProductList];
        [table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
    
    __block UITableView *table2 = self.packageTable;
    [_packageTable addPullToRefreshWithActionHandler:^{
        [viewControl getPackageCardInfo];
        [table2.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
    
    [Utility setLogoImageWithTable:self.orderTable];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //输入框添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchTextField];
    
    //输入框添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(productTextFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.productSearchTextField];
    
    //筛选车牌
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shaixuanSure:) name:@"shaixuanFromServiceViewControl" object:nil];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    //套餐卡选择产品
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(packageCardSelected:) name:@"packageCardSelected" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.productSearchTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shaixuanFromServiceViewControl" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"packageCardSelected" object:nil];
}

//套餐卡刷新
-(void)getPackageCardInfo
{
    if (self.appDel.isReachable==NO) {
        [Utility errorAlert:@"请检查网络" dismiss:NO];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kSearchClassify];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
        [params setObject:[NSString stringWithFormat:@"%d",2] forKey:@"type"];

        ServiceBillingCustomView *currentView = (ServiceBillingCustomView *)self.scrollView.scrollView.subviews[1];
        [params setObject:currentView.customerModel.customer_carNumId forKey:@"car_num_id"];
        [params setObject:currentView.customerModel.customer_id forKey:@"customer_id"];
        
        [LTInterfaceBase request:params requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.orderArray = nil;
                self.orderTable.hidden = YES;
                
                PackageOrderModel *packageObj = [[PackageOrderModel alloc]init];
                [packageObj mts_setValuesForKeysWithDictionary:dictionary];
                
                self.packageCardList = packageObj.packageCardList;
                if (self.packageCardList.count>0) {
                    self.packageBtn.hidden=NO;
                    self.packageTable.hidden = NO;
                    [self.packageTable reloadData];
                }else {
                    self.packageBtn.hidden=YES;
                    self.packageTable.hidden = YES;
                }
            });
        } errorBlock:^(NSString *notice) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Utility errorAlert:notice dismiss:YES];
            });
        }];
    }
}

//套餐卡选择产品
-(void)packageCardSelected:(NSNotification *)notification
{
    PackageCardProductModel *packageProduct = (PackageCardProductModel *)[notification object];
    
    NSDictionary *aDic = [notification userInfo];
    NSString *remark = [aDic objectForKey:@"remark"];
    
    OrderProductModel *product = [[OrderProductModel alloc]init];
    product.productId = packageProduct.productId;
    product.price = @"0";
    product.name = packageProduct.name;
    product.number = [packageProduct.selected_num intValue];
    product.validNumber = 0;
    product.types = packageProduct.types;
    
    if (!self.orderArray) {
        self.orderArray = [[NSMutableArray alloc]init];
        [self.orderArray addObject:product];
        
        NSString *text = [self.footer.totalPriceLabel.text substringFromIndex:3];
        float totalPrice = [text floatValue];
        self.footer.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",totalPrice+[product.price floatValue]];
    }else {
        BOOL isExit = NO;
        for (int i=0; i<self.orderArray.count; i++){
            OrderProductModel *object = (OrderProductModel *)self.orderArray[i];
            if ([object.productId intValue]==[packageProduct.productId intValue] && [object.types intValue]==[packageProduct.types intValue]){
                isExit = YES;
                if ([remark isEqualToString:@"add"]){
                    object.number += 1;
                    [self.orderArray replaceObjectAtIndex:i withObject:object];
                }else if ([remark isEqualToString:@"reduce"]){
                    if ((object.number-1)==0) {
                        [self.orderArray removeObject:object];
                        //TODO:右侧边栏
                        if (self.billingModel.productList.count>0){
                            for (int h=0; h<self.billingModel.productList.count; h++) {
                                ProductSectionModel *sectionModel = (ProductSectionModel *)self.billingModel.productList[h];
                                for (int m=0; m<sectionModel.products.count; m++) {
                                    ProductCellModel *cellModel = (ProductCellModel *)sectionModel.products[m];
                                    
                                    if ([object.productId intValue]==[cellModel.productId intValue] && [object.types intValue]==[cellModel.types intValue] && [cellModel.selected intValue]==1) {
                                        cellModel.selected = @"0";
                                        
                                        [sectionModel.products replaceObjectAtIndex:m withObject:cellModel];
                                        
                                        [self.billingModel.productList replaceObjectAtIndex:h withObject:sectionModel];
                                        
                                        [self.fastTable reloadData];
                                        
                                        break;
                                    }
                                }
                            }
                        }
   
                    }else {
                        object.number -= 1;
                        [self.orderArray replaceObjectAtIndex:i withObject:object];
                    }
                }
                
                break;
            }
        }
        
        if (isExit==NO) {
            [self.orderArray addObject:product];
            NSString *text = [self.footer.totalPriceLabel.text substringFromIndex:3];
            float totalPrice = [text floatValue];
            self.footer.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",totalPrice+[product.price floatValue]];
        }
    }

    if (self.orderArray.count>0) {
        self.orderTable.hidden = NO;
        self.cancelOrderButton.hidden = NO;
        self.confirmOrderButton.hidden = NO;
    }else {
        self.orderTable.hidden = YES;
        self.cancelOrderButton.hidden = YES;
        self.confirmOrderButton.hidden = YES;
    }
    [self.orderTable reloadData];
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
                [self.leftView addSubview:self.sxView.view];
                [UIView commitAnimations];
                
            }
        }
    }
}

-(void)textFieldChanged:(NSNotification *)sender {
    UITextField *txtField = (UITextField *)sender.object;
    [LTDataShare sharedService].viewFrom = 0;
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


-(void)productTextFieldChanged:(NSNotification *)sender
{
    UITextField *txtField = (UITextField *)sender.object;
    
    if (txtField.text.length == 0){
        self.isSearch = NO;
        [self.fastTable reloadData];
    }else {
        self.isSearch = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.productSearchTextField]) {
        [textField resignFirstResponder];
        
        if (self.billingModel.productList.count==0) {
            [Utility errorAlert:@"暂无产品可快速选择" dismiss:YES];
        }else {
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            for (ProductSectionModel *sectionModel in self.billingModel.productList){
                [tempArray addObjectsFromArray:sectionModel.products];
            }
            
            NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"name", textField.text];
            self.searchArray  = [NSMutableArray arrayWithArray:[tempArray filteredArrayUsingPredicate:predicateString]];
            [self.fastTable reloadData];
        }
    }
    return YES;
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


#pragma mark - 搜索
-(IBAction)searchButtonPressed:(id)sender
{
    if (self.searchTextField.text.length==0) {
        [Utility errorAlert:@"请输入车牌号码或者手机号码" dismiss:YES];
    }else {
        [self.searchTextField resignFirstResponder];
        if (self.appDel.isReachable==NO) {
            [Utility errorAlert:@"请检查网络" dismiss:NO];
        }else{
            NSString *is_car_num = @"";
            NSString *carNumRegex = @"[\u4E00-\u9FFF]+[A-Za-z]{1}+[A-Z0-9a-z]{5}";
            NSPredicate *carNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", carNumRegex];
            if (![carNumTest evaluateWithObject:self.searchTextField.text]) {
                NSString *phoneRegex = @"1[0-9]{10}";
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
                
                self.isSearching = YES;
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kSearch];
                NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
                [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
                [params setObject:self.searchTextField.text forKey:@"car_num"];
                [params setObject:is_car_num forKey:@"is_car_num"];
                [params setObject:@"1" forKey:@"type"];//有套餐卡列表
                
                [LTInterfaceBase request:params requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        NSString *text = [self.footer.totalPriceLabel.text substringFromIndex:3];
                        float totalPrice = [text floatValue];
                        //重置套餐卡
                        if ([LTDataShare sharedService].packageOrderArray.count>0) {
                            for (int m=0; m<[LTDataShare sharedService].packageOrderArray.count; m++) {
                                NSString *str = [LTDataShare sharedService].packageOrderArray[m];
                                NSArray *array = [str componentsSeparatedByString:@"_"];
                                
                                NSString *productId = array[3];
                                for (int i=0; i<self.orderArray.count; i++){
                                    OrderProductModel *object = (OrderProductModel *)self.orderArray[i];
                                    
                                    if ([productId intValue]==[object.productId intValue]) {
                                        object.validNumber += [array[4] intValue];
                                        
                                        [self.orderArray replaceObjectAtIndex:i withObject:object];
                                        totalPrice += [array[4] intValue]*[object.price floatValue];
                                        break;
                                    }
                                }
                            }
                        }
                        
                        [LTDataShare sharedService].packageOrderArray = nil;
                        
                        //用户
                        NSDictionary *customerDic = [dictionary objectForKey:@"cus"];
                        CustomerListModel *customerObj = [[CustomerListModel alloc]init];
                        [customerObj mts_setValuesForKeysWithDictionary:customerDic];
                        self.searchModel.customerList = customerObj.customerList;
                        //套餐卡
                        NSDictionary *packageDic = [dictionary objectForKey:@"cus_card"];
                        PackageOrderModel *packageObj = [[PackageOrderModel alloc]init];
                        [packageObj mts_setValuesForKeysWithDictionary:packageDic];
                        
                        self.packageCardList = packageObj.packageCardList;
                        if (self.packageCardList.count>0) {
                            self.packageBtn.hidden=NO;
                            self.packageTable.hidden = NO;
                            
                            //优先使用套餐卡
                            if (self.orderArray.count>0){
                                for (int i=0; i<self.orderArray.count; i++){
                                    OrderProductModel *object = (OrderProductModel *)self.orderArray[i];
                                    for (int k=0; k<self.packageCardList.count; k++){
                                        PackageCardModel *package = (PackageCardModel *)self.packageCardList[k];
                                        
                                        for (int j=0; j<package.productList.count; j++){
                                            PackageCardProductModel *packagePro = (PackageCardProductModel *)package.productList[j];
                                            
                                            if ([packagePro.productId intValue]==[object.productId intValue] && [packagePro.types intValue]==[object.types intValue] && [packagePro.unused_num intValue]>0 && [packagePro.selected_num intValue]<[packagePro.unused_num intValue]){
                                                if (object.validNumber > [packagePro.unused_num intValue]) {
                                                    object.validNumber -= [packagePro.unused_num intValue];
                                                    packagePro.selected_num = packagePro.unused_num;
                                                }else {
                                                    packagePro.selected_num = [NSString stringWithFormat:@"%d",object.validNumber];
                                                    object.validNumber = 0;
                                                }
                                                
                                                totalPrice -= [object.price floatValue]*[packagePro.selected_num intValue];
                                                
                                                NSString *string = [NSString stringWithFormat:@"%d_%d_%@_%@_%@",k,j,package.cus_card_id,packagePro.productId,packagePro.selected_num];
                                                if (![LTDataShare sharedService].packageOrderArray){
                                                    [LTDataShare sharedService].packageOrderArray = [[NSMutableArray alloc]init];
                                                    [[LTDataShare sharedService].packageOrderArray addObject:string];
                                                }else {
                                                    BOOL isExiting = NO;
                                                    if ([LTDataShare sharedService].packageOrderArray.count>0){
                                                        for (int i=0; i<[LTDataShare sharedService].packageOrderArray.count; i++) {
                                                            NSString *str = [LTDataShare sharedService].packageOrderArray[i];
                                                            NSArray *array = [str componentsSeparatedByString:@"_"];
                                                            if ([array[2] intValue]==[package.cus_card_id intValue] && [array[3] intValue]==[packagePro.productId intValue]) {
                                                                [[LTDataShare sharedService].packageOrderArray replaceObjectAtIndex:i withObject:string];
                                                                isExiting = YES;
                                                                break;
                                                            }
                                                        }
                                                    }
                                                    
                                                    if (isExiting == NO) {
                                                        [[LTDataShare sharedService].packageOrderArray addObject:string];
                                                    }
                                                }
                                                [package.productList replaceObjectAtIndex:j withObject:packagePro];
                                                
                                                [self.packageCardList replaceObjectAtIndex:k withObject:package];
                                                
                                                [self.orderArray replaceObjectAtIndex:i withObject:object];
                                                break;
                                            }
                                        }
                                    }
                                    self.footer.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",totalPrice];
                                }
                                
                                [self.packageTable reloadData];
                                [self.orderTable reloadData];
                            }
                            
                        }else {
                            self.packageBtn.hidden=YES;
                            self.packageTable.hidden = YES;
                        }
                        
                        if (self.searchModel.customerList.count<=1) {
                            self.scrollView.scrollView.scrollEnabled = NO;
                            [self.rollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                            [self.rollView removeFromSuperview];
                        }else {
                            self.scrollView.scrollView.scrollEnabled = YES;
                            [self.rollView addSubview:self.rollLabel];
                            [self.leftView addSubview:self.rollView];
                            self.rollSize = 143.0 / (self.searchModel.customerList.count - 1);
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

#pragma mark - UIScrollView代理
- (NSInteger)numberOfPages
{
    if (self.searchModel.customerList.count>0)
        return self.searchModel.customerList.count;
    else
        return 1;
}
- (UIView *)pageAtIndex:(NSInteger)index
{
    ServiceBillingCustomView *currentView = [[ServiceBillingCustomView alloc]initWithFrame:(CGRect){0,0,526,210}];
    
    if (self.isSearching==NO) {
        [currentView setCustomerModel:self.customerModel];
    }else {
        if (self.searchModel.customerList.count>0){
            CustomerModel *customerModel = (CustomerModel *)self.searchModel.customerList[index];
            [currentView setCustomerModel:customerModel];
        }else {
            [currentView setCustomerModel:nil];
        }
    }

    return currentView;
}
-(void)scrollAtPage:(NSInteger)page
{
    if (self.searchModel.customerList.count>1){
        self.rollLabel.center = CGPointMake(self.rollSize * (page), 6);
        NSString *strPage = [NSString stringWithFormat:@"%d",page + 1];
        self.rollLabel.text = strPage;
    }
}

#pragma mark - table代理
- (UILabel *)returnlabel
{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    if ([tableView isEqual:self.orderTable]) {
        return 40;
    }else if ([tableView isEqual:self.packageTable]){
        return 0;
    }else {
        if (self.isSearch){
            return 0;
        }else
            return 47;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.orderTable]) {
        
        UIView *customView = [[UIView alloc]initWithFrame:(CGRect){0,0,CGRectGetWidth(tableView.bounds),40}];
        
        UILabel *lab1 = [self returnlabel];
        lab1.text = @"名称";
        lab1.frame = (CGRect){0,5,209,30};
        [customView addSubview:lab1];
        
        UILabel *lab2 = [self returnlabel];
        lab2.text = @"单价";
        lab2.frame = (CGRect){210,5,106,30};
        [customView addSubview:lab2];
        
        UILabel *lab3 = [self returnlabel];
        lab3.text = @"数量";
        lab3.frame = (CGRect){315,5,106,30};
        [customView addSubview:lab3];
        
        UILabel *lab4 = [self returnlabel];
        lab4.text = @"小计";
        lab4.frame = (CGRect){420,5,106,30};
        [customView addSubview:lab4];
        
        lab1 = nil;lab2=nil;lab3=nil;lab4=nil;
        [Utility setRoundcornerWithView:customView];
        return customView;
    }else if ([tableView isEqual:self.packageTable]){
        return nil;
    }
    else {
        if (self.isSearch) {
            return nil;
        }
        ProductSectionModel *sectionModel = (ProductSectionModel *)self.billingModel.productList[section];
        
        UIView *headerView = [[UIView alloc]initWithFrame:(CGRect){0,0,CGRectGetWidth(tableView.bounds),47}];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:headerView.frame];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1];
        nameLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
        nameLabel.text = sectionModel.name;
        [headerView addSubview:nameLabel];
        nameLabel = nil;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = section;
        [btn addTarget:self action:@selector(coverButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = headerView.frame;
        [headerView addSubview:btn];
        btn = nil;
        
        BOOL isSelSection = NO;
        for (int i = 0; i < self.arrSelSection.count; i++){
            NSString *strSection = [NSString stringWithFormat:@"%@",self.arrSelSection[i]];
            NSInteger selSection = strSection.integerValue;
            if (section == selSection) {
                isSelSection = YES;
                headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_background"]];
                break;
            }
        }
        if (!isSelSection) {
            headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellback"]];
        }
        return headerView;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.orderTable]) {
        return 1;
    }else if ([tableView isEqual:self.packageTable]){
        return 1;
    }
    else {
        if (self.isSearch) {
            return 1;
        }else
            return self.billingModel.productList.count;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.orderTable]) {
        return self.orderArray.count;
    }else if ([tableView isEqual:self.packageTable]){
        return self.packageCardList.count;
    }
    else {
    if (self.isSearch) {
        return self.searchArray.count;
    }else {
        for (int i = 0; i < self.arrSelSection.count; i++) {
            NSString *strSection = [NSString stringWithFormat:@"%@",self.arrSelSection[i]];
            NSInteger selSection = strSection.integerValue;
            if (section == selSection) {
                ProductSectionModel *sectionModel = (ProductSectionModel *)self.billingModel.productList[section];
                return sectionModel.products.count;
            }
        }
        return 0;
    }
    }
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView isEqual:self.orderTable]){
        return 30;
    }else if ([_tableView isEqual:self.packageTable]){
        PackageCardModel *package = (PackageCardModel *)self.packageCardList[indexPath.row];
        return 100+package.productList.count*30;
    }
    else {
        return 47;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.orderTable]){
        static NSString * identifier = @"serviceBillingOrderCell";
        OrderProductModel *cellModel = (OrderProductModel *)self.orderArray[indexPath.row];
        
        ServiceBillingOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ServiceBillingOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier product:cellModel];
        }
        return cell;
    }else if ([tableView isEqual:self.packageTable]){
        static NSString * identifier = @"packageCardOrderCell";
        
        PackageCardModel *package = (PackageCardModel *)self.packageCardList[indexPath.row];
        
        ServiceBillingPackageCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ServiceBillingPackageCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier packageCardModel:package];
        }
        cell.delegate = self;
        cell.idxPath = indexPath;
        return cell;
    }
    else {
        static NSString * identifier = @"ServiceBillingCell";
        ServiceBillingCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[ServiceBillingCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        if (self.isSearch) {
            ProductCellModel *cellModel = (ProductCellModel *)self.searchArray[indexPath.row];
            cell.titleLanel.text = cellModel.name;
            cell.priceLabel.text = [NSString stringWithFormat:@"%@元",cellModel.price];
            
            if ([cellModel.selected intValue]==1) {
                cell.backgroundColor = [UIColor redColor];
            }
        }else {
            for (int i = 0; i < self.arrSelSection.count; i++) {
                NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
                NSInteger selSection = strSection.integerValue;
                if (indexPath.section == selSection) {
                    ProductSectionModel *sectionModel = (ProductSectionModel *)self.billingModel.productList[indexPath.section];
                    ProductCellModel *cellModel = (ProductCellModel *)sectionModel.products[indexPath.row];
                    cell.titleLanel.text = cellModel.name;
                    cell.priceLabel.text = [NSString stringWithFormat:@"%@元",cellModel.price];;
                
                    if ([cellModel.selected intValue]==1) {
                        cell.backgroundColor = [UIColor redColor];
                    }
                    
                    break;
                }
            }
        }
        
        return cell;
    }
}

-(void)coverButtonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    BOOL isSelSection = NO;
    self.tmpSection = btn.tag;
    for (int i = 0; i < self.arrSelSection.count; i++) {
        NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
        NSInteger selSection = strSection.integerValue;
        if (self.tmpSection == selSection) {
            isSelSection = YES;
            [self.arrSelSection removeObjectAtIndex:i];
            break;
        }
    }
    if (!isSelSection) {
        [self.arrSelSection addObject:[NSString stringWithFormat:@"%i",self.tmpSection]];
    }
    UITableView *tableView = (UITableView *)[[btn superview] superview];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:3];
    [tableView reloadData];
    [UIView commitAnimations];
}

- (int)validSelectedValue:(NSInteger)value {
    
    if(value == 1){
        value = 0;
    }else
        value = 1;
    
    return value;
}
-(BOOL)checkPackageCardListWith:(OrderProductModel *)object selected:(int)selected
{
    BOOL isExiting = NO;
    if (self.packageCardList.count>0) {
        
        for (int k=0; k<self.packageCardList.count; k++) {
            PackageCardModel *package = (PackageCardModel *)self.packageCardList[k];
            
            for (int j=0; j<package.productList.count; j++) {
                PackageCardProductModel *packagePro = (PackageCardProductModel *)package.productList[j];
                if ([packagePro.productId intValue]==[object.productId intValue] && [packagePro.types intValue]==[object.types intValue]){
                    BOOL isCkecking = YES;
                    
                    //套餐卡有选择产品的个数 && 套餐卡选择产品的个数大于等于产品的个数
                    if (selected==0 && [packagePro.selected_num intValue]>1 && [packagePro.selected_num intValue]>=object.number) {
                        isExiting = YES;
                        packagePro.selected_num = [NSString stringWithFormat:@"%d",[packagePro.selected_num intValue]-1];
                    }else if(selected==1 && [packagePro.unused_num intValue]-[packagePro.selected_num intValue]>0){
                        isExiting = YES;
                        packagePro.selected_num = [NSString stringWithFormat:@"%d",[packagePro.selected_num intValue]+1];
                    }else {
                        isCkecking = NO;
                    }

                    if (isCkecking == YES) {
                        if ([LTDataShare sharedService].packageOrderArray.count>0) {
                            BOOL isExit = NO;
                            for (int i=0; i<[LTDataShare sharedService].packageOrderArray.count; i++) {
                                NSString *string = [LTDataShare sharedService].packageOrderArray[i];
                                NSArray *array = [string componentsSeparatedByString:@"_"];
                                if ([array[2] intValue]==[package.cus_card_id intValue] && [array[3] intValue]==[packagePro.productId intValue]) {
                                    isExit = YES;
                                    if ([packagePro.selected_num intValue]==0) {
                                        [[LTDataShare sharedService].packageOrderArray removeObject:string];
                                    }else {
                                        NSString *string2 = [NSString stringWithFormat:@"%d_%d_%@_%@_%@",k,j,package.cus_card_id,packagePro.productId,packagePro.selected_num];
                                        [[LTDataShare sharedService].packageOrderArray replaceObjectAtIndex:i withObject:string2];
                                    }
                                    
                                    break;
                                }
                            }
                            
                            if (isExit==NO) {
                                NSString *string2 = [NSString stringWithFormat:@"%d_%d_%@_%@_%@",k,j,package.cus_card_id,packagePro.productId,packagePro.selected_num];
                                [[LTDataShare sharedService].packageOrderArray addObject:string2];
                            }
                        }else {
                            [LTDataShare sharedService].packageOrderArray = [[NSMutableArray alloc]init];
                            NSString *string2 = [NSString stringWithFormat:@"%d_%d_%@_%@_%@",k,j,package.cus_card_id,packagePro.productId,packagePro.selected_num];
                            [[LTDataShare sharedService].packageOrderArray addObject:string2];
                        }
                        
                        DLog(@"###== %@",[LTDataShare sharedService].packageOrderArray);
                        
                        [package.productList replaceObjectAtIndex:j withObject:packagePro];
                        
                        [self.packageCardList replaceObjectAtIndex:k withObject:package];
                        
                        [self.packageTable reloadData];
                    }
                    break;
                }
            }
            if (isExiting){
                break;
            }
        }
    }
    
    return isExiting;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.orderTable]) {
        
    }else if ([tableView isEqual:self.packageTable]){
        
    }else if ([tableView isEqual:self.fastTable]){
        ProductCellModel *cellModel = nil;
        if (self.isSearch){
            cellModel = (ProductCellModel *)self.searchArray[indexPath.row];
        }else {
            ProductSectionModel *sectionModel = (ProductSectionModel *)self.billingModel.productList[indexPath.section];
            cellModel = (ProductCellModel *)sectionModel.products[indexPath.row];
        }
        
        int selected = [self validSelectedValue:[cellModel.selected intValue]];
        cellModel.selected = [NSString stringWithFormat:@"%d",[self validSelectedValue:[cellModel.selected intValue]]];
        [self.fastTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //TODO:选择的产品加入订单列表
        OrderProductModel *product = [[OrderProductModel alloc]init];
        product.productId = cellModel.productId;
        product.price = cellModel.price;
        product.name = cellModel.name;
        product.number = 1;
        product.validNumber = 1;
        product.types = cellModel.types;
        
        if (self.orderArray.count==0) {
            self.orderArray = [[NSMutableArray alloc]init];
            
            BOOL isChecking = [self checkPackageCardListWith:product selected:selected];
            if (isChecking) {
                product.price =@"0";
                self.footer.totalPriceLabel.text = @"总计:0.00";
            }else {
                NSString *text = [self.footer.totalPriceLabel.text substringFromIndex:3];
                float totalPrice = [text floatValue];
                self.footer.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",totalPrice+[product.price floatValue]];
            }
            [self.orderArray addObject:product];
        }else {
            BOOL isExit = NO;
            for (int i=0; i<self.orderArray.count; i++) {
                OrderProductModel *object = (OrderProductModel *)self.orderArray[i];
                
                if ([object.productId intValue]==[product.productId intValue] && [object.types intValue]==[product.types intValue]) {
                    isExit = YES;
                    if (selected==1) {
                        object.number += 1;
                        object.validNumber += 1;
                        object.price = product.price;
                        
                        BOOL isChecking = [self checkPackageCardListWith:object selected:selected];
                        
                        if (isChecking) {
                            
                        }else {
                            [self.orderArray replaceObjectAtIndex:i withObject:object];
                            NSString *text = [self.footer.totalPriceLabel.text substringFromIndex:3];
                            float totalPrice = [text floatValue];
                            self.footer.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",totalPrice+[product.price floatValue]];
                        }
                        
                    }else if (selected==0){
                        BOOL isChecking = [self checkPackageCardListWith:object selected:selected];
                        
                        if ((object.number-1)==0) {
                            [self.orderArray removeObject:object];
                        }else {
                            object.number -= 1;
                            if (object.validNumber>0) {
                                object.validNumber -= 1;
                            }
                            
                            [self.orderArray replaceObjectAtIndex:i withObject:object];
                        }
                        
                        if (isChecking) {
                            
                        }else {
                            NSString *text = [self.footer.totalPriceLabel.text substringFromIndex:3];
                            float totalPrice = [text floatValue];
                            self.footer.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",totalPrice-[product.price floatValue]];
                            
                        }
                        
                    }
                    break;
                }
            }
            
            if (isExit==NO) {
                
                BOOL isChecking = [self checkPackageCardListWith:product selected:selected];
                if (isChecking) {
                    product.price = @"0";
                }else {
                    NSString *text = [self.footer.totalPriceLabel.text substringFromIndex:3];
                    float totalPrice = [text floatValue];
                    self.footer.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",totalPrice+[product.price floatValue]];
                }
                [self.orderArray addObject:product];
            }
        }
        
        if (self.orderArray.count>0) {
            self.orderTable.hidden = NO;
            self.cancelOrderButton.hidden = NO;
            self.confirmOrderButton.hidden = NO;
        }else {
            self.orderTable.hidden = YES;
            self.cancelOrderButton.hidden = YES;
            self.confirmOrderButton.hidden = YES;
        }
        [self.orderTable reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.orderTable]){
        return YES;
    }else
        return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.orderTable]){
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            OrderProductModel *product = (OrderProductModel *)self.orderArray[indexPath.row];
            //TODO:检测套餐卡或者右侧边栏有无选中情况
            
            //套餐卡
            if ([LTDataShare sharedService].packageOrderArray.count>0){
                for (int i=0; i<[LTDataShare sharedService].packageOrderArray.count; i++){
                    NSString *string = [LTDataShare sharedService].packageOrderArray[i];
                    NSArray *array = [string componentsSeparatedByString:@"_"];
                    
                    if ([array[3] integerValue] == [product.productId integerValue]) {//产品id相同
                        PackageCardModel *package = (PackageCardModel *)self.packageCardList[[array[0] integerValue]];
                        PackageCardProductModel *packageProduct = (PackageCardProductModel *)package.productList[[array[1] integerValue]];
                        
                        if ([packageProduct.selected_num integerValue]<=product.number) {
                            packageProduct.selected_num = @"0";
                            
                            [package.productList replaceObjectAtIndex:[array[1] integerValue] withObject:packageProduct];
                            
                            [self.packageCardList replaceObjectAtIndex:[array[0] integerValue] withObject:package];
                            
                            [self.packageTable reloadData];
                            
                            [[LTDataShare sharedService].packageOrderArray removeObjectAtIndex:i];
                            
                            DLog(@"!! = %@",[LTDataShare sharedService].packageOrderArray);
                            break;
                        }
                    }
                }
            }
            
            //右侧边栏
            BOOL isExiting = NO;
            for (int i=0; i<self.billingModel.productList.count; i++) {
                ProductSectionModel *sectionModel = (ProductSectionModel *)self.billingModel.productList[i];
                for (int j=0; j<sectionModel.products.count; j++) {
                    ProductCellModel *cellModel = (ProductCellModel *)sectionModel.products[j];
                    
                    if ([cellModel.productId integerValue]==[product.productId integerValue] && [cellModel.types integerValue]==[product.types integerValue] && [cellModel.selected intValue]==1) {//id相同且选中
                        isExiting = YES;
                        cellModel.selected = [NSString stringWithFormat:@"%d",[self validSelectedValue:[cellModel.selected intValue]]];
                        NSIndexPath *index = [NSIndexPath indexPathForRow:j inSection:i];
                        [self.fastTable reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
                        
                        break;
                    }
                }
                if (isExiting) {
                    break;
                }
            }
            
            NSString *text = [self.footer.totalPriceLabel.text substringFromIndex:3];
            float totalPrice = [text floatValue];
            self.footer.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",totalPrice-[product.price floatValue]*product.validNumber];
            
            [self.orderArray removeObjectAtIndex:indexPath.row];
            [self.orderTable reloadData];
            
            if (self.orderArray.count==0) {
                self.orderTable.hidden = YES;
                self.cancelOrderButton.hidden = YES;
                self.confirmOrderButton.hidden = YES;
            }
        }
    }
        
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.orderTable]){
        return @"删除";
    }else
        return @"";
}

#pragma mark - 订单处理按钮事件
-(void)comfirmOrderInfo
{
    if (self.appDel.isReachable==NO) {
        [Utility errorAlert:@"请检查网络" dismiss:NO];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kServiceBillingMakeOrder];
        //用户信息
        ServiceBillingCustomView *currentView = (ServiceBillingCustomView *)self.scrollView.scrollView.subviews[1];
        NSMutableDictionary *aDic = [CustomerModel dictionaryFromModel:currentView.customerModel];
        
        [aDic setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
        [aDic setObject:[LTDataShare sharedService].user.user_id forKey:@"user_id"];
        
        NSString *prods = [self checkForm];
        [aDic setObject:prods forKey:@"prods"];
        
        [LTInterfaceBase request:aDic requestUrl:urlString method:@"POST" completeBlock:^(NSDictionary *dictionary) {
            //TODO:页面数据清空－－－－
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
//                self.searchModel = nil;
//                self.packageCardList=nil;
//                self.packageBtn.hidden = YES;
//                self.packageTable.hidden = YES;
//                
//                self.orderArray = nil;
//                self.orderTable.hidden = YES;
                
                OrderViewController *orderViewControl = [[OrderViewController alloc]initWithNibName:@"OrderViewController" bundle:nil];
                
                orderViewControl.delegate = self;
                
                [orderViewControl loadData:dictionary];
                
                [self.mainViewControl addChildViewController:orderViewControl];
                [orderViewControl didMoveToParentViewController:self.mainViewControl];
                
                [self.mainViewControl presentPopupViewController:orderViewControl animationType:MJPopupViewAnimationSlideBottomTop width:80];
            });
   
        } errorBlock:^(NSString *notice) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Utility errorAlert:notice dismiss:YES];
            });
        }];
    }
}

- (NSString *)checkForm{
    NSMutableString *prod_ids = [NSMutableString string];
    
    for (int i=0; i<self.orderArray.count; i++) {
        OrderProductModel *product = (OrderProductModel *)self.orderArray[i];
        int type = [product.types intValue];
        
        //type:0-产品  1-服务  2－打折卡  3－套餐卡  4-储值卡
        switch (type) {
            case 0://0_id_count
                [prod_ids appendFormat:@"0_%@_%d,",product.productId,product.validNumber];
                break;
            case 1://1_id_count
                [prod_ids appendFormat:@"1_%@_%d,",product.productId,product.validNumber];
                break;
            case 2://2_id_isNew
                [prod_ids appendFormat:@"2_%@_%@,",product.productId,product.c_isNew];
                break;
            case 3://3_id_isNew(新的)
                [prod_ids appendFormat:@"3_%@_%@,",product.productId,product.c_isNew];
                break;
            case 4://4_id_isNew_password
                [prod_ids appendFormat:@"4_%@_%@_%@,",product.productId,product.c_isNew,self.sv_card_password];
                break;
                
            default:
                break;
        }
    }
    //3_id_isNew_proId=num(老的)
    if ([LTDataShare sharedService].packageOrderArray.count>0){
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        NSMutableArray *prodArray = [[NSMutableArray alloc]init];
        
        for (int i=0; i<[LTDataShare sharedService].packageOrderArray.count; i++) {
            NSString *str = [LTDataShare sharedService].packageOrderArray[i];
            NSArray *array = [str componentsSeparatedByString:@"_"];
            
            NSString *packageId = array[2];
            
            if ([tempArray containsObject:packageId]) { 
                for (int k=0; k<prodArray.count; k++) {
                    NSString *prodString = prodArray[k];
                    
                    NSArray *arrayProd = [prodString componentsSeparatedByString:@"_"];
                    
                    if ([arrayProd[1] intValue]==[packageId intValue]) {
                        NSString *str = [NSString stringWithFormat:@"%@_%@=%@",prodString,array[3],array[4]];
                        [prodArray replaceObjectAtIndex:k withObject:str];
                        break;
                    }
                }
            }else {
                [tempArray addObject:packageId];
                
                NSString *str = [NSString stringWithFormat:@"3_%@_0_%@=%@,",packageId,array[3],array[4]];
                [prodArray addObject:str];
            }
        }
        
        NSString *sting = [prodArray componentsJoinedByString:@","];
        [prod_ids appendFormat:@"%@",sting];
    }
    
    return prod_ids;
}
//确认下单
-(IBAction)sureToOrder:(id)sender
{
    self.isExitSvcard = NO;//是否购买储值卡
    //基本信息
    ServiceBillingCustomView *currentView = (ServiceBillingCustomView *)self.scrollView.scrollView.subviews[1];
    NSString *notice = @"";
    if (currentView.nameField.text.length == 0) {
        notice = @"请输入用户名";
    }
    if (currentView.carNumField.text.length == 0 && notice.length==0){
        notice = @"请输入车牌号";
    }else if (currentView.carNumField.text.length>0 && notice.length==0){
        NSString *carNumRegex = @"[\u4E00-\u9FFF]+[A-Za-z]{1}+[A-Z0-9a-z]{5}";
        NSPredicate *carNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", carNumRegex];
        if (![carNumTest evaluateWithObject:currentView.carNumField.text]){
            notice = @"请输入正确的车牌号";
        }else {
            NSArray *array = [[NSArray alloc]initWithObjects:@"京",@"沪",@"津",@"渝",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新", nil];
            
            NSString *firstLetter = [currentView.carNumField.text substringToIndex:1];
            if (![array containsObject:firstLetter]) {
                notice = @"请输入正确的车牌号";
            }
        }
    }
    if (currentView.phoneField.text.length == 0 && notice.length==0){
        notice = @"请输入手机号码";
    }else if (currentView.phoneField.text.length>0 && notice.length==0){
        NSString *phoneRegex = @"1[0-9]{10}";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        if (![phoneTest evaluateWithObject:currentView.phoneField.text]){
            [Utility errorAlert:@"请输入正确的手机号码" dismiss:YES];
        }
    }
    
    if (notice.length>0) {
        [Utility errorAlert:notice dismiss:YES];
    }else {
        for (OrderProductModel *product in self.orderArray){
            int type = [product.types intValue];
            
            if (type==4) {//购买了储值卡－－设置密码
                self.isExitSvcard = YES;
                self.keyViewController = nil;
                [self presentPopupViewController:self.keyViewController animationType:MJPopupViewAnimationSlideBottomTop width:228];
            }
        }
        
        if (self.isExitSvcard == NO) {//不存在储值卡
            [self comfirmOrderInfo];
        }
    }
}
//取消选择
-(void)cancelSelectedPros
{
    //套餐卡
    if ([LTDataShare sharedService].packageOrderArray.count>0){
        for (int i=0; i<[LTDataShare sharedService].packageOrderArray.count; i++){
            NSString *string = [LTDataShare sharedService].packageOrderArray[i];
            NSArray *array = [string componentsSeparatedByString:@"_"];
            
            PackageCardModel *package = (PackageCardModel *)self.packageCardList[[array[0] integerValue]];
            PackageCardProductModel *packageProduct = (PackageCardProductModel *)package.productList[[array[1] integerValue]];
            
            if ([packageProduct.selected_num integerValue]>0) {
                packageProduct.selected_num = @"0";
                
                [package.productList replaceObjectAtIndex:[array[1] integerValue] withObject:packageProduct];
                
                [self.packageCardList replaceObjectAtIndex:[array[0] integerValue] withObject:package];
                
                [self.packageTable reloadData];
            }
        }
        
        [[LTDataShare sharedService].packageOrderArray removeAllObjects];
    }
    
    //右侧边栏
    for (int i=0; i<self.billingModel.productList.count; i++) {
        ProductSectionModel *sectionModel = (ProductSectionModel *)self.billingModel.productList[i];
        for (int j=0; j<sectionModel.products.count; j++) {
            ProductCellModel *cellModel = (ProductCellModel *)sectionModel.products[j];
            
            if ([cellModel.selected intValue]==1) {//选中
                cellModel.selected = [NSString stringWithFormat:@"%d",[self validSelectedValue:[cellModel.selected intValue]]];
                NSIndexPath *index = [NSIndexPath indexPathForRow:j inSection:i];
                [self.fastTable reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
    
    self.footer.totalPriceLabel.text = @"总计:0.00";
    
    [self.orderArray removeAllObjects];
    [self.orderTable reloadData];
    
    if (self.orderArray.count==0) {
        self.orderTable.hidden = YES;
        self.cancelOrderButton.hidden = YES;
        self.confirmOrderButton.hidden = YES;
    }
}
//取消下单
-(IBAction)cancelToOrder:(id)sender
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:kTitle message:@"确定取消选择?"];
    
    [alert setCancelButtonWithTitle:@"" block:nil];
    [alert addButtonWithTitle:@"" block:^{
        [self cancelSelectedPros];
    }];
    [alert show];
}
#pragma mark - 设置密码界面代理
- (void)closePopView:(KeyViewController *)keyView
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop dismissBlock:^(BOOL isFinish){
        if (keyView.isSuccess) {
            self.sv_card_password = keyView.passWord;
            [self comfirmOrderInfo];
        }
    }];
}
#pragma mark - 订单页面代理
-(void)dismissOrderViewController:(OrderViewController *)orderViewController
{
    __block OrderViewController *orderViewControl = orderViewController;
    [self.mainViewControl dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop dismissBlock:^(BOOL isFinish){
        [self cancelSelectedPros];
        if (orderViewControl.order_type == 0) {
            [Utility errorAlert:@"订单已取消" dismiss:YES];
        }else if (orderViewControl.order_type == 1){
            [Utility errorAlert:@"订单已确认，请到收银台付款" dismiss:NO];
        }else if (orderViewControl.order_type == 2){
            [Utility errorAlert:@"订单付款成功" dismiss:YES];
        }
        
        [orderViewControl willMoveToParentViewController:nil];
        [orderViewControl removeFromParentViewController];
        orderViewControl = nil;
    }];
}
@end
