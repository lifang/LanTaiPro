//
//  OrderViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-17.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "OrderViewController.h"
#import "ComplaintViewController.h"

#define InfoLabelTag 1540

@interface OrderViewController ()

@end

@implementation OrderViewController

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

-(SVSegmentedControl *)svSegBtn
{
    if (!_svSegBtn) {
        _svSegBtn = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不满意",@"一般", @"好",@"很好", nil]];
        [_svSegBtn addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        _svSegBtn.crossFadeLabelsOnDrag = YES;
        _svSegBtn.thumb.tintColor = [UIColor redColor];
        _svSegBtn.frame = CGRectMake(70, 900, 325, 40);
        _svSegBtn.backgroundImage = [UIImage imageNamed:@"pleased"];
        _svSegBtn.isCanSelected = YES;
        _svSegBtn.selectedIndex=3;
    }
    return _svSegBtn;
}

-(DrawSignView *)drawSignView
{
    if (!_drawSignView) {
        _drawSignView = [[DrawSignView alloc]initWithFrame:(CGRect){0,0,648,136}];
    }
    return _drawSignView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.drawSignView.frame = (CGRect){20,735,648,136};
    [self.view addSubview:self.drawSignView];
    [self.view addSubview:self.svSegBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 客户签名
-(IBAction)signSwitchSelected:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    if (switchBtn.isOn) {
        CGRect frame1 = self.svSegBtn.frame;
        CGRect frame2 = self.cancelPayBtn.frame;
        CGRect frame3 = self.confirmPayBtn.frame;
        frame1.origin.y = 900;
        frame2.origin.y = 900;
        frame3.origin.y = 900;
        
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.svSegBtn.frame = frame1;
            self.cancelPayBtn.frame = frame2;
            self.confirmPayBtn.frame = frame3;
        }completion:^(BOOL finished){
            if (finished) {
                [self.drawSignView.drawView clear];
                CGRect frame = self.drawSignView.frame;
                frame.origin.x = 20;
                
                [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [self.drawSignView setFrame:frame];
                }completion:^(BOOL finished){
                    [Utility shakeViewHorizontal:self.drawSignView];
                }];
            }
        }];
    }else {
        CGRect frame = self.drawSignView.frame;
        frame.origin.x = 688;
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.drawSignView setFrame:frame];
        }completion:^(BOOL finished){
            if (finished) {
                CGRect frame1 = self.svSegBtn.frame;
                CGRect frame2 = self.cancelPayBtn.frame;
                CGRect frame3 = self.confirmPayBtn.frame;
                frame1.origin.y = 735;
                frame2.origin.y = 735;
                frame3.origin.y = 735;
                
                [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                    self.svSegBtn.frame = frame1;
                    self.cancelPayBtn.frame = frame2;
                    self.confirmPayBtn.frame = frame3;
                }completion:^(BOOL finished){
                    
                }];
            }
        }];
    }
}

#pragma mark - table代理
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.payOrderArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
#pragma mark - 满意度
- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
	if (segmentedControl.selectedIndex == 0) {
//        if (![[self.customer objectForKey:@"oplease"]isKindOfClass:[NSNull class]] && [self.customer objectForKey:@"oplease"]!=nil) {
//            if (![[self.customer objectForKey:@"oplease"]intValue]==0) {
//                ComplaintViewController *complaint = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
//                complaint.info = [NSMutableDictionary dictionaryWithDictionary:self.customer];
//                [self.navigationController pushViewController:complaint animated:YES];
//            }
//        }else {
//            ComplaintViewController *complaint = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
//            complaint.info = [NSMutableDictionary dictionaryWithDictionary:self.customer];
//            [self.navigationController pushViewController:complaint animated:YES];
//        }
    }
}

-(IBAction)confirmOrderButtonPressed:(id)sender
{
    self.drawSignView.clearbtn.hidden = YES;
    self.drawSignView.backBtn.hidden = YES;
    
    UIGraphicsBeginImageContext(self.drawSignView.layer.frame.size);
    
    [self.drawSignView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}
@end
