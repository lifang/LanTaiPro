//
//  InfoViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "InfoViewController.h"
#import "SearchCustomView.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    }
    return _dateFormatter;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}
-(void)buildUIWithTag:(NSInteger)tag
{
    self.line1.hidden=YES;self.line2.hidden=YES;
    self.infoTextField.hidden = YES;
    
    self.pickerView.hidden = YES;
    self.brandView.hidden=YES;
    [self.selectedView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.selectedView removeFromSuperview];
    self.selectedView = nil;
    
    self.firstArray=nil;self.secondArray=nil;self.thirdArray=nil;
    if (tag==100){
        self.brandView.hidden=NO;
        if ([LTDataShare sharedService].carModel.carList.count>0) {
            self.firstArray = [NSMutableArray arrayWithArray:[LTDataShare sharedService].carModel.carList];
            [self.brandView reloadAllComponents];
            
            for (int i=0; i<[LTDataShare sharedService].carModel.carList.count; i++) {
                BOOL isOut = NO;
                
                CapitalModel *capital = (CapitalModel *)[LTDataShare sharedService].carModel.carList[i];
                if (capital.barndList.count>0) {
                    for (int j=0; j<capital.barndList.count; j++) {
                        BrandModel *brand = (BrandModel *)capital.barndList[j];
                        if ([brand.name isEqualToString:self.brandName]) {
                            self.secondArray = [NSMutableArray arrayWithArray:capital.barndList];
                            
                            [self.brandView selectRow:i inComponent:0 animated:YES];
                            [self.brandView reloadComponent:1];
                            [self.brandView selectRow:j inComponent:1 animated:YES];
                            [self.brandView reloadComponent:2];
                            
                            if (brand.modelList.count>0) {
                                self.thirdArray = [NSMutableArray arrayWithArray:brand.modelList];
                                
                                for (int k=0; k<brand.modelList.count; k++){
                                    ModelModel *model = (ModelModel *)brand.modelList[k];
                                    if ([model.name isEqualToString:self.modelName]) {
                                        isOut = YES;
                                        [self.brandView selectRow:k inComponent:2 animated:YES];
                                        break;
                                    }
                                }
                            }
                        }
                        if (isOut) {
                            break;
                        }
                    }
                }
                if (isOut) {
                    break;
                }
            }
        }else {
            self.firstArray = [NSMutableArray arrayWithArray:[LTDataShare sharedService].carModel.carList];
            CapitalModel *capital = (CapitalModel *)self.firstArray[0];
            self.secondArray = [NSMutableArray arrayWithArray:capital.barndList];
            BrandModel *brand = (BrandModel *)capital.barndList[0];
            self.thirdArray = [NSMutableArray arrayWithArray:brand.modelList];
            
            [self.brandView selectRow:0 inComponent:0 animated:YES];
            [self.brandView selectRow:0 inComponent:1 animated:YES];
            [self.brandView selectRow:0 inComponent:2 animated:YES];
            [self.brandView reloadAllComponents];
        }
    }
    else if (tag==101) {
        self.pickerView.hidden = NO;
        self.pickerView.date = [NSDate date];
        [self.pickerView setMaximumDate:[NSDate date]];
        [self.view addSubview:self.pickerView];
    }else if(tag==102 || tag==103){
        self.selectedView = [SelectedView defaultSelectedViewWithFrame:(CGRect){0,0,self.view.frame.size} type:self.tagNumber withDefault:@"0" selected:^(NSInteger tag) {
            self.selectedTag = tag;
        }];
        
        [self.view addSubview:self.selectedView];
    }else if (tag==104 || tag==105 || tag==106) {
        self.line1.hidden=NO;self.line2.hidden=NO;self.infoTextField.hidden = NO;
        
        self.infoTextField.text = @"";
        [self.infoTextField becomeFirstResponder];
    }
    
    [self.view layoutIfNeeded];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.popController = [SearchCustomView popVC];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTagNumber:(NSInteger)tagNumber
{
    _tagNumber = tagNumber;
}

#pragma mark   ---------textDelegate----------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length>0) {
        [self.infoTextField resignFirstResponder];
        [self.delegate dismissInfoViewControl:self completed:^(BOOL finished) {
            [self.popController dismissPopoverAnimated:YES options:WYPopoverAnimationOptionScale];
        }];
        
        return YES;
    }else {
        return NO;
    }
}

#pragma mark   ---------pickerDelegate----------------
#pragma mark - picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return 40;
            break;
            
        case 1:
            return 150;
            break;
            
        case 2:
            return 200;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerVieww numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            if (self.firstArray.count == 0) {
                return 1;
            }
            return self.firstArray.count;
            break;
            
        case 1:
            if (self.secondArray.count == 0) {
                return 1;
            }
            return self.secondArray.count;
            break;
            
        case 2:
            if (self.thirdArray.count == 0) {
                return 1;
            }
            return self.thirdArray.count;
            break;
            
        default:
            return 1;
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerVieww titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            if (self.firstArray.count>0) {
                CapitalModel*capital = (CapitalModel *)[self.firstArray objectAtIndex:row];
                return capital.name;
            }
            return @"";
            break;
            
        case 1:
            if (self.secondArray.count>0) {
                BrandModel *brand = (BrandModel *)[self.secondArray objectAtIndex:row];
                return brand.name;
            }
            return @"";
            break;
            
        case 2:
            if (self.thirdArray.count>0) {
                ModelModel *model = (ModelModel *)[self.thirdArray objectAtIndex:row];
                return model.name;
            }
            return @"";
            break;
            
        default:
            return @"";
            break;
    }
}
- (void)pickerView:(UIPickerView *)pickerVieww didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSMutableString *brandStr = nil;
    switch (component) {
        case 0:
            if (self.firstArray.count>0) {
                brandStr = [NSMutableString string];
                CapitalModel *capital = [self.firstArray objectAtIndex:row];
                self.secondArray = [NSMutableArray arrayWithArray:capital.barndList];
                [self.brandView reloadComponent:1];
                [self.brandView selectRow:0 inComponent:1 animated:YES];
                
                if (self.secondArray.count > 0) {
                    BrandModel *brand = [self.secondArray objectAtIndex:0];
                    self.brandName = brand.name;
                    if (brand.modelList!=nil) {
                        self.thirdArray = [NSMutableArray arrayWithArray:brand.modelList];
                        ModelModel *model = (ModelModel *)[self.thirdArray objectAtIndex:0];
                        self.modelName = model.name;
                    }else {
                        self.thirdArray = nil;
                    }
                }else {
                    self.thirdArray = nil;
                }
                [self.brandView reloadComponent:2];
                [self.brandView selectRow:0 inComponent:2 animated:YES];
            }
            break;
            
        case 1:
            if (self.secondArray.count>0) {
                BrandModel *brand = [self.secondArray objectAtIndex:row];
                self.brandName = brand.name;
                if (brand.modelList!=nil) {
                    self.thirdArray = [NSMutableArray arrayWithArray:brand.modelList];
                    ModelModel *model = (ModelModel *)[self.thirdArray objectAtIndex:0];
                    self.modelName = model.name;
                }else {
                    self.thirdArray = nil;
                }
                [self.brandView reloadComponent:2];
                [self.brandView selectRow:0 inComponent:2 animated:YES];
                
            }
            break;
            
        case 2:
            if (self.secondArray.count>0) {
                ModelModel *model = (ModelModel *)[self.thirdArray objectAtIndex:row];
                self.modelName = model.name;
            }
            break;
            
        default:
            break;
            
    }
}

@end
