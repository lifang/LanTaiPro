//
//  LTSettingViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-19.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTSettingViewController.h"

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
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"数据库设置";
            cell.infoLabel.text = [LTDataShare sharedService].user.kHost;
            break;
        case 1:
            cell.textLabel.text = @"数据同步";
            cell.infoLabel.text = @"上次同步时间:2014-02-11";
            break;
        case 2:
            cell.infoLabel.text =  [NSString stringWithFormat:@"%.fM",size];
            cell.textLabel.text = @"清理缓存";
            break;
        case 3:
            cell.textLabel.text = @"预约功能";
            break;
        case 4:
            cell.textLabel.text = @"数据库设置评价打分";
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
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            [[SDImageCache sharedImageCache]clearMemory];
            [[SDImageCache sharedImageCache]clearDisk];
            break;
        case 3:
            
            break;
        case 4:
            
            break;
            
        default:
            break;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - 退出
-(IBAction)cancelPressed:(id)sender
{
    [self.delegate dismissSettingViewControl:self];
}
@end
