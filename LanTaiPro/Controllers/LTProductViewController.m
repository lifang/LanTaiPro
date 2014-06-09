//
//  LTProductViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTProductViewController.h"

//下拉刷新
#import "SVPullToRefresh.h"
#import <objc/runtime.h>

#import "UIViewController+MJPopupViewController.h"

static const char productkey;
static const char serivicekey;
static const char cardkey;

static const char productselectedkey;
static const char seriviceselectedkey;
static const char cardselectedkey;

@implementation LTProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - property
- (ProductModel *)productModel
{
    if (!_productModel) {
        _productModel = [[ProductModel alloc]init];
    }
    return _productModel;
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}

-(NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc]init];
    }
    return _selectedArray;
}

-(LTImageViewController *)productImgViewControl{
    if (!_productImgViewControl) {
        _productImgViewControl = [[LTImageViewController alloc]initWithNibName:@"LTImageViewController" bundle:nil];
    }
    return _productImgViewControl;
}

-(void)getTestData
{
    NSDictionary *aDic = [Utility initWithJSONFile:@"productInfo"];
    [self.productModel mts_setValuesForKeysWithDictionary:aDic];
    NSMutableArray *tempArray;
    switch (self.classifyType) {
        case 0:
            tempArray = self.productModel.productList;
            break;
        case 1:
            tempArray = self.productModel.serviceList;
            break;
        case 2:
            tempArray = self.productModel.cardList;
            break;
            
        default:
            tempArray = nil;
            break;
    }
    
    [self testArray:tempArray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchText.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchText.layer.borderWidth = 1;
    
    self.classifyType = 0;
    self.productButton.selected = YES;
    self.serviceButton.selected = NO;
    self.cardButton.selected = NO;
    
    self.mainViewControl = (LTMainViewController *)self.parentViewController;
//    //下拉刷新
//    __block LTProductViewController *productViewControl = self;
//    __block UITableView *table = self.productTable;
//    [_productTable addPullToRefreshWithActionHandler:^{
//        [productViewControl getProductData];
//        [table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
//    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shoppingNotification:) name:@"shoppingNotification" object:nil];
}

-(void)shoppingNotification:(NSNotification *)notification
{
    NSDictionary *aDic = [notification object];
    int isSelected = [[aDic objectForKey:@"isSelected"]integerValue];
    int index = [[aDic objectForKey:@"index"]integerValue];
    
    if (isSelected==0) {
        if (self.classifyType==0) {
            ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.productList[index];
            psModel.p_selected = @"0";
            psModel.p_count -= 1;
            [self.productModel.productList replaceObjectAtIndex:index withObject:psModel];
        }else if (self.classifyType==1){
            ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.serviceList[index];
            psModel.p_selected = @"0";
            psModel.p_count -= 1;
            [self.productModel.serviceList replaceObjectAtIndex:index withObject:psModel];
        }else{
            CardModel *cardModel = (CardModel *)self.productModel.cardList[index];
            cardModel.c_selected = @"0";
            [self.productModel.cardList replaceObjectAtIndex:index withObject:cardModel];
        }
    }else {
        if (self.classifyType==0) {
            ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.productList[index];
            psModel.p_selected = @"1";
            psModel.p_count += 1;
            [self.productModel.productList replaceObjectAtIndex:index withObject:psModel];
        }else if (self.classifyType==1){
            ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.serviceList[index];
            psModel.p_selected = @"1";
            psModel.p_count += 1;
            [self.productModel.serviceList replaceObjectAtIndex:index withObject:psModel];
        }else{
            CardModel *cardModel = (CardModel *)self.productModel.cardList[index];
            cardModel.c_selected = @"1";
            [self.productModel.cardList replaceObjectAtIndex:index withObject:cardModel];
        }
    }
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.productTable reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 分类点击事件
//0 为产品 1 为服务 2 为卡类
-(IBAction)classificationButtonPressed:(id)sender
{
    [self.searchText resignFirstResponder];
    
    switch (self.classifyType) {
        case 0:
            if (self.searchText.text.length>0) {
                objc_setAssociatedObject(self, &productkey, self.searchText.text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            if (self.selectedArray.count>0) {
                objc_setAssociatedObject(self, &productselectedkey, self.selectedArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            break;
        case 1:
            if (self.searchText.text.length>0) {
                objc_setAssociatedObject(self, &serivicekey, self.searchText.text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            if (self.selectedArray.count>0) {
                objc_setAssociatedObject(self, &seriviceselectedkey, self.selectedArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            break;
        case 2:
            if (self.searchText.text.length>0) {
                objc_setAssociatedObject(self, &cardkey, self.searchText.text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            if (self.selectedArray.count>0) {
                objc_setAssociatedObject(self, &cardselectedkey, self.selectedArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            break;
            
        default:
            break;
    }
    
    UIButton *btn = (UIButton *)sender;
    self.classifyType = btn.tag;
    self.selectedArray = nil;
    
    switch (btn.tag) {
        case 0:
            self.productButton.selected = YES;
            self.serviceButton.selected = NO;
            self.cardButton.selected = NO;
            self.searchText.text = objc_getAssociatedObject(self, &productkey);
            self.selectedArray = objc_getAssociatedObject(self, &productselectedkey);
            break;
        case 1:
            self.productButton.selected = NO;
            self.serviceButton.selected = YES;
            self.cardButton.selected = NO;
            self.searchText.text =objc_getAssociatedObject(self, &serivicekey);
            self.selectedArray = objc_getAssociatedObject(self, &seriviceselectedkey);
            break;
        case 2:
            self.productButton.selected = NO;
            self.serviceButton.selected = NO;
            self.cardButton.selected = YES;
            self.searchText.text =objc_getAssociatedObject(self, &cardkey);
            self.selectedArray = objc_getAssociatedObject(self, &cardselectedkey);
            break;
            
        default:
            break;
    }
    
    [self.productTable reloadData];
}
#pragma mark - 获取数据
-(void)testArray:(NSMutableArray *)array
{
    if (array.count>0) {
        self.cancelOrderButton.hidden=NO;
        self.confirmOrderButton.hidden=NO;
        [self.productTable reloadData];
    }else {
        self.cancelOrderButton.hidden=YES;
        self.confirmOrderButton.hidden=YES;
        [Utility errorAlert:@"暂未查找到您需要的产品" dismiss:YES];
    }
}

-(void)getProductData {
    if (self.searchText.text.length==0) {
        [Utility errorAlert:@"请填写您要搜索的产品" dismiss:YES];
    }else {
        [self.searchText resignFirstResponder];
        if (self.appDel.isReachable==NO) {
            [Utility errorAlert:@"请检查网络" dismiss:NO];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kProduct];
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
            [params setObject:[NSString stringWithFormat:@"%d",self.classifyType] forKey:@"types"];
            [params setObject:self.searchText.text forKey:@"product_name"];
            
            [LTInterfaceBase request:params requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    ProductModel *model = [[ProductModel alloc]init];
                    [model mts_setValuesForKeysWithDictionary:dictionary];
                    
                    NSMutableArray *tempArray;
                    switch (self.classifyType) {
                        case 0:
                            self.productModel.productList = model.productList;
                            tempArray = self.productModel.productList;
                            break;
                        case 1:
                            self.productModel.productList = model.serviceList;
                            tempArray = self.productModel.serviceList;
                            break;
                        case 2:
                            self.productModel.productList = model.cardList;
                            tempArray = self.productModel.cardList;
                            break;
                            
                        default:
                            tempArray = nil;
                            break;
                    }
                    
                    [self testArray:tempArray];
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

#pragma mark - 搜索
-(IBAction)searchButtonPressed:(id)sender
{
    [self.searchText resignFirstResponder];
    self.selectedArray = nil;
    [self getTestData];
    
    [self.productTable reloadData];
}
#pragma mark - table代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.classifyType) {
        case 0:
            return self.productModel.productList.count;
            break;
        case 1:
            return self.productModel.serviceList.count;
            break;
        case 2:
            return self.productModel.cardList.count;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"productCell";
    
    id object;
    if (self.classifyType==0  ) {
        ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.productList[indexPath.row];
        object = psModel;
    }else if (self.classifyType==1){
        ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.serviceList[indexPath.row];
        object = psModel;
    }else {
        CardModel *cardModel = (CardModel *)self.productModel.cardList[indexPath.row];
        object = cardModel;
    }
    
    ProductCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier object:object type:self.classifyType];
    }
    cell.delegate = self;
    cell.idxPath = indexPath;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}




#pragma mark - cell代理
-(void)selectedProduct:(UIButton *)btn cell:(ProductCell *)cell isSelected:(BOOL)animated
{
    [self.searchText resignFirstResponder];
    
    NSString *tagString = [NSString stringWithFormat:@"%d",btn.tag];
    if(animated){
        [self.selectedArray addObject:tagString];
        
        if (cell.type==0) {
            ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.productList[btn.tag];
            psModel.p_selected = @"1";
            psModel.p_count += 1;
            [self.productModel.productList replaceObjectAtIndex:btn.tag withObject:psModel];
        }else if (cell.type==1){
            ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.serviceList[btn.tag];
            psModel.p_selected = @"1";
            psModel.p_count += 1;
            [self.productModel.serviceList replaceObjectAtIndex:btn.tag withObject:psModel];
        }else{
            CardModel *cardModel = (CardModel *)self.productModel.cardList[btn.tag];
            cardModel.c_selected = @"1";
            [self.productModel.cardList replaceObjectAtIndex:btn.tag withObject:cardModel];
        }
    }else {
        [self.selectedArray removeObject:tagString];
        
        if (cell.type==0) {
            ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.productList[btn.tag];
            psModel.p_selected = @"0";
            psModel.p_count -= 1;
            [self.productModel.productList replaceObjectAtIndex:btn.tag withObject:psModel];
        }else if (cell.type==1){
            ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.serviceList[btn.tag];
            psModel.p_selected = @"0";
            psModel.p_count -= 1;
            [self.productModel.serviceList replaceObjectAtIndex:btn.tag withObject:psModel];
        }else{
            CardModel *cardModel = (CardModel *)self.productModel.cardList[btn.tag];
            cardModel.c_selected = @"0";
            [self.productModel.cardList replaceObjectAtIndex:btn.tag withObject:cardModel];
        }
    }
}
-(void)expandWithButton:(UIButton *)btn Cell:(ProductCell *)cell
{
    self.productImgViewControl = nil;
    self.productImgViewControl.productModel = self.productModel;
    self.productImgViewControl.classifyType = self.classifyType;
    self.productImgViewControl.currentPage = cell.idxPath.row;
    self.productImgViewControl.selectedArray = self.selectedArray;
    [self presentViewController:self.productImgViewControl animated:YES completion:nil];
}
#pragma mark - 取消or生成订单
-(IBAction)cancelOrderButtonPressed:(id)sender
{
    for (int i=0; i<self.selectedArray.count; i++) {
        int aRow = [self.selectedArray[i] integerValue];
        if (self.classifyType==0) {
            ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.productList[aRow];
            psModel.p_selected = @"0";
            psModel.p_count -= 1;
            [self.productModel.productList replaceObjectAtIndex:aRow withObject:psModel];
        }else if (self.classifyType==1){
            ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.serviceList[aRow];
            psModel.p_selected = @"0";
            psModel.p_count -= 1;
            [self.productModel.serviceList replaceObjectAtIndex:aRow withObject:psModel];
        }else{
            CardModel *cardModel = (CardModel *)self.productModel.cardList[aRow];
            cardModel.c_selected = @"0";
            [self.productModel.cardList replaceObjectAtIndex:aRow withObject:cardModel];
        }
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:aRow inSection:0];
        [self.productTable reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    self.selectedArray = nil;
}
-(IBAction)confirmOrderButtonPressed:(id)sender
{
    if (self.selectedArray.count==0) {
        [Utility errorAlert:@"请选择至少1件产品" dismiss:YES];
    }else {
        NSMutableArray *orderArray = [[NSMutableArray alloc]init];
        if (self.classifyType==0) {
            for (int i=0; i<self.selectedArray.count; i++) {
                ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.productList[[self.selectedArray[i]integerValue]];
                [orderArray addObject:psModel];
            }
        }else if (self.classifyType==1){
            for (int i=0; i<self.selectedArray.count; i++) {
                ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.serviceList[[self.selectedArray[i]integerValue]];
                [orderArray addObject:psModel];
            }
        }else{
            for (int i=0; i<self.selectedArray.count; i++) {
                CardModel *psModel = (CardModel *)self.productModel.cardList[[self.selectedArray[i]integerValue]];
                [orderArray addObject:psModel];
            }
        }

        LTOrderViewController *orderViewControl = [[LTOrderViewController alloc]initWithNibName:@"LTOrderViewController" bundle:nil];
        orderViewControl.delegate = self;

        [orderViewControl loadData:orderArray type:self.classifyType];
        [orderViewControl willMoveToParentViewController:self.mainViewControl];
        [self.mainViewControl addChildViewController:orderViewControl];
        [orderViewControl didMoveToParentViewController:self.mainViewControl];
        
        [self.mainViewControl presentPopupViewController:orderViewControl animationType:MJPopupViewAnimationSlideBottomTop width:140];
        orderArray = nil;
    }
}

#pragma mark - LTOrderViewControlDelegate
- (void)disMissOrderViewControl:(LTOrderViewController *)viewControl
{
    __block LTOrderViewController *orderViewControl = viewControl;
    [self.mainViewControl dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop dismissBlock:^(BOOL isFinish){
        
        [orderViewControl removeFromParentViewController];
        orderViewControl = nil;
    }];
}
@end
