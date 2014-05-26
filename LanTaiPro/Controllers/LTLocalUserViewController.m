//
//  LTLocalUserViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-16.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTLocalUserViewController.h"

#import "BlockLogInAlertView.h"


#define columns 4
#define rows 4
#define itemsPerPage 16
#define space 24
#define itemWith 82
#define unValidIndex  -1
#define threshold 30

@implementation LTLocalUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - property
-(NSMutableArray *)itemsArray
{
    if (!_itemsArray) {
        _itemsArray = [[NSMutableArray alloc]initWithCapacity:itemsPerPage];
    }
    return _itemsArray;
}

-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}
-(NSMutableArray *)userArray
{
    if (!_userArray) {
        _userArray = [[NSMutableArray alloc]initWithCapacity:itemsPerPage];
    }
    return _userArray;
}
#pragma mark - 获取本地数据
- (void)getLocalUserInfo {
    LTDB *localDb = [[LTDB alloc]init];
    [localDb getLocalUserDataWithUserId:nil storeId:[LTDataShare sharedService].user.store_id completeBlock:^(NSArray *array) {
        self.userArray = [NSMutableArray arrayWithArray:array];
        [self.userArray addObject:@"Add"];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i=0; i<self.userArray.count; i++) {
                CGRect frame = CGRectMake(space, space, itemWith, itemWith);
                int row = i / columns;
                int col = i % columns;
                int curpage = i / itemsPerPage;
                frame.origin.x = frame.origin.x + frame.size.width * col + space * col + self.scrollview.frame.size.width * curpage;
                frame.origin.y = frame.origin.y + frame.size.height * row + space * row;
                
                UserItem *item;
                if (i==self.userArray.count-1) {
                    item = [[UserItem alloc] initWithUser:nil atIndex:i editable:YES];
                }else {
                    UserModel *tempUser = (UserModel *)array[i];
                    item = [[UserItem alloc] initWithUser:tempUser atIndex:i editable:YES];
                }
                item.delegate = self;
                item.frame = frame;
                [self.scrollview addSubview:item];
                [self.itemsArray addObject:item];
                item = nil;
            }
        });
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userBackground"]];
    
    self.isEditing = NO;
    [self getLocalUserInfo];

    self.singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.singletap setNumberOfTapsRequired:1];
    self.singletap.delegate = self;
    [self.scrollview addGestureRecognizer:self.singletap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加新的帐号

- (void)Addbutton {
    UITextField *textField;
    UITextField *textField2;
    BlockLogInAlertView *alert = [BlockLogInAlertView promptWithTitle:@"帐号设置" message:nil nameTextField:&textField pwdTextField:&textField2 block:^(BlockLogInAlertView * alert) {
        [alert.nameTextField resignFirstResponder];
        [alert.passWordTextField resignFirstResponder];
        return YES;
    }];
    [alert setCancelButtonWithTitle:@"" block:nil];
    [alert addButtonWithTitle:@"" block:^{
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kLogIn];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:textField.text forKey:@"user_name"];
        [params setObject:textField2.text forKey:@"user_password"];
        
        if (self.appDel.isReachable==NO) {
            [Utility errorAlert:@"请检查网络"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [LTInterfaceBase request:params requestUrl:urlString method:@"POST" completeBlock:^(NSDictionary *dictionary){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    NSDictionary *aDic = [dictionary objectForKey:@"staff"];
                    UserModel *user = [UserModel userFromDictionary:aDic];
                    user.kHost = [NSString stringWithFormat:@"%@",[LTDataShare sharedService].user.kHost];
                    
                    if ([[LTDataShare sharedService].user.user_id intValue] == [user.user_id intValue]){
                        DLog(@"相同用户,不做操作");
                    }else {
                        //判断本地有没有
                        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.userArray];
                        [tempArray removeLastObject];
                        NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"user_id", user.user_id];
                        NSMutableArray  *filteredArray = [NSMutableArray arrayWithArray:[tempArray filteredArrayUsingPredicate:predicateString]];
                        if (filteredArray.count>0) {
                            DLog(@"数据库已存储用户信息，直接切换");
                        }else {
                            //保存用户信息至本地数据库
                            LTDB *localDb = [[LTDB alloc]init];
                            [localDb saveUserDataToLocal:user];
                        }
                        //保存用户登录信息
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:user.user_id forKey:@"userId"];
                        [defaults setObject:user.store_id forKey:@"storeId"];
                        [defaults synchronize];
                        
                        [LTDataShare sharedService].user = user;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.page = 1;
                            [self.delegate disMissViewControl:self];
                        });
                    }
                });
                
            }errorBlock:^(NSString *notice){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [Utility errorAlert:notice];
                });
            }];
            
        }
        
    }];
    [alert show];
}


#pragma mark - userItem代理
- (void) userItemDidClicked:(UserItem *) gridItem
{
    if (self.isEditing){
        
    }else {
        if (gridItem.index == self.itemsArray.count-1) {
            [self Addbutton];
        }else {
            UserModel *tempUser = (UserModel *)self.userArray[gridItem.index];
            if ([[LTDataShare sharedService].user.user_id intValue] == [tempUser.user_id intValue]){
                DLog(@"相同用户,不做操作");
            }else {
                //保存用户登录信息
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:tempUser.user_id forKey:@"userId"];
                [defaults setObject:tempUser.store_id forKey:@"storeId"];
                [defaults synchronize];
                
                [LTDataShare sharedService].user = tempUser;

                dispatch_async(dispatch_get_main_queue(), ^{
                    self.page = 1;
                    [self.delegate disMissViewControl:self];
                });
            }
        }
    }
}
- (void) userItemDidEnterEditingMode:(UserItem *) gridItem
{
    for (UserItem *item in self.itemsArray) {
        if (item.userModel) {
            [item enableEditing];
        }
    }
    self.isEditing = YES;
}
- (void) userItemDidDeleted:(UserItem *) gridItem atIndex:(NSInteger)index
{
    UserItem * item = (UserItem *)self.itemsArray[index];
    UserModel *user = item.userModel;
    
    //删除本地数据库数据
    LTDB *localDb = [[LTDB alloc]init];
    [localDb deleteLocalUser:user];
    
    if ([[LTDataShare sharedService].user.user_id intValue] == [user.user_id intValue]) {
        //删除的是当前用户
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"userId"];
        [defaults removeObjectForKey:@"storeId"];
        [defaults synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.page = 0;
            [self.delegate disMissViewControl:self];
        });
    }else {
        [self.itemsArray removeObjectAtIndex:index];
        [UIView animateWithDuration:0.2 animations:^{
            CGRect lastFrame = item.frame;
            CGRect curFrame;
            for (int i=index; i < [self.itemsArray count]; i++) {
                UserItem *temp = (UserItem *)self.itemsArray[i];
                curFrame = temp.frame;
                [temp setFrame:lastFrame];
                lastFrame = curFrame;
                [temp setIndex:i];
            }
        }];
        [item removeFromSuperview];
        item = nil;
    }
}

- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer
{
    if (self.isEditing) {
        for (UserItem *item in self.itemsArray) {
            [item disableEditing];
        }
    }
    self.isEditing = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(touch.view != self.scrollview){
        return NO;
    }else
        return YES;
}

#pragma mark - 取消
- (IBAction)cancelBtnPressed:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.page = 2;
        [self.delegate disMissViewControl:self];
    });
}

#pragma mark -  退出
- (IBAction)logout:(id)sender
{
    //删除的是当前用户
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userId"];
    [defaults removeObjectForKey:@"storeId"];
    [defaults synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.page = 0;
        [self.delegate disMissViewControl:self];
    });
}
@end
