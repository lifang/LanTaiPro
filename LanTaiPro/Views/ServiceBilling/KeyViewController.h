//
//  KeyViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-17.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 新买的储值卡  设置密码
 * by－－－邱成西
 */

@protocol KeyViewControllerDelegate;

@interface KeyViewController : UIViewController<UITextFieldDelegate>

@property (assign, nonatomic) id<KeyViewControllerDelegate>delegate;
//密码
@property (strong, nonatomic) NSString *passWord;

@property (nonatomic, weak) IBOutlet UIView *subview;
@property (nonatomic, weak) IBOutlet UITextField *txtField;

@property (nonatomic, weak) IBOutlet UIButton *sureBtn;
@property (nonatomic, weak) IBOutlet UIButton *btnReset;
@property (nonatomic, weak) IBOutlet UIButton *btn;
@property (nonatomic, assign) BOOL isSuccess;

@end


@protocol KeyViewControllerDelegate <NSObject>
@optional
- (void)closePopView:(KeyViewController *)keyView;
@end