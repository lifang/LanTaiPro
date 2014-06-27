//
//  LTSettingViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-19.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTSettingViewController.h"
#import "BlockTextPromptAlertView.h"
#import "SettingCell.h"

@implementation LTSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - 退出按钮
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userBackground"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"settingCell";
    SettingCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:14];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    NSString *imageName = [NSString stringWithFormat:@"set%ld",(long)indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    NSInteger fileSize = [[SDImageCache sharedImageCache] getSize];
    CGFloat size = (CGFloat)fileSize/1024;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *syncTime = [defaults objectForKey:@"syncTime"];
    
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"数据库设置";
            cell.infoLabel.text = [LTDataShare sharedService].user.kHost;
            break;
        case 1:
            cell.textLabel.text = @"数据同步";
            if (syncTime != nil) {
                cell.infoLabel.text = [NSString stringWithFormat:@"上次同步时间:%@",syncTime];
            }else {
                cell.infoLabel.text = @"未同步过";
            }
            
            break;
        case 2:
            cell.infoLabel.text =  [NSString stringWithFormat:@"%.fM",size];
            cell.textLabel.text = @"清理缓存";
            break;
        case 3:
            cell.textLabel.text = @"预约功能";
            break;
        case 4:
            cell.textLabel.text = @"评价打分";
            break;
            
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        UITextField *textField;
        BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"数据库设置" message:nil textField:&textField block:^(BlockTextPromptAlertView *alert){
            [alert.textField resignFirstResponder];
            return YES;
        }];
        [alert setCancelButtonWithTitle:@"" block:nil];
        [alert addButtonWithTitle:@"" block:^{
            [LTDataShare sharedService].hostString = [NSString stringWithFormat:@"%@",textField.text];
        
            [LTDataShare sharedService].user.kHost = [NSString stringWithFormat:@"%@",textField.text];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        }];
        [alert show];
    }else if (indexPath.row==1){
        LTDB *db = [[LTDB alloc]init];
        NSArray *array = [db getLocalOrderInfo];
        
        if (array.count == 0) {
            [Utility errorAlert:@"本地暂无数据" dismiss:NO];
        }else {
            if (self.appDel.isReachable==NO) {
                [Utility errorAlert:@"请检查网络" dismiss:YES];
            }else {
                NSMutableArray *tempArray = [[NSMutableArray alloc]init];
                for (OrderModel *model in array) {
                    NSDictionary *dic = nil;
                    if ([model.order_status intValue] == 2) {
                        dic = [NSDictionary dictionaryWithObjectsAndKeys:model.order_id,@"order_id",model.reason,@"reason",model.request,@"request",model.order_status,@"status",nil];
                    }else if ([model.order_status intValue] == 0){
                        dic = [NSDictionary dictionaryWithObjectsAndKeys:model.order_id,@"order_id",model.order_status,@"status",nil];
                    }else {
                        dic = [OrderModel dictionaryFromModel:model];
                    }
                    [tempArray addObject:dic];
                }
                
                NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
                [dicc setObject:tempArray forKey:@"order"];
                if ([NSJSONSerialization isValidJSONObject:dicc]) {
                    NSError *error;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicc options:NSJSONWritingPrettyPrinted error:&error];
                    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    DLog(@"json data:%@",json);
                    if (json)
                    {
                        NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kAppointmentInfo];
                        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
                        [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
                        [params setObject:json forKey:@"syncInfo"];
                        
                        [MBProgressHUD showHUDAddedTo:self.appDel.window animated:YES];
                        [LTInterfaceBase request:params requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
                                
                                NSString *nowTime = [Utility getNowDateFromatAnDate];
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                [defaults setObject:nowTime forKey:@"syncTime"];
                                [defaults synchronize];
                                
                                [self.myTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                [Utility errorAlert:@"本地数据同步成功" dismiss:YES];
                            });
                        }errorBlock:^(NSString *notice){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
                                [Utility errorAlert:notice dismiss:YES];
                            });
                        }];
                    }
                }
            }
        }
    }else if (indexPath.row==2){
        NSInteger fileSize = [[SDImageCache sharedImageCache] getSize];
        CGFloat size = (CGFloat)fileSize/1024;
        if (size <=0) {
            [Utility errorAlert:@"本地无缓存数据" dismiss:YES];
        }else {
            [[SDImageCache sharedImageCache] clearCacheCompletion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.myTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [Utility errorAlert:@"缓存清理完成" dismiss:YES];
                });
                
            }];
        }
    }else if (indexPath.row==3){
        
    }else if (indexPath.row==4){
        
    }
    
}
#pragma mark - 退出
-(IBAction)cancelPressed:(id)sender
{
    [self.delegate dismissSettingViewControl:self];
}
@end
