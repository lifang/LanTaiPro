//
//  LTStationViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTStationViewController.h"
#define SELETED 100
#define UNSELETED 1000

@interface LTStationViewController ()

@end

@implementation LTStationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.fastToOrderTable.backgroundColor = [UIColor clearColor];
    self.staffTable.backgroundColor = [UIColor clearColor];
    self.orderTable.backgroundColor = [UIColor clearColor];
    self.orderInfoView.frame = CGRectMake(-1024, 45, 588, 1003);
    self.leftViewCover.frame = CGRectMake(-1024, 45, 100, 1003);
    DLog(@"22");
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    CGFloat cellHeiht = 44;
    if ([tableView isEqual:self.constructionTable]) {
        cellHeiht = 79;
    }
    return cellHeiht;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if ([tableView isEqual:self.fastToOrderTable]) {
        NSString *identifier = @"fastToOrderCell";
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = @"洗车服务";
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:17];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [tableView setSeparatorColor:[UIColor clearColor]];
        return cell;
       }
    if ([tableView isEqual:self.constructionTable]) {
        NSString *identifier = @"carCell";
        carCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[carCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [tableView setSeparatorColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.checkOrderBtn addTarget:self action:@selector(checkOrder:) forControlEvents:UIControlEventTouchUpInside];
        return  cell;
    }
    if ([tableView isEqual:self.staffTable]) {
        NSString *identifier = @"staffCell";
        StaffsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[StaffsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell.personBtn1 addTarget:self action:@selector(tapStaffTableBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.personBtn2 addTarget:self action:@selector(tapStaffTableBtn:) forControlEvents:UIControlEventTouchUpInside];
        [tableView setSeparatorColor:[UIColor clearColor]];
        return cell;
    }
    if ([tableView isEqual:self.orderTable]) {
        NSString *identifier = @"orderCell";
        OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
             cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
       
        [tableView setSeparatorColor:[UIColor clearColor]];
        return cell;
    }
    else
    {
        return nil;
    }
}

//选择技师
-(void)tapStaffTableBtn:(UIButton *)sender
{
    NSString *tagStr = [NSString stringWithFormat:@"%d",sender.tag];
    if (tagStr.length == 4) {
        [sender setBackgroundImage:[UIImage imageNamed:@"station-activePerson"] forState:UIControlStateNormal];
        NSInteger tagInt = sender.tag;
        sender.tag = tagInt - UNSELETED +SELETED;
        
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"station-person"] forState:UIControlStateNormal];
        NSInteger tagInt = sender.tag;
        sender.tag = tagInt - SELETED +UNSELETED;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}
//点击正在施工中的按钮，查看订单详情
-(void)checkOrder:(UIButton *)sender
{
    self.orderInfoView.frame = CGRectMake(100, 45, 588, 1003);
    self.leftViewCover.frame = CGRectMake(5, 45, 100, 1003);
}
- (void)deselect
{
    [self.fastToOrderTable deselectRowAtIndexPath:[self.fastToOrderTable indexPathForSelectedRow] animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapLeftViewCover:(UIControl *)sender {
    self.orderInfoView.frame = CGRectMake(-1024, 45, 588, 1003);
    self.leftViewCover.frame = CGRectMake(-1024, 45, 100, 1003);
}
@end
