//
//  LTLogInViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-13.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTLogInViewController.h"
#import "BlockTextPromptAlertView.h"
#import "UserModel.h"

#import "CarModel.h"

@interface LTLogInViewController ()

@end

@implementation LTLogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 初始化

-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}

#pragma mark - 车模型
-(void)getCarModelData
{
    NSDictionary *aDic = [Utility initWithJSONFile:@"carInfo"];
    CarModel *carModel = [[CarModel alloc]init];
    [carModel mts_setValuesForKeysWithDictionary:aDic];
    [LTDataShare sharedService].carModel = carModel;
    
    LTDB *local = [[LTDB alloc]init];
    [local saveCarModelToLocal:carModel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //界面
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-background.jpg"]];
    self.LoginView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginView_background"]];
    
    self.nameView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-name-normal"]];
    self.passWordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-password-normal"]];
    [LTDataShare sharedService].hostString = @"http:114.215.208.110:3001";
     //判断有无登录
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSString *userId = [defaults objectForKey:@"userId"];
     NSString *storeId = [defaults objectForKey:@"storeId"];
    if (userId!=nil && storeId!=nil) {
        //本地数据库获取用户信息
        LTDB *localDb = [[LTDB alloc]init];
        [localDb getLocalUserDataWithUserId:userId storeId:storeId completeBlock:^(NSArray *array) {
            UserModel *user = (UserModel *)[array firstObject];
            [LTDataShare sharedService].user = user;
            [LTDataShare sharedService].hostString = user.kHost;
            dispatch_async(dispatch_get_main_queue(), ^{
                //跳转首页
                _LoginView.hidden = YES;
                _infoLabel1.hidden = NO;
                _infoLabel2.hidden= NO;
                [self performSelector:@selector(showMainView) withObject:nil afterDelay:0];
            });
        }];
    }else {
        _LoginView.hidden = NO;
        _infoLabel1.hidden = YES;
        _infoLabel2.hidden= YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 数据库设置
- (IBAction)dataButtonPressed:(id)sender
{
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"数据库设置" message:nil textField:&textField block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    [alert setCancelButtonWithTitle:@"" block:nil];
    [alert addButtonWithTitle:@"" block:^{
        [LTDataShare sharedService].hostString = [NSString stringWithFormat:@"%@",textField.text];
    }];
    [alert show];
}
#pragma mark - 登录
- (BOOL)checkForm{
    NSString *passport = [[NSString alloc] initWithString:_nameText.text?:@""];
    NSString *password = [[NSString alloc] initWithString:_passWordText.text?:@""];
    NSString *msgStr = @"";
    if (passport.length == 0){
        msgStr = @"请输入用户名";
    }else if (password.length == 0){
        msgStr = @"请输入密码";
    }
    
    if (msgStr.length > 0){
        [Utility errorAlert:msgStr dismiss:YES];
        return FALSE;
    }
    return TRUE;
}

- (IBAction)logButtonPressed:(id)sender
{
    [self.nameText resignFirstResponder];
    [self.passWordText resignFirstResponder];
    
    if ([self checkForm]) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].hostString,kLogIn];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:_nameText.text forKey:@"user_name"];
        [params setObject:_passWordText.text forKey:@"user_password"];
        
        if (self.appDel.isReachable==NO) {
            [Utility errorAlert:@"请检查网络" dismiss:NO];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [LTInterfaceBase request:params requestUrl:urlString method:@"POST" completeBlock:^(NSDictionary *dictionary){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    NSDictionary *aDic = [dictionary objectForKey:@"user_info"];
                    UserModel *user = [UserModel userFromDictionary:aDic];
                    user.kHost = [NSString stringWithFormat:@"%@",[LTDataShare sharedService].hostString];
                    
                    //保存用户登录信息
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:user.user_id forKey:@"userId"];
                    [defaults setObject:user.store_id forKey:@"storeId"];
                    [defaults synchronize];
                    
                    //保存用户信息至本地数据库
                    LTDB *localDb = [[LTDB alloc]init];
                    [localDb saveUserDataToLocal:user];
                    
                    [LTDataShare sharedService].user = user;
                    
                    //车模型
                    NSDictionary *carDic = [dictionary objectForKey:@"carInfo"];
                    CarModel *carModel = [[CarModel alloc]init];
                    [carModel mts_setValuesForKeysWithDictionary:carDic];
                    [LTDataShare sharedService].carModel = carModel;
                    
                    LTDB *local = [[LTDB alloc]init];
                    [local saveCarModelToLocal:carModel];
                    
                    
                    _LoginView.hidden = YES;
                    _infoLabel1.hidden = NO;
                    _infoLabel2.hidden= NO;
                    [self performSelector:@selector(showMainView) withObject:nil afterDelay:3];
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
#pragma mark - textField代理
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_nameText]) {
        self.nameView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-name-active"]];
        self.passWordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-password-normal"]];
    }else {
        self.nameView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-name-normal"]];
        self.passWordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-password-active"]];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_nameText]) {
        self.nameView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-name-normal"]];
    }else {
        self.passWordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-password-normal"]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_nameText]) {
        [_nameText resignFirstResponder];
        [_passWordText becomeFirstResponder];
    }else {
        [_passWordText resignFirstResponder];
    }
    
    return YES;
}

-(void)showMainView {
    [[AppDelegate shareIntance] showRootViewController];
}
@end
