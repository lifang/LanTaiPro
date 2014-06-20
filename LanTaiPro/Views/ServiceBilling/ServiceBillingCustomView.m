//
//  ServiceBillingCustomView.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ServiceBillingCustomView.h"

static NSInteger tempTag = 0;
#define LabelTag 1000
#define OrderClassifyButtomTag 98765334
static WYPopoverController *popVC;

@implementation ServiceBillingCustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ServiceBillingCustomView" owner:self options:nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[ServiceBillingCustomView class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
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
    if (customerModel != nil) {
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
    }else {
        for (int i=100; i<107; i++){
            UILabel *label = (UILabel *)[self viewWithTag:i+LabelTag];
            label.text = @"";
        }
        _customerModel = [[SearchCustomerModel alloc]init];
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
