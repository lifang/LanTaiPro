//
//  SearchCustomView.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SearchCustomView.h"

static NSInteger tempTag = 0;
#define LabelTag 1000
#define OrderClassifyButtomTag 98765334
static WYPopoverController *popVC;

@implementation SearchCustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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

- (void)setCustomerModel:(SearchCustomerModel *)customerModel
{
    _customerModel = customerModel;
    
    self.nameField.text = _customerModel.customer_name;
    self.carNumField.text = _customerModel.customer_carNum;
    self.phoneField.text = _customerModel.customer_phone;
    
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
            
            break;
        case 101:
            label.text = [self.infoViewControl.dateFormatter stringFromDate:self.infoViewControl.pickerView.date];
            break;
        case 102:
            if (self.infoViewControl.selectedTag==0) {
                label.text = @"个人";
            }else {
                label.text = @"单位";
            }
            break;
        case 103:
            if (self.infoViewControl.selectedTag==0) {
                label.text = @"男";
            }else {
                label.text = @"女";
            }
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
            if (self.infoViewControl.selectedTag==0) {
                label.text = @"个人";
            }else {
                label.text = @"单位";
            }
            break;
        case 103:
            if (self.infoViewControl.selectedTag==0) {
                label.text = @"男";
            }else {
                label.text = @"女";
            }
            break;
        case 104:
            label.text = self.infoViewControl.infoTextField.text;
            break;
        case 105:
            label.text = self.infoViewControl.infoTextField.text;
            break;
        case 106:
            label.text = self.infoViewControl.infoTextField.text;
            
            break;
            
        default:
            break;
    }
    finish(YES);
}

-(void)setOrderType:(OrderTypes)orderType
{
    _orderType = orderType;
    UIButton *btn = (UIButton *)[self viewWithTag:(_orderType+OrderClassifyButtomTag)];
    btn.selected = YES;

}
#pragma mark - 订单类型点击
-(IBAction)orderClassifyButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ((btn.tag-OrderClassifyButtomTag)==self.orderType) {
        
    }else {
        UIButton *btn2 = (UIButton *)[self viewWithTag:(_orderType+OrderClassifyButtomTag)];
        btn2.selected = NO;
        btn.selected = YES;
        self.orderType = btn.tag-OrderClassifyButtomTag;
        
        if (self.orderType==OrderTypePackage) {
            [LTDataShare sharedService].packageOrderArray = nil;
        }
        [self.orderTable reloadData];
    }
    
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
            return self.packageCardList.count;
            break;
        case 3:
            return self.svCardList.count;
            break;
        case 4:
            return self.discountCardList.count;
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
        
        return cell;
    }else if (self.orderType==OrderTypeOld){
        static NSString * identifier = @"oldOrderCell";
        
        SearchOrder *productObj = (SearchOrder *)self.customerModel.oldOrderList[indexPath.row];
        
        OldOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[OldOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier oldOrder:productObj];
        }
        cell.delegate = self;
        
        return cell;
        
    }else if (self.orderType==OrderTypePackage){
        static NSString * identifier = @"packageCardOrderCell";
        
        PackageCardModel *package = (PackageCardModel *)self.packageCardList[indexPath.row];
        
        PackageCardCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PackageCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier packageCardModel:package];
        }
        cell.delegate = self;
        
        return cell;
    }else if (self.orderType==OrderTypeSvCard){
        static NSString * identifier = @"svCardOrderCell";
        SvCardCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        SvCardModel *svCard = (SvCardModel *)self.svCardList[indexPath.row];
        
        if (!cell) {
            cell = [[SvCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier svCard:svCard];
        }

        return cell;
    }else if (self.orderType==OrderTypeDiscountCard){
        static NSString * identifier = @"discountCardOrderCell";
        
        DiscountCardModel *disCard = (DiscountCardModel *)self.discountCardList[indexPath.row];
        
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
        PackageCardModel *package = (PackageCardModel *)self.packageCardList[indexPath.row];
        return 100+package.productList.count*30;
    }else if (self.orderType==OrderTypeSvCard){
        SvCardModel *svCard = (SvCardModel *)self.svCardList[indexPath.row];
        return 81+svCard.recordList.count*30;
    }else if (self.orderType==OrderTypeDiscountCard){
        DiscountCardModel *disCard = (DiscountCardModel *)self.discountCardList[indexPath.row];
        return 81+disCard.productList.count*30;
    }else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.orderType==OrderTypePackage && self.packageCardList.count>0){
        return 44;
    }else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.orderType==OrderTypePackage && self.packageCardList.count>0){
        UIView *footerView = [[UIView alloc]initWithFrame:(CGRect){0,0,CGRectGetWidth(tableView.bounds),44}];
//        footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-background.jpg"]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"arrangeOrder"] forState:UIControlStateNormal];
        [btn setTitle:@"下单" forState:UIControlStateNormal];
        btn.frame = (CGRect){550,5,88,33};
        [btn addTarget:self action:@selector(packageToOrder) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn];
        btn = nil;
        return footerView;
        
    }else
        return nil;
}
#pragma mark - 正在进行中的订单的代理
-(void)cancelWorkingOrder:(WorkingOrderCell *)cell
{
    
}
-(void)confirmWorkingOrder:(WorkingOrderCell *)cell
{
    
}
#pragma mark - 消费记录的订单的代理
-(void)ComplaintOldOrder:(OldOrderCell *)cell
{
    
}

#pragma mark - 套餐卡下单
-(void)packageToOrder
{
    if ([LTDataShare sharedService].packageOrderArray.count>0) {
        
    }else {
        [Utility errorAlert:@"至少选择一项产品" dismiss:YES];
    }
}

@end
