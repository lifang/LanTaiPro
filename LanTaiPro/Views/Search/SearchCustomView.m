//
//  SearchCustomView.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SearchCustomView.h"
//下拉刷新
#import "SVPullToRefresh.h"


static NSInteger tempTag = 0;
#define LabelTag 1000
#define OrderClassifyButtomTag 98765334
static WYPopoverController *popVC;

@implementation SearchCustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SearchCustomView" owner:self options:nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[SearchCustomView class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        
        self.isRefreshing = NO;
        //下拉刷新
        __block SearchCustomView *customView = self;
        __block UITableView *table = self.orderTable;
        [_orderTable addPullToRefreshWithActionHandler:^{
            customView.isRefreshing = YES;
            [customView getOrderInfoWithButton:nil Btn2:nil];
            [table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
        }];
    }
    return self;
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}
+ (WYPopoverController *)popVC
{
    return popVC;
}
-(InfoViewController *)infoViewControl
{
    if (!_infoViewControl) {
        _infoViewControl = [[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
        _infoViewControl.delegate = self;
    }
    return _infoViewControl;
}
-(WYPopoverController *)popController
{
    if (!_popController) {
        _popController = [[WYPopoverController alloc] initWithContentViewController:self.infoViewControl];
        _popController.delegate = self;
        
        _popController.theme.tintColor = [UIColor greenColor];
        _popController.theme.fillTopColor = [UIColor whiteColor];
        _popController.theme.fillBottomColor = [UIColor whiteColor];
        _popController.theme.glossShadowColor = [UIColor clearColor];//边框
        
        popVC = _popController;
    }
    return _popController;
}

-(void)setPageIndex:(NSInteger)pageIndex
{
    _pageIndex = pageIndex;
    
    if ([LTDataShare sharedService].searchModel.customerList.count>0) {
        self.customerModel = (CustomerModel *)[LTDataShare sharedService].searchModel.customerList[_pageIndex];
        
        self.orderType = _customerModel.orderType;
        UIButton *btn = (UIButton *)[self viewWithTag:(self.orderType+OrderClassifyButtomTag)];
        btn.selected = YES;
        
        self.nameField.text = _customerModel.customer_name;
        self.carNumField.text = _customerModel.customer_carNum;
        self.phoneField.text = _customerModel.customer_phone;
        
        for (int i=0; i<5; i++){
            UIButton *btn = (UIButton *)[self viewWithTag:i+OrderClassifyButtomTag];
            btn.hidden = NO;
        }
        for (int i=100; i<107; i++) {
            UILabel *label = (UILabel *)[self viewWithTag:i+LabelTag];
            
            switch (i) {
                case 100:
                    label.text = [NSString stringWithFormat:@"%@  %@",_customerModel.customer_brandName,_customerModel.customer_modelName];
                    break;
                case 101:
                    label.text = _customerModel.customer_carYear;
                    break;
                case 102:
                    if ([_customerModel.customer_property intValue]==0) {
                        label.text = @"个人";
                    }else {
                        label.text = @"单位";
                    }
                    break;
                case 103:
                    
                    if ([_customerModel.customer_sex intValue]==0) {
                        label.text = @"男";
                    }else {
                        label.text = @"女";
                    }
                    
                    break;
                case 104:
                    label.text = _customerModel.customer_vin;
                    break;
                case 105:
                    label.text = _customerModel.customer_distance;
                    break;
                case 106:
                    label.text = _customerModel.customer_company;
                    break;
                    
                default:
                    break;
            }
        }
        
        [self.orderTable reloadData];
    }else {
        for (int i=100; i<107; i++){
            UILabel *label = (UILabel *)[self viewWithTag:i+LabelTag];
            label.text = @"";
        }
        self.customerModel = [[CustomerModel alloc]init];
        
        for (int i=0; i<5; i++){
            UIButton *btn = (UIButton *)[self viewWithTag:i+OrderClassifyButtomTag];
            btn.hidden = YES;
        }
    }
}
#pragma mark - 信息编辑的点击事件

-(IBAction)infoButtonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    tempTag = btn.tag;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    __block UIBarButtonItem *barItemm = barItem;
    
    switch (btn.tag) {
        case 100:
            self.infoViewControl.brandName =self.customerModel.customer_brandName;
            self.infoViewControl.modelName =self.customerModel.customer_modelName;
            self.popController.popoverContentSize = (CGSize){410,216};
            break;
        case 101:
            self.popController.popoverContentSize = (CGSize){270,162};
            break;
        case 102:
            self.infoViewControl.firstTag = [self.customerModel.customer_property intValue];
            self.popController.popoverContentSize = (CGSize){250,82};
            break;
        case 103:
            self.infoViewControl.firstTag = [self.customerModel.customer_sex intValue];
            self.popController.popoverContentSize = (CGSize){250,82};
            break;
        case 104:
            self.popController.popoverContentSize = (CGSize){250,70};
            break;
        case 105:
            self.popController.popoverContentSize = (CGSize){200,70};
            break;
        case 106:
            self.popController.popoverContentSize = (CGSize){520,70};
            break;
            
        default:
            break;
    }
    
    self.infoViewControl.tagNumber = btn.tag;
    [self.infoViewControl buildUIWithTag:btn.tag];
    [self.popController presentPopoverFromBarButtonItem:barItem permittedArrowDirections:WYPopoverArrowDirectionLeft animated:YES completion:^{
        barItemm=nil;
    }];
}

#pragma mark - WYPopoverController代理
- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController
{
    UILabel *label = (UILabel *)[self viewWithTag:tempTag+LabelTag];
    
    switch (tempTag) {
        case 100:
            self.carBrand = self.infoViewControl.brandName;
            self.carModel = self.infoViewControl.modelName;
            
            self.customerModel.customer_brandName=self.infoViewControl.brandName;
            self.customerModel.customer_modelName=self.infoViewControl.modelName;
            
            label.text = [NSString stringWithFormat:@"%@  %@",self.carBrand,self.carModel];
            break;
        case 101:
            label.text = [self.infoViewControl.dateFormatter stringFromDate:self.infoViewControl.pickerView.date];
            self.customerModel.customer_carYear = label.text;
            break;
        case 102:
            if (self.infoViewControl.selectedTag==0) {
                label.text = @"个人";
            }else {
                label.text = @"单位";
            }
            self.customerModel.customer_property = [NSString stringWithFormat:@"%d",self.infoViewControl.selectedTag];
            break;
        case 103:
            if (self.infoViewControl.selectedTag==0) {
                label.text = @"男";
            }else {
                label.text = @"女";
            }
            self.customerModel.customer_sex = [NSString stringWithFormat:@"%d",self.infoViewControl.selectedTag];
            break;
            
        default:
            break;
    }
}
#pragma mark - infoView代理

-(void)dismissInfoViewControl:(InfoViewController *)viewControl completed:(void(^)(BOOL finished))finish
{
    UILabel *label = (UILabel *)[self viewWithTag:tempTag+LabelTag];
    switch (tempTag) {
        case 100:
            break;
        case 101:
            break;
        case 102:
            break;
        case 103:
            break;
        case 104:
            label.text = self.infoViewControl.infoTextField.text;
            self.customerModel.customer_vin = label.text;
            break;
        case 105:
            label.text = self.infoViewControl.infoTextField.text;
            self.customerModel.customer_distance = label.text;
            break;
        case 106:
            label.text = self.infoViewControl.infoTextField.text;
            self.customerModel.customer_company = label.text;
            break;
            
        default:
            break;
    }
    finish(YES);
}

#pragma mark - 订单类型点击
-(void)getOrderInfoWithButton:(UIButton *)btn Btn2:(UIButton *)btn2
{
    if (self.appDel.isReachable==NO) {
        [Utility errorAlert:@"请检查网络" dismiss:NO];
    }else {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kSearchClassify];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
        [params setObject:self.customerModel.customer_id forKey:@"customer_id"];
        [params setObject:[NSString stringWithFormat:@"%d",self.orderType] forKey:@"type"];
        [params setObject:self.customerModel.customer_carNumId forKey:@"car_num_id"];
        
        [LTInterfaceBase request:params requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self animated:YES];
                
                if (self.orderType == OrderTypeWorking) {
                    WorkingOrderModel *workingObj = [[WorkingOrderModel alloc]init];
                    [workingObj mts_setValuesForKeysWithDictionary:dictionary];
                    self.customerModel.workingOrderList = workingObj.workingOrderList;
                    
                }else if (self.orderType == OrderTypeOld){
                    OldOrderModel *oldObj = [[OldOrderModel alloc]init];
                    [oldObj mts_setValuesForKeysWithDictionary:dictionary];
                    self.customerModel.oldOrderList = oldObj.oldOrderList;
                    
                }else if (self.orderType == OrderTypePackage){
                    PackageOrderModel *packageObj = [[PackageOrderModel alloc]init];
                    [packageObj mts_setValuesForKeysWithDictionary:dictionary];
                    [LTDataShare sharedService].searchModel.packageCardList = packageObj.packageCardList;
                    
                    if ([LTDataShare sharedService].searchModel.packageCardList.count>0) {
                        [self setTableFooter];
                    }
                    
                }else if (self.orderType == OrderTypeSvCard){
                    SvCardOrderModel *svObj = [[SvCardOrderModel alloc]init];
                    [svObj mts_setValuesForKeysWithDictionary:dictionary];
                    [LTDataShare sharedService].searchModel.svCardList = svObj.svCardList;
                    
                }else if (self.orderType == OrderTypeDiscountCard){
                    DiscountCardOrderModel *discountObj = [[DiscountCardOrderModel alloc]init];
                    [discountObj mts_setValuesForKeysWithDictionary:dictionary];
                    [LTDataShare sharedService].searchModel.discountCardList = discountObj.discountCardList;
                }
                if (self.isRefreshing==NO) {
                    btn2.selected = NO;
                    btn.selected = YES;
                    
                    self.customerModel.orderType = self.orderType;
                }
                [[LTDataShare sharedService].searchModel.customerList replaceObjectAtIndex:self.pageIndex withObject:self.customerModel];
                [self.orderTable reloadData];
                self.isRefreshing = NO;
            });
        } errorBlock:^(NSString *notice) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self animated:YES];
                [Utility errorAlert:notice dismiss:YES];
                self.isRefreshing = NO;
                self.orderType = self.customerModel.orderType;
            });
        }];
    }
}

-(void)checkArray:(NSMutableArray *)mutableArray withBtn:(UIButton *)btn Btn2:(UIButton *)btn2
{
    if (mutableArray.count>0) {
        btn2.selected = NO;
        btn.selected = YES;
        self.customerModel.orderType = self.orderType;
        [[LTDataShare sharedService].searchModel.customerList replaceObjectAtIndex:self.pageIndex withObject:self.customerModel];
        
        [self.orderTable reloadData];
        
        if (self.orderType == OrderTypePackage) {
            [self setTableFooter];
        }
    }else {
        [self getOrderInfoWithButton:btn Btn2:btn2];
    }
}

-(IBAction)orderClassifyButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ((btn.tag-OrderClassifyButtomTag)==self.orderType) {
        //点击相同分类，不做操作
    }else {
        UIButton *btn2 = (UIButton *)[self viewWithTag:(self.orderType+OrderClassifyButtomTag)];
        
        self.orderType = btn.tag-OrderClassifyButtomTag;
        
        [self.orderTable setTableFooterView:nil];
        
        if (self.orderType == OrderTypeWorking) {
            [self checkArray:self.customerModel.workingOrderList withBtn:btn Btn2:btn2];
        }else if (self.orderType == OrderTypeOld){
            [self checkArray:self.customerModel.oldOrderList withBtn:btn Btn2:btn2];
        }else if (self.orderType == OrderTypePackage){
            //清空套餐卡的选择
            if ([LTDataShare sharedService].packageOrderArray.count>0){
                for (int i=0; i<[LTDataShare sharedService].packageOrderArray.count; i++) {
                    NSString *str = [LTDataShare sharedService].packageOrderArray[i];
                    NSArray *array = [str componentsSeparatedByString:@"_"];
                    
                    PackageCardModel *packageModel = (PackageCardModel *)[LTDataShare sharedService].searchModel.packageCardList[[array[0] intValue]];
                    PackageCardProductModel *productModel = (PackageCardProductModel *)packageModel.productList[[array[1] intValue]];
                    
                    if ([productModel.productId intValue]==[array[3] intValue]) {
                        productModel.selected_num = @"0";
                        
                        [packageModel.productList replaceObjectAtIndex:[array[1] intValue] withObject:productModel];
                        [[LTDataShare sharedService].searchModel.packageCardList replaceObjectAtIndex:[array[0] intValue] withObject:packageModel];
                    }
                }
            }
            
            [LTDataShare sharedService].packageOrderArray = nil;
            
            [self checkArray:[LTDataShare sharedService].searchModel.packageCardList withBtn:btn Btn2:btn2];
            
        }else if (self.orderType == OrderTypeSvCard){
            [self checkArray:[LTDataShare sharedService].searchModel.svCardList withBtn:btn Btn2:btn2];
        }else if (self.orderType == OrderTypeDiscountCard){
            [self checkArray:[LTDataShare sharedService].searchModel.discountCardList withBtn:btn Btn2:btn2];
        }
    }
}
-(void)setTableFooter {
    UIView *footerView = [[UIView alloc]initWithFrame:(CGRect){0,0,648,44}];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"arrangeOrder"] forState:UIControlStateNormal];
    [btn setTitle:@"下单" forState:UIControlStateNormal];
    btn.frame = (CGRect){550,5,88,33};
    [btn addTarget:self action:@selector(packageToOrder) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    [self.orderTable setTableFooterView:footerView];
    
    btn = nil;
    footerView = nil;
}
#pragma mark - table代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.orderType) {
        case 0:
            return self.customerModel.workingOrderList.count;
            break;
        case 1:
            return self.customerModel.oldOrderList.count;
            break;
        case 2:
            return [LTDataShare sharedService].searchModel.packageCardList.count;
            break;
        case 3:
            return [LTDataShare sharedService].searchModel.svCardList.count;
            break;
        case 4:
            return [LTDataShare sharedService].searchModel.discountCardList.count;
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderType==OrderTypeWorking) {
        static NSString * identifier = @"workingOrderCell";
        
        SearchOrder *productObj = (SearchOrder *)self.customerModel.workingOrderList[indexPath.row];
        
        WorkingOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[WorkingOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier workingOrder:productObj];
        }
        cell.delegate = self;
        cell.idxPath = indexPath;
        return cell;
    }else if (self.orderType==OrderTypeOld){
        static NSString * identifier = @"oldOrderCell";
        
        SearchOrder *productObj = (SearchOrder *)self.customerModel.oldOrderList[indexPath.row];
        
        OldOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[OldOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier oldOrder:productObj];
        }
        cell.delegate = self;
        cell.idxPath = indexPath;
        return cell;
        
    }else if (self.orderType==OrderTypePackage){
        static NSString * identifier = @"packageCardOrderCell";
        
        PackageCardModel *package = (PackageCardModel *)[LTDataShare sharedService].searchModel.packageCardList[indexPath.row];
        
        PackageCardCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PackageCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier packageCardModel:package];
        }
        cell.delegate = self;
        cell.idxPath = indexPath;
        return cell;
    }else if (self.orderType==OrderTypeSvCard){
        static NSString * identifier = @"svCardOrderCell";
        SvCardCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        SvCardModel *svCard = (SvCardModel *)[LTDataShare sharedService].searchModel.svCardList[indexPath.row];
        
        if (!cell) {
            cell = [[SvCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier svCard:svCard];
        }

        return cell;
    }else if (self.orderType==OrderTypeDiscountCard){
        static NSString * identifier = @"discountCardOrderCell";
        
        DiscountCardModel *disCard = (DiscountCardModel *)[LTDataShare sharedService].searchModel.discountCardList[indexPath.row];
        
        DiscountCardCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[DiscountCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier discountCard:disCard];
        }
        return cell;
    }else
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderType==OrderTypeWorking) {
        SearchOrder *productObj = (SearchOrder *)self.customerModel.workingOrderList[indexPath.row];
        return 160 +productObj.productList.count*30;
    }else if (self.orderType==OrderTypeOld){
        SearchOrder *productObj = (SearchOrder *)self.customerModel.oldOrderList[indexPath.row];
        return 160 +productObj.productList.count*30;
    }else if (self.orderType==OrderTypePackage){
        PackageCardModel *package = (PackageCardModel *)[LTDataShare sharedService].searchModel.packageCardList[indexPath.row];
        return 100+package.productList.count*30;
    }else if (self.orderType==OrderTypeSvCard){
        SvCardModel *svCard = (SvCardModel *)[LTDataShare sharedService].searchModel.svCardList[indexPath.row];
        return 81+svCard.recordList.count*30;
    }else if (self.orderType==OrderTypeDiscountCard){
        
        DiscountCardModel *disCard = (DiscountCardModel *)[LTDataShare sharedService].searchModel.discountCardList[indexPath.row];
        NSString *content = [NSString stringWithFormat:@"适用:%@",disCard.apply_content];
        NSString *total_content = [NSString stringWithFormat:@"%@ %.1f折",content,[disCard.discount floatValue]/10];
        
        CGSize size = [self getSizeWithString:total_content];
        
        return 70 +size.height;
    }else
        return 1;
}
-(CGSize)getSizeWithString:(NSString *)str{
    UIFont *aFont = [UIFont fontWithName:@"HiraginoSansGB-W6" size:17];
    CGSize size = [str sizeWithFont:aFont constrainedToSize:CGSizeMake(616, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}
#pragma mark - 正在进行中的订单的代理

#pragma mark - 取消订单
-(void)cancelWorkingOrder:(WorkingOrderCell *)cell
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:kTitle message:@"确定取消订单?"];
    
    [alert setCancelButtonWithTitle:@"" block:nil];
    [alert addButtonWithTitle:@"" block:^{
        SearchOrder *productObj = (SearchOrder *)self.customerModel.workingOrderList[cell.idxPath.row];
        if (self.appDel.isReachable==NO) {
            BOOL success = NO;//记录添加本地是否成功
            LTDB *db = [[LTDB alloc]init];
            OrderModel *orderModel = [db getLocalOrderInfoWhereOid:productObj.order_id];
            if (orderModel != nil){
                orderModel.order_status = [NSString stringWithFormat:@"%d",7];//7:取消订单
                
                success = [db updateOrderInfoWithOrder:orderModel WhereOid:productObj.order_id];
            }else {
                orderModel = [[OrderModel alloc]init];
                orderModel.store_id = [LTDataShare sharedService].user.store_id;
                orderModel.order_id =[NSString stringWithFormat:@"%@",productObj.order_id];
                orderModel.order_status = [NSString stringWithFormat:@"%d",7];
                
                success = [db saveOrderDataToLocal:orderModel];
            }
            
            if (success) {
                [self.customerModel.workingOrderList removeObjectAtIndex:cell.idxPath.row];
                
                [[LTDataShare sharedService].searchModel.customerList replaceObjectAtIndex:self.pageIndex withObject:self.customerModel];
                
                [self.orderTable beginUpdates];
                [self.orderTable deleteRowsAtIndexPaths:@[cell.idxPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.orderTable endUpdates];
                
                [Utility errorAlert:@"订单已取消" dismiss:YES];
                
            }else {
                [Utility errorAlert:@"订单取消失败" dismiss:NO];
            }
        }else{
            [MBProgressHUD showHUDAddedTo:self animated:YES];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kSearchCancelOrder];
            
            NSMutableDictionary *paramas = [[NSMutableDictionary alloc] init];
            
            [paramas setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
            [paramas setObject:productObj.order_id forKey:@"order_id"];
            
            [LTInterfaceBase request:paramas requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary) {
                NSDictionary *stationDic = [dictionary objectForKey:@"work_orders"];
                [LTDataShare sharedService].stationDic = [NSMutableDictionary dictionaryWithDictionary:stationDic];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self animated:YES];
                    
                    [self.customerModel.workingOrderList removeObjectAtIndex:cell.idxPath.row];
                    
                    [[LTDataShare sharedService].searchModel.customerList replaceObjectAtIndex:self.pageIndex withObject:self.customerModel];
                    
                    [self.orderTable beginUpdates];
                    [self.orderTable deleteRowsAtIndexPaths:@[cell.idxPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.orderTable endUpdates];
                    
                    [Utility errorAlert:@"订单已取消" dismiss:YES];
                });
            } errorBlock:^(NSString *notice) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self animated:YES];
                    [Utility errorAlert:notice dismiss:YES];
                });
            }];
        }
    }];
    [alert show];
}
#pragma mark - 付款
-(void)payWorkingOrder:(WorkingOrderCell *)cell
{
    if (self.appDel.isReachable==NO) {
        [Utility errorAlert:@"请检查网络" dismiss:NO];
    }else {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        SearchOrder *productObj = (SearchOrder *)self.customerModel.workingOrderList[cell.idxPath.row];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kSearchCancelOrder];
        
        NSMutableDictionary *paramas = [[NSMutableDictionary alloc] init];
        
        [paramas setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
        [paramas setObject:productObj.order_id forKey:@"order_id"];
        
        [LTInterfaceBase request:paramas requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary) {
            NSDictionary *stationDic = [dictionary objectForKey:@"work_orders"];
            [LTDataShare sharedService].stationDic = [NSMutableDictionary dictionaryWithDictionary:stationDic];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self animated:YES];
    
                [self.delegate payOrderWithDic:nil finishBlock:^(BOOL isFinish){
                    if (isFinish) {
                        [self.customerModel.workingOrderList removeObjectAtIndex:cell.idxPath.row];
                        [[LTDataShare sharedService].searchModel.customerList replaceObjectAtIndex:self.pageIndex withObject:self.customerModel];
                        
                        [self.orderTable beginUpdates];
                        [self.orderTable deleteRowsAtIndexPaths:@[cell.idxPath] withRowAnimation:UITableViewRowAnimationFade];
                        [self.orderTable endUpdates];

                    }
                }];
            });
        } errorBlock:^(NSString *notice) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self animated:YES];
                [Utility errorAlert:notice dismiss:YES];
            });
        }];
    }
}
#pragma mark - 退单
-(void)returnBackOrder:(WorkingOrderCell *)cell
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:kTitle message:@"确定取消退单?"];
    
    [alert setCancelButtonWithTitle:@"" block:nil];
    [alert addButtonWithTitle:@"" block:^{
        SearchOrder *productObj = (SearchOrder *)self.customerModel.workingOrderList[cell.idxPath.row];
        if (self.appDel.isReachable==NO) {
            BOOL success = NO;//记录添加本地是否成功
            LTDB *db = [[LTDB alloc]init];
            OrderModel *orderModel = [db getLocalOrderInfoWhereOid:productObj.order_id];
            if (orderModel != nil){
                orderModel.order_status = [NSString stringWithFormat:@"%d",7];//7:取消订单
                
                success = [db updateOrderInfoWithOrder:orderModel WhereOid:productObj.order_id];
            }else {
                orderModel = [[OrderModel alloc]init];
                orderModel.store_id = [LTDataShare sharedService].user.store_id;
                orderModel.order_id =[NSString stringWithFormat:@"%@",productObj.order_id];
                orderModel.order_status = [NSString stringWithFormat:@"%d",7];
                
                success = [db saveOrderDataToLocal:orderModel];
            }
            
            if (success) {
                [self.customerModel.workingOrderList removeObjectAtIndex:cell.idxPath.row];
                
                [[LTDataShare sharedService].searchModel.customerList replaceObjectAtIndex:self.pageIndex withObject:self.customerModel];
                
                [self.orderTable beginUpdates];
                [self.orderTable deleteRowsAtIndexPaths:@[cell.idxPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.orderTable endUpdates];
                
                [Utility errorAlert:@"订单已取消" dismiss:YES];
                
            }else {
                [Utility errorAlert:@"订单取消失败" dismiss:NO];
            }
        }else{
            [MBProgressHUD showHUDAddedTo:self animated:YES];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kSearchCancelOrder];
            
            NSMutableDictionary *paramas = [[NSMutableDictionary alloc] init];
            
            [paramas setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
            [paramas setObject:productObj.order_id forKey:@"order_id"];
            
            [LTInterfaceBase request:paramas requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary) {
                NSDictionary *stationDic = [dictionary objectForKey:@"work_orders"];
                [LTDataShare sharedService].stationDic = [NSMutableDictionary dictionaryWithDictionary:stationDic];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self animated:YES];
                    
                    [self.customerModel.workingOrderList removeObjectAtIndex:cell.idxPath.row];
                    
                    [[LTDataShare sharedService].searchModel.customerList replaceObjectAtIndex:self.pageIndex withObject:self.customerModel];
                    
                    [self.orderTable beginUpdates];
                    [self.orderTable deleteRowsAtIndexPaths:@[cell.idxPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.orderTable endUpdates];
                    
                    [Utility errorAlert:@"订单已取消" dismiss:YES];
                });
            } errorBlock:^(NSString *notice) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self animated:YES];
                    [Utility errorAlert:notice dismiss:YES];
                });
            }];
        }
    }];
    [alert show];
}
#pragma mark - 消费记录的订单的代理
-(void)ComplaintOldOrder:(OldOrderCell *)cell
{
    SearchOrder *productObj = (SearchOrder *)self.customerModel.oldOrderList[cell.idxPath.row];
    
    NSMutableString *prods = [NSMutableString string];
    for (int i=0; i<productObj.productList.count; i++) {
        SearchProduct *productModel = (SearchProduct *)productObj.productList[i];
        [prods appendFormat:@"%@,",productModel.name];
    }
    NSString *prod = [prods substringToIndex:prods.length - 1];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:prod,ComplaintProds,productObj.code,ComplaintCode,self.carNumField.text,ComplaintCarNum,productObj.order_id,ComplaintOrderId, nil];
    
    if ([self.delegate respondsToSelector:@selector(presentCompliantViewControlWithDictionary:)]) {
        [self.delegate presentCompliantViewControlWithDictionary:aDic];
    }
}

#pragma mark - 套餐卡下单
-(void)packageToOrder
{
    if ([LTDataShare sharedService].packageOrderArray.count>0) {
        //TODO:切换到开单页面
        if ([self.delegate respondsToSelector:@selector(dismisSearchCustomView:)]) {
            [self.delegate dismisSearchCustomView:self];
        }
    }else {
        [Utility errorAlert:@"至少选择一项产品" dismiss:YES];
    }
}

#pragma mark - UITextField代理
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nameField]) {
        self.customerModel.customer_name = textField.text;
    }else if ([textField isEqual:self.carNumField]){
        self.customerModel.customer_carNum = textField.text;
    }else if ([textField isEqual:self.phoneField]){
        self.customerModel.customer_phone = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:self.nameField]) {
        self.customerModel.customer_name = textField.text;
    }else if ([textField isEqual:self.carNumField]){
        self.customerModel.customer_carNum = textField.text;
    }else if ([textField isEqual:self.phoneField]){
        self.customerModel.customer_phone = textField.text;
    }
    return YES;
}
@end
