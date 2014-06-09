//
//  InfoViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "SelectedView.h"

@protocol InfoViewControlDelegate;

@interface InfoViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) id<InfoViewControlDelegate>delegate;

@property (nonatomic, weak) IBOutlet UITextField *infoTextField;
@property (nonatomic, weak) IBOutlet UIView *line1;
@property (nonatomic, weak) IBOutlet UIView *line2;
///判断信息
@property (nonatomic, assign) NSInteger tagNumber;
@property (nonatomic, strong) WYPopoverController *popController;
///checkbox
@property (nonatomic, assign) NSInteger firstTag;
@property (nonatomic, strong) SelectedView *selectedView;
@property (nonatomic, assign) NSInteger selectedTag;

///时间
@property (nonatomic, weak) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
///车辆品牌，型号
@property (nonatomic, weak) IBOutlet UIPickerView *brandView;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *modelName;

@property (nonatomic, strong) CapitalModel *capitalModel;
@property (nonatomic, strong) BrandModel *brandModel;
@property (nonatomic, strong) ModelModel *modelModel;

-(void)buildUIWithTag:(NSInteger)tag;
@end


@protocol InfoViewControlDelegate <NSObject>
-(void)dismissInfoViewControl:(InfoViewController *)viewControl completed:(void(^)(BOOL finished))finish;
@end