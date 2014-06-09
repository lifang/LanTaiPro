//
//  LTServiceBillingViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTServiceBillingViewController.h"

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
        _scrollView =[[XLCycleScrollView alloc] initWithFrame:(CGRect){0,40,526,926}];
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
-(void)testData
{
    NSDictionary *aDic = [Utility initWithJSONFile:@"serviceandbilling"];
    [self.billingModel mts_setValuesForKeysWithDictionary:aDic];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchView.layer.borderWidth = 1;
    
    self.leftView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftViewBack"]];
    self.isSearch = NO;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shaixuanSure:) name:@"shaixuanSure" object:nil];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    [self testData];
    [self.leftView addSubview:self.scrollView];
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
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for (ProductSectionModel *sectionModel in self.billingModel.productList){
            [tempArray addObjectsFromArray:sectionModel.products];
        }
        
        NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"name", textField.text];
        self.searchArray  = [NSMutableArray arrayWithArray:[tempArray filteredArrayUsingPredicate:predicateString]];
        [self.fastTable reloadData];
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
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    [self.searchModel mts_setValuesForKeysWithDictionary:dictionary];
                    
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
    return 1;
//    return self.searchModel.customerList.count;
}
- (UIView *)pageAtIndex:(NSInteger)index
{
    NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"ServiceBillingCustomView" owner:self options:nil];
    ServiceBillingCustomView *currentView = (ServiceBillingCustomView*)[bundles objectAtIndex:0];
    
//    SearchCustomerModel *customerModel = (SearchCustomerModel *)self.searchModel.customerList[index];
//    [currentView setCustomerModel:customerModel];
//    currentView.packageCardList = self.searchModel.packageCardList;
//    currentView.discountCardList = self.searchModel.discountCardList;
//    currentView.svCardList = self.searchModel.svCardList;
//    
    
    return currentView;
}
-(void)scrollAtPage:(NSInteger)page
{
    
}

#pragma mark - table代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSearch) {
        return 1;
    }else
        return self.billingModel.productList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isSearch){
        return 0;
    }else
        return 47;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"ServiceBillingCell";
    ServiceBillingCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[ServiceBillingCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    if (self.isSearch) {
        ProductCellModel *cellModel = (ProductCellModel *)self.searchArray[indexPath.row];
        cell.titleLanel.text = cellModel.name;
        cell.priceLabel.text = cellModel.price;
    }else {
        for (int i = 0; i < self.arrSelSection.count; i++) {
            NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
            NSInteger selSection = strSection.integerValue;
            if (indexPath.section == selSection) {
                ProductSectionModel *sectionModel = (ProductSectionModel *)self.billingModel.productList[indexPath.section];
                ProductCellModel *cellModel = (ProductCellModel *)sectionModel.products[indexPath.row];
                cell.titleLanel.text = cellModel.name;
                cell.priceLabel.text = cellModel.price;
                break;
            }
        }
    }

    return cell;
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
@end
