//
//  LTLogInViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-13.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 登录页面
 * 功能－－登录：账号，密码，数据库设置
 * by－－－邱成西
 */

@interface LTLogInViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) AppDelegate *appDel;
///填写登录信息view
@property (nonatomic, weak) IBOutlet UIView *LoginView;
///用户名称
@property (nonatomic, weak) IBOutlet UIView *nameView;
@property (nonatomic, weak) IBOutlet UITextField *nameText;
///用户密码
@property (nonatomic, weak) IBOutlet UIView *passWordView;
@property (nonatomic, weak) IBOutlet UITextField *passWordText;
///登录按钮
@property (nonatomic, weak) IBOutlet UIButton *logButton;
///数据库设置按钮   
@property (nonatomic, weak) IBOutlet UIButton *dataButton;

///info
@property (nonatomic, weak) IBOutlet UILabel *infoLabel1;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel2;
@end
