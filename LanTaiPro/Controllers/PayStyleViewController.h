//
//  PayStyleViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-19.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayStyleViewDelegate;

@interface PayStyleViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, assign) id<PayStyleViewDelegate> delegate;
@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic,strong) NSMutableDictionary *order;
///储值卡数组
@property (nonatomic, strong) NSMutableArray *save_cardArray;
@property (nonatomic, weak) IBOutlet UISwitch *billingBtn;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, strong) IBOutlet UIView *payStyleView,*cardView,*passView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segBtn;
//储值卡页面
@property (nonatomic,  weak) IBOutlet UITextField *txtPwd;
@property (nonatomic, strong) IBOutlet UIButton *cardBackBtn,*forgetBtn,*cardSureBtn;
//修改密码页面
@property (weak, nonatomic) IBOutlet UITextField *pTxt1;
@property (weak, nonatomic) IBOutlet UITextField *pTxt2;
@property (weak, nonatomic) IBOutlet UITextField *cTxt;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBackBtn;

@property (nonatomic, assign) int payType;
@property (nonatomic, assign) NSInteger pageValue;

@property (nonatomic, strong) NSMutableArray *waittingCarsArr;
@property (nonatomic, strong) NSMutableDictionary *beginningCarsDic;
@property (nonatomic, strong) NSMutableArray *finishedCarsArr;

//－－－多个储值卡
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,  strong) NSString *sv_relation_id;
@end


@protocol PayStyleViewDelegate <NSObject>
@optional
- (void)closePopVieww:(PayStyleViewController *)payStyleViewController;
@end