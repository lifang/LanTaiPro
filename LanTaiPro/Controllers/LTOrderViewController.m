//
//  LTOrderViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTOrderViewController.h"

@interface LTOrderViewController ()

@end

@implementation LTOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadData:(NSMutableArray *)array type:(NSInteger)type
{
    self.orderArray = array;
    self.classifyType = type;
}
#pragma mark - property



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userBackground"]];
    
    float totalPrice = 0;
    if (self.classifyType==0 || self.classifyType==1) {
        for (ProductAndServiceModel *psModel in self.orderArray) {
            totalPrice += [psModel.p_price floatValue];
        }
    }else {
        for (CardModel *cModel in self.orderArray) {
            totalPrice += [cModel.c_price floatValue];
        }
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",totalPrice];
    
    [self.orderTable reloadData];
    
    //注册增减商品的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPrice:) name:@"Order_view_refresh_price" object:nil];
}

-(void)refreshPrice:(NSNotification *)notification
{
    NSDictionary *aDic = [notification object];
    
    float price = [[aDic objectForKey:@"price"]floatValue];
    
    NSString *text = [self.totalPriceLabel.text substringFromIndex:3];
    float totalPrice = [text floatValue];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",price+totalPrice];
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
    return self.orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"productOrderCell";
    id object = self.orderArray[indexPath.row];
    
    ProductOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ProductOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier object:object type:self.classifyType];
    }
    cell.idxPath = indexPath;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
#pragma mark - button点击事件
-(IBAction)orderCancelButtonPressed:(id)sender
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:kTitle message:@"确定取消选择?"];
    
    [alert setCancelButtonWithTitle:@"" block:nil];
    [alert addButtonWithTitle:@"" block:^{
        //此时LTOrderViewController里面的实例变量是映射到LTProductViewController上的，
        if (self.classifyType==0 || self.classifyType==1) {
            for (ProductAndServiceModel *psModel in self.orderArray){
                if (psModel.p_count>1) {
                    psModel.p_count=1;
                }
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(disMissOrderViewControl:)]) {
            [self.delegate disMissOrderViewControl:self];
        }
    }];
    [alert show];
}
///跳转到开单页面
-(IBAction)orderToConfirmButtonPressed:(id)sender
{
    NSMutableArray *orderArray = [[NSMutableArray alloc]init];
    if (self.classifyType==0 || self.classifyType==1) {
        for (ProductAndServiceModel *psModel in self.orderArray){
            
            OrderProductModel *product = [[OrderProductModel alloc]init];
            product.productId = psModel.p_id;
            product.price = psModel.p_price;
            product.name = psModel.p_name;
            product.number = psModel.p_count;
            product.validNumber = psModel.p_count;
            product.types = psModel.p_types;
            
            [orderArray addObject:product];
        }
    }else {
        for (CardModel *cardModel in self.orderArray) {
            OrderProductModel *product = [[OrderProductModel alloc]init];
            product.productId = cardModel.c_id;
            product.price = cardModel.c_price;
            product.name = cardModel.c_name;
            product.number = 1;
            product.validNumber = 1;
            
            if ([cardModel.c_type intValue]==1) {//储值卡
                product.types=@"4";
            }else if ([cardModel.c_type intValue]==0){//打折卡
                product.types=@"2";
            }else if ([cardModel.c_type intValue]==2){//套餐卡
                product.types=@"3";
            }
            product.c_isNew = @"1";
            
            [orderArray addObject:product];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(disMissOrderViewControl:withArray:)]) {
        [self.delegate disMissOrderViewControl:self withArray:orderArray];
    }
}
@end
