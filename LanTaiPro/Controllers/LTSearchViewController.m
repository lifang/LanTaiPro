//
//  LTSearchViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTSearchViewController.h"

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

-(SearchModel *)searchModel
{
    if (!_searchModel) {
        _searchModel = [[SearchModel alloc]init];
    }
    return _searchModel;
}
-(XLCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView =[[XLCycleScrollView alloc] initWithFrame:(CGRect){0,100,688,924}];
        _scrollView.delegate = self;
        _scrollView.datasource = self;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

-(void)testData
{
    NSDictionary *aDic = [Utility initWithJSONFile:@"searchInfo"];
    [self.searchModel mts_setValuesForKeysWithDictionary:aDic];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shaixuanSure:) name:@"shaixuanSure" object:nil];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    [self testData];
    [self.view addSubview:self.scrollView];
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

#pragma mark - 搜索
-(IBAction)searchButtonPressed:(id)sender
{
    if (self.searchTextField.text.length==0) {
        [Utility errorAlert:@"请填写您要搜索的产品" dismiss:YES];
    }else {
        [self.searchTextField resignFirstResponder];
        if (self.appDel.isReachable==NO) {
            [Utility errorAlert:@"请检查网络" dismiss:NO];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kSearch];
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
            [params setObject:self.searchTextField.text forKey:@"car_num"];
            
            [LTInterfaceBase request:params requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.searchModel mts_setValuesForKeysWithDictionary:dictionary];
                    
                    [self.scrollView reloadData];
                });
            }errorBlock:^(NSString *notice){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [Utility errorAlert:notice dismiss:YES];
                });
            }];
        }
    }
}

#pragma mark - UIScrollView代理
- (NSInteger)numberOfPages
{
    return self.searchModel.customerList.count;
}
- (UIView *)pageAtIndex:(NSInteger)index
{
    NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"SearchCustomView" owner:self options:nil];
    SearchCustomView *currentView = (SearchCustomView*)[bundles objectAtIndex:0];
    
    currentView.orderType = OrderTypeWorking;//正在进行中的订单
    
    SearchCustomerModel *customerModel = (SearchCustomerModel *)self.searchModel.customerList[index];
    [currentView setCustomerModel:customerModel];
    currentView.packageCardList = self.searchModel.packageCardList;
    currentView.discountCardList = self.searchModel.discountCardList;
    currentView.svCardList = self.searchModel.svCardList;
    
    
    return currentView;
}
-(void)scrollAtPage:(NSInteger)page
{
    
}
@end
