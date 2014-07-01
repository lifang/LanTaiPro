//
//  ComplaintViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-18.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol ComplaintDelegate;

@interface ComplaintViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, strong) AppDelegate *appDel;
@property (nonatomic, assign) id<ComplaintDelegate>delegate;

@property (nonatomic, weak) IBOutlet UILabel *lblCarNum,*lblCode,*lblProduct;
@property (nonatomic, weak) IBOutlet UITextView *reasonView,*requestView;
@property (nonatomic, weak) IBOutlet UIButton *sureBtn,*cancleBtn;

@property (nonatomic, strong) NSDictionary *infoDic;
@end

@protocol ComplaintDelegate <NSObject>

-(void)dismissComplaintViewControl:(ComplaintViewController *)complaintViewController;

@end