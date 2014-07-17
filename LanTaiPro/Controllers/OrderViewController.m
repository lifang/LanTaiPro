//
//  OrderViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-17.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "OrderViewController.h"
#import "ComplaintViewController.h"

#import "UIViewController+MJPopupViewController.h"

#define OPEN 100
#define CLOSE 1000
#define InfoLabelTag 1540

///满意度的临时变量
static NSInteger tempSelectedIndex = -1;

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
-(LTMainViewController *)mainViewControl
{
    if (!_mainViewControl) {
        _mainViewControl = (LTMainViewController *)self.parentViewController;
    }
    return _mainViewControl;
}
-(SVSegmentedControl *)svSegBtn
{
    if (!_svSegBtn) {
        _svSegBtn = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不满意",@"一般", @"好",@"很好", nil]];
        [_svSegBtn addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        _svSegBtn.crossFadeLabelsOnDrag = YES;
        _svSegBtn.thumb.tintColor = [UIColor redColor];
        _svSegBtn.frame = CGRectMake(70, 950, 325, 40);
        _svSegBtn.backgroundImage = [UIImage imageNamed:@"pleased"];
        _svSegBtn.isCanSelected = YES;
        _svSegBtn.selectedIndex=3;
        tempSelectedIndex = 3;
    }
    return _svSegBtn;
}

-(DrawSignView *)drawSignView
{
    if (!_drawSignView) {
        _drawSignView = [[DrawSignView alloc]initWithFrame:(CGRect){0,0,790,136}];
    }
    return _drawSignView;
}
//-(NSMutableArray *)payOrderArray
//{
//    if (!_payOrderArray) {
//        _payOrderArray = [[NSMutableArray alloc]init];
//    }
//    return _payOrderArray;
//}
-(NSMutableArray *)buyOrderArray
{
    if (!_buyOrderArray) {
        _buyOrderArray = [[NSMutableArray alloc]init];
    }
    return _buyOrderArray;
}
-(NSMutableArray *)preferentialArray
{
    if (!_preferentialArray) {
        _preferentialArray = [[NSMutableArray alloc]init];
    }
    return _preferentialArray;
}
-(OrderInfoObject *)orderInfoObj
{
    if (!_orderInfoObj) {
        _orderInfoObj = [[OrderInfoObject alloc]init];
    }
    return _orderInfoObj;
}
-(NSMutableArray *)save_cardArray
{
    if (!_save_cardArray) {
        _save_cardArray = [[NSMutableArray alloc]init];
    }
    return _save_cardArray;
}
-(void)loadData:(NSDictionary *)aDic
{
    self.payDictionary = [NSMutableDictionary dictionaryWithDictionary:aDic];
    
}

///0等待施工 1正在施工 2等待付款  3已付款未施工 4已付款正在施工
-(NSString *)orderStatus:(int)status
{
    NSString *statusString = @"";
    if (status == 0) {//取消订单，付款
        statusString = @"等待施工";
    }else if (status == 1){//取消订单，付款，结束施工
        statusString = @"施工中";
    }else if (status == 2){//付款--有服务
        statusString = @"等待付款";
    }else if (status == 3){//退单
        statusString = @"等待施工";
    }else if (status == 4){//退单，结束施工
        statusString = @"施工中";
    }else if (status == 5) {//付款--无服务
        statusString = @"等待付款";
    }
    return statusString;
}

-(void)layoutOrderView
{
    self.nameLab.text = self.orderInfoObj.name;
    self.phoneLab.text = self.orderInfoObj.phone;
    self.codeLab.text = self.orderInfoObj.code;
    self.carNumLab.text = self.orderInfoObj.carNum;
    self.timeLab.text = self.orderInfoObj.creatTime;
    self.statusLab.text = [self orderStatus:[self.orderInfoObj.status intValue]];
    self.prosLab.text = self.orderInfoObj.proNames;
    
    self.total_count = [self.orderInfoObj.totalPrice floatValue];
    self.totalPriceLab.text = [NSString stringWithFormat:@"合计:%.2f(元)",self.total_count];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"orderViewBackground"]];
    
    self.drawSignView.frame = (CGRect){20,790,648,136};
    [self.view addSubview:self.drawSignView];
    [self.view addSubview:self.svSegBtn];
    
    [Utility setLogoImageWithTable:self.orderTable];
    
    NSDictionary *orderInfoDic = [self.payDictionary objectForKey:@"customer"];
    [self.orderInfoObj mts_setValuesForKeysWithDictionary:orderInfoDic];
    [self layoutOrderView];
    
    self.save_cardArray = [NSMutableArray arrayWithArray:[self.payDictionary objectForKey:@"save_cards"]];
    
    [DataService sharedService].first = YES;
    [DataService sharedService].price_id = [[NSMutableDictionary alloc]init];
    [DataService sharedService].number_id = [[NSMutableDictionary alloc]init];
    [DataService sharedService].saleArray = [[NSMutableArray alloc]init];
    [DataService sharedService].row_id_numArray =[[NSMutableArray alloc]init];
    [DataService sharedService].svcardArray =[[NSMutableArray alloc]init];
    [DataService sharedService].row_id_countArray =[[NSMutableArray alloc]init];
    
    self.save_cardArray = [NSMutableArray arrayWithArray:[self.payDictionary objectForKey:@"save_cards"]];
    
    [self.buyOrderArray addObjectsFromArray:[self.payDictionary objectForKey:@"products"]];
    [self.preferentialArray addObjectsFromArray:[self.payDictionary objectForKey:@"sales"]];
    [self.preferentialArray addObjectsFromArray:[self.payDictionary objectForKey:@"discount_cards"]];
    [self.preferentialArray addObjectsFromArray:[self.payDictionary objectForKey:@"p_cards"]];
    /*
     [self.payOrderArray addObjectsFromArray:[self.payDictionary objectForKey:@"products"]];
     [self.payOrderArray addObjectsFromArray:[self.payDictionary objectForKey:@"sales"]];
     [self.payOrderArray addObjectsFromArray:[self.payDictionary objectForKey:@"discount_cards"]];
     [self.payOrderArray addObjectsFromArray:[self.payDictionary objectForKey:@"p_cards"]];
     */
    [self.orderTable reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //更新总价
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTotal:) name:@"update_total" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saleReload:) name:@"saleReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(svcardReload:) name:@"svcardReload" object:nil];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"update_total" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"saleReload" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"svcardReload" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadPackage" object:nil];
    
    [DataService sharedService].first = NO;
    [DataService sharedService].price_id = nil;
    [DataService sharedService].number_id = nil;
    [DataService sharedService].saleArray = nil;
    [DataService sharedService].row_id_numArray = nil;
    [DataService sharedService].svcardArray = nil;
    [DataService sharedService].row_id_countArray = nil;
}
#pragma mark - 总价更新
- (void)updateTotal:(NSNotification *)notification{
    NSDictionary *dic = [notification object];
    //dic套餐卡剩余
    CGFloat f = 0;
    if (self.total_count == 0) {
        f = self.total_count_temp + [[dic objectForKey:@"object"] floatValue];
    }else {
        f = self.total_count + [[dic objectForKey:@"object"] floatValue];
    }
    
    if (f < 0) {
        self.total_count = 0.0;
        self.total_count_temp = f;
    }else {
        self.total_count = f;
        self.total_count_temp = f;
    }
    self.totalPriceLab.text = [NSString stringWithFormat:@"合计:%.2f(元)",self.total_count];
    NSIndexPath *idx = [dic objectForKey:@"idx"];
    [self.preferentialArray replaceObjectAtIndex:idx.row withObject:[dic objectForKey:@"prod"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.orderTable reloadData];
    });
}

#pragma mark -打折卡更新

- (void)svcardReload:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    
    NSString * product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];//服务／产品的id
    
    NSMutableArray *collection_index = [NSMutableArray array];//单个活动消费的产品index集合
    NSMutableArray *collection_id = [NSMutableArray array];//单个活动消费的产品id集合
    NSMutableArray *collection_number = [NSMutableArray array];//单个活动消费的产品number集合
    NSMutableArray *collection = [NSMutableArray array];//纪录位置
    
    NSMutableArray *p_arr = nil;
    NSMutableDictionary *p_dic=nil;
    
    CGFloat discount_x = 0;
    CGFloat discount_y = 0;
    
    NSArray *array = [[DataService sharedService].number_id allKeys];
    if ([array containsObject:product_id]) {
        discount_x = [[dic objectForKey:@"price"] floatValue];//服务／产品的  单价
        int num_count = 0;//放在单列里面此id产品消费次数
        int index_row = 0;
        if ([DataService sharedService].svcardArray.count >0) {
            for (int i=0; i<[DataService sharedService].svcardArray.count; i++) {
                NSMutableString *str = [[DataService sharedService].svcardArray objectAtIndex:i];
                str = [NSMutableString stringWithString:[str substringToIndex:str.length-1]];
                NSArray *arr = [str componentsSeparatedByString:@"_"];
                [collection_index addObject:[arr objectAtIndex:0]];
                [collection_id addObject:[arr objectAtIndex:1]];
                [collection_number addObject:[arr objectAtIndex:2]];
                
            }
        }
        //遍历 id的集合找到位置
        for (int i=0; i<collection_id.count; i++) {
            NSString *prod_id = [collection_id objectAtIndex:i];
            if ([product_id intValue] == [prod_id intValue]) {
                [collection addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        NSMutableArray *collection_temp = [NSMutableArray array];//纪录row_id_numArray里面要删除的元素
        
        if (collection.count>0) {
            for (int i=0; i<collection.count; i++) {
                int h = [[collection objectAtIndex:i]intValue];//位置
                //根据位置找到index
                index_row = [[collection_index objectAtIndex:h]intValue];
                //通过index找到的活动
                NSMutableDictionary *product_dic = [self.preferentialArray objectAtIndex:index_row];
                discount_y = [[product_dic objectForKey:@"show_price"]floatValue];
                //通过index找到cell
                NSIndexPath *idx = [NSIndexPath indexPathForRow:index_row inSection:0];
                PaySvcardCell *cell = (PaySvcardCell *)[self.orderTable cellForRowAtIndexPath:idx];
                
                p_arr = [product_dic objectForKey:@"products"];
                
                for (int k=0; k<p_arr.count; k++) {
                    p_dic = [[p_arr objectAtIndex:k] mutableCopy];
                    NSString * pro_id = [p_dic objectForKey:@"pid"];
                    if ([pro_id intValue] == [product_id intValue]){
                        //重置number_id数据
                        int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//剩余次数
                        
                        num_count = [[collection_number objectAtIndex:h]intValue];//放在单列里面此id产品消费次数
                        [[DataService sharedService].number_id removeObjectForKey:product_id];
                        [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];
                        
                        [p_dic setValue:@"0" forKey:@"selected"];
                        [p_arr replaceObjectAtIndex:k withObject:p_dic];
                        
                        CGFloat scard_discount = 1 -[[product_dic objectForKey:@"discount"]floatValue]/100;//折扣
                        CGFloat y =[[p_dic objectForKey:@"pprice"] floatValue];
                        
                        discount_y = discount_y +y *num_count *scard_discount;
                        //删除
                        [collection_temp addObject:[[DataService sharedService].svcardArray objectAtIndex:h]];
                        
                        UIButton *btn =(UIButton *)[cell viewWithTag:OPEN+k];
                        int tag = btn.tag;
                        btn.tag = tag - OPEN + CLOSE;
                        [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                        if (discount_y<0) {
                            cell.lblPrice.text = @"0.00";
                        }else {
                            cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y];
                        }
                        
                        [product_dic setObject:p_arr forKey:@"products"];
                        [product_dic setObject:[NSString stringWithFormat:@"%.2f",discount_y] forKey:@"show_price"];
                        
                        NSString *p = [NSString stringWithFormat:@"%.2f",y *num_count *scard_discount];
                        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:p,@"object",product_dic,@"prod",idx,@"idx",@"2",@"type", nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic1];
                        
                    }
                }
            }
        }
        if (collection_temp.count>0) {
            [[DataService sharedService].svcardArray removeObjectsInArray:collection_temp];
        }
    }
}

#pragma mark - 活动更新
- (void)saleReload:(NSNotification *)notification{
    NSDictionary *dic = [notification object];
    
    NSString * product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];//服务／产品的id
    
    NSMutableArray *collection_index = [NSMutableArray array];//单个活动消费的产品index集合
    NSMutableArray *collection_id = [NSMutableArray array];//单个活动消费的产品id集合
    NSMutableArray *collection_number = [NSMutableArray array];//单个活动消费的产品number集合
    NSMutableArray *collection = [NSMutableArray array];//纪录位置
    NSMutableArray *collection2 = [NSMutableArray array];//纪录位置
    
    NSMutableArray *p_arr = nil;
    NSMutableDictionary *p_dic=nil;
    
    CGFloat discount_x = 0;
    CGFloat discount_y = 0;
    
    NSArray *array = [[DataService sharedService].number_id allKeys];
    if ([array containsObject:product_id]) {
        discount_x = [[dic objectForKey:@"price"] floatValue];//服务／产品的  单价
        int num_count = 0;//放在单列里面此id产品消费次数
        int index_row = 0;
        int num = 0;//活动里面剩余次数
        if ([DataService sharedService].row_id_numArray.count >0) {
            for (int i=0; i<[DataService sharedService].row_id_numArray.count; i++) {
                NSMutableString *str = [[DataService sharedService].row_id_numArray objectAtIndex:i];
                str = [NSMutableString stringWithString:[str substringToIndex:str.length-1]];
                NSArray *arr = [str componentsSeparatedByString:@"_"];
                [collection_index addObject:[arr objectAtIndex:0]];
                [collection_id addObject:[arr objectAtIndex:1]];
                [collection_number addObject:[arr objectAtIndex:2]];
                
            }
        }
        //遍历 id的集合找到位置
        for (int i=0; i<collection_id.count; i++) {
            NSString *prod_id = [collection_id objectAtIndex:i];
            if ([product_id intValue] == [prod_id intValue]) {
                [collection addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        NSMutableArray *collection_temp = [NSMutableArray array];//纪录row_id_numArray里面要删除的元素
        NSMutableArray *sale_tempArray = [NSMutableArray array];//纪录活动里面需要删除的数据
        
        if (collection.count>0) {
            for (int i=0; i<collection.count; i++) {
                int h = [[collection objectAtIndex:i]intValue];//位置
                //根据位置找到index
                index_row = [[collection_index objectAtIndex:h]intValue];
                //通过index找到的活动
                NSMutableDictionary *product_dic = [self.preferentialArray objectAtIndex:index_row];
                
                discount_y = 0-[[product_dic objectForKey:@"show_price"]floatValue];//差价
                //通过index找到cell
                NSIndexPath *idx = [NSIndexPath indexPathForRow:index_row inSection:0];
                PaySvcardCell *cell = (PaySvcardCell *)[self.orderTable cellForRowAtIndexPath:idx];
                
                p_arr = [product_dic objectForKey:@"products"];//活动里面产品的集合
                
                for (int k=0; k<p_arr.count; k++) {
                    p_dic = [[p_arr objectAtIndex:k] mutableCopy];
                    NSString * pro_id = [p_dic objectForKey:@"product_id"];//活动包含的服务/产品id
                    num = [[p_dic objectForKey:@"prod_num"]intValue];//活动里面剩余次数
                    if ([pro_id intValue] == [product_id intValue]) {//id相同,找到服务,产品
                        //重置number_id数据
                        int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//剩余次数
                        
                        num_count = [[collection_number objectAtIndex:h]intValue];//放在单列里面此id产品消费次数
                        if ([DataService sharedService].saleArray.count>0) {
                            for (int i=0; i<[DataService sharedService].saleArray.count; i++) {
                                NSMutableString *str = [[DataService sharedService].saleArray objectAtIndex:i];
                                NSArray *arr = [str componentsSeparatedByString:@"_"];
                                NSString *s_id = [arr objectAtIndex:0];//活动id
                                if ([s_id intValue] == [[product_dic objectForKey:@"sale_id"] intValue]) {
                                    [sale_tempArray addObject:[[DataService sharedService].saleArray objectAtIndex:i]];
                                }
                            }
                        }
                        
                        [[DataService sharedService].number_id removeObjectForKey:product_id];
                        [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];
                        
                        [p_dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"prod_num"];
                        [p_arr replaceObjectAtIndex:k withObject:p_dic];
                        //删除
                        [collection_temp addObject:[[DataService sharedService].row_id_numArray objectAtIndex:h]];
                    }else {
                        //遍历 id的集合找到位置
                        for (int m=0; m<collection_id.count; m++) {
                            NSString *prod_id = [collection_id objectAtIndex:m];
                            if ([prod_id intValue] == [pro_id intValue]) {
                                [collection2 addObject:[NSString stringWithFormat:@"%d",m]];
                            }
                        }
                        if (collection2.count>0) {
                            for (int j=0; j<collection2.count; j++) {
                                int d = [[collection2 objectAtIndex:j]intValue];
                                NSString *sale_index = [collection_index objectAtIndex:d];
                                if ([sale_index intValue] == index_row) {
                                    num_count = [[collection_number objectAtIndex:d]intValue];//放在单列里面此id产品消费次数
                                    
                                    if ([DataService sharedService].saleArray.count>0) {
                                        for (int i=0; i<[DataService sharedService].saleArray.count; i++) {
                                            NSMutableString *str = [[DataService sharedService].saleArray objectAtIndex:i];
                                            NSArray *arr = [str componentsSeparatedByString:@"_"];
                                            NSString *s_id = [arr objectAtIndex:0];//活动id
                                            if ([s_id intValue] == [[product_dic objectForKey:@"sale_id"] intValue]) {
                                                [sale_tempArray addObject:[[DataService sharedService].saleArray objectAtIndex:i]];
                                            }
                                        }
                                    }
                                    
                                    //重置number_id数据
                                    int count_num = [[[DataService sharedService].number_id objectForKey:pro_id]intValue];//剩余次数
                                    [[DataService sharedService].number_id removeObjectForKey:pro_id];
                                    [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:pro_id];
                                    
                                    [p_dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"prod_num"];
                                    [p_arr replaceObjectAtIndex:k withObject:p_dic];
                                    //删除
                                    [collection_temp addObject:[[DataService sharedService].row_id_numArray objectAtIndex:d]];
                                }
                            }
                        }
                    }
                }
                UIButton *btn =(UIButton *)[cell viewWithTag:OPEN];
                int tag = btn.tag;
                btn.tag = tag - OPEN + CLOSE;
                [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                
                CGFloat lbl_price = [cell.lblPrice.text floatValue];
                if ((lbl_price+discount_y) <0.0001f ) {
                    cell.lblPrice.text = @"0.00";
                }else {
                    cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y+lbl_price];
                }
                [product_dic setValue:@"0" forKey:@"selected"];
                [product_dic setObject:p_arr forKey:@"products"];
                //////////////////////////////////////////////////////////////////////////////
                [product_dic setObject:@"0" forKey:@"show_price"];
                
                NSString *p = [NSString stringWithFormat:@"%.2f",discount_y];
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:p,@"object",product_dic,@"prod",idx,@"idx",@"2",@"type", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic1];
            }
        }
        if (collection_temp.count>0) {
            [[DataService sharedService].row_id_numArray removeObjectsInArray:collection_temp];
        }
        if (sale_tempArray.count>0) {
            [[DataService sharedService].saleArray removeObjectsInArray:sale_tempArray];
        }
    }
}
#pragma mark - 满意度
- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl
{
    if (segmentedControl.selectedIndex == 0) {
        ComplaintViewController *complaintViewControl = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
        
        complaintViewControl.delegate = self;
        
        NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:self.orderInfoObj.proNames,ComplaintProds,self.orderInfoObj.code,ComplaintCode,self.orderInfoObj.carNum,ComplaintCarNum,self.orderInfoObj.orderId,ComplaintOrderId, nil];
        [complaintViewControl setInfoDic:aDic];
        
        [self.mainViewControl addChildViewController:complaintViewControl];
        [complaintViewControl didMoveToParentViewController:self.mainViewControl];
        
        [self.mainViewControl presentPopupViewController:complaintViewControl animationType:MJPopupViewAnimationSlideBottomBottom width:80];
    }else {
        tempSelectedIndex = segmentedControl.selectedIndex;
    }
}
#pragma mark - 投诉页面代理
-(void)dismissComplaintViewControl:(ComplaintViewController *)complaintViewController
{
    __block ComplaintViewController *viewControl = complaintViewController;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop dismissBlock:^(BOOL isFinish){
        if (viewControl.success==NO) {//投诉失败返回上个满意度
            [self.svSegBtn moveThumbToIndex:tempSelectedIndex animate:YES];
        }else {//投诉成功，满意度不可再改变
            tempSelectedIndex = 0;
            self.svSegBtn.isCanSelected = NO;
        }
        
        [viewControl willMoveToParentViewController:nil];
        [viewControl removeFromParentViewController];
        viewControl = nil;
    }];
}
#pragma mark - 客户签名
-(IBAction)signSwitchSelected:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    if (switchBtn.isOn) {
        CGRect frame1 = self.svSegBtn.frame;
        CGRect frame2 = self.cancelPayBtn.frame;
        CGRect frame3 = self.confirmPayBtn.frame;
        frame1.origin.y = 950;
        frame2.origin.y = 950;
        frame3.origin.y = 950;
        
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
        frame.origin.x = 790;
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.drawSignView setFrame:frame];
        }completion:^(BOOL finished){
            if (finished) {
                CGRect frame1 = self.svSegBtn.frame;
                CGRect frame2 = self.cancelPayBtn.frame;
                CGRect frame3 = self.confirmPayBtn.frame;
                frame1.origin.y = 790;
                frame2.origin.y = 790;
                frame3.origin.y = 790;
                
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


- (UILabel *)returnlabel
{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1];
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:17];
    return label;
}

#pragma mark - table代理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc]initWithFrame:(CGRect){0,0,648,40}];
    
    UILabel *label1 = [self returnlabel];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
    CGRect frame =(CGRect){5,5,300,30};
    label1.frame = frame;
    [customView addSubview:label1];
    
    if (section==0) {
        label1.text = @"购买的的商品";
        
        UILabel *label2 = [self returnlabel];
        label2.frame =(CGRect){324,5,110,30};
        label2.text = @"单价(元)";
        [customView addSubview:label2];
        label2 = nil;
        
        UILabel *label3 = [self returnlabel];
        label3.frame =(CGRect){457,5,60 ,30};
        label3.text = @"数量";
        [customView addSubview:label3];
        label3 = nil;
        
        UILabel *label4 = [self returnlabel];
        label4.textAlignment = NSTextAlignmentRight;
        label4.frame =(CGRect){551,5,97,30};
        label4.text = @"总价(元)";
        [customView addSubview:label4];
        label4 = nil;
    }else {
        label1.text = @"可用优惠";
        
        UILabel *label2 = [self returnlabel];
        label2.frame =(CGRect){250, 5, 104, 30};
        label2.text = @"优惠金额(元)";
        [customView addSubview:label2];
        label2 = nil;
        
        UILabel *label3 = [self returnlabel];
        label3.textAlignment = NSTextAlignmentRight;
        label3.frame =(CGRect){354, 5, 250, 30};
        label3.text = @"可选服务、产品";
        [customView addSubview:label3];
        label3 = nil;
    }
    
    label1 = nil;

    [Utility setRoundcornerWithView:customView];
    return customView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.preferentialArray.count>0) {
        return 2;
    }else
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.buyOrderArray.count;
    }else
        return self.preferentialArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 30;
    }else {
        NSDictionary *product = self.preferentialArray[indexPath.row];
    if ([product objectForKey:@"products"]){
        int count = [[product objectForKey:@"products"] count];
        count = count == 0 ? 1 : count;
        return count * 30;
    }else
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSMutableDictionary *product = [self.buyOrderArray objectAtIndex:indexPath.row];
        int type = [[product objectForKey:@"type"]intValue];
        //第一次加载tableView
        if ([DataService sharedService].first==YES && (type==0||type==1)){
            [[DataService sharedService].price_id setObject:[product objectForKey:@"price"] forKey:[NSString stringWithFormat:@"%@",[product objectForKey:@"id"]]];
            [[DataService sharedService].number_id setObject:[product objectForKey:@"valid_num"] forKey:[NSString stringWithFormat:@"%@",[product objectForKey:@"id"]]];
        }
        
        static NSString *CellIdentifier = @"ServiceCell";
        PaySeriviceCell *cell = (PaySeriviceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PaySeriviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:0];
        }
        cell.lblName.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"name"]];
        cell.lblPrice.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"price"]];
        cell.lblCount.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"num"]];
        cell.lbltotal.text = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"price"] floatValue]*[[product objectForKey:@"valid_num"] intValue]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        NSMutableDictionary *product = [self.preferentialArray objectAtIndex:indexPath.row];
        if([product objectForKey:@"sale_id"]) {//活动
            NSString *CellIdentifier = [NSString stringWithFormat:@"sale_%d_%d", indexPath.section,indexPath.row];
            PaySvcardCell *cell = (PaySvcardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[PaySvcardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:0];
            }
            
            NSArray *subViews = [cell.contentView subviews];
            for (UIView *v in subViews) {
                if ([v isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)v;
                    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
                    if (tagStr.length == 3) {
                        int tag_x = btn.tag - OPEN;
                        if ([[product objectForKey:@"selected"]intValue] == 1) {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                            
                        }else {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                            btn.tag = tag_x + CLOSE;
                        }
                    }
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if([product objectForKey:@"customer_discount_id"]) {//打折卡
            NSString *CellIdentifier = [NSString stringWithFormat:@"discountcard_%d_%d", indexPath.section,indexPath.row];
            PaySvcardCell *cell = (PaySvcardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[PaySvcardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:1];
            }
            
            NSArray *subViews = [cell.contentView subviews];
            for (UIView *v in subViews) {
                if ([v isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)v;
                    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
                    if (tagStr.length == 3) {
                        int tag_x = btn.tag - OPEN;
                        NSDictionary *dic = [[product objectForKey:@"products"] objectAtIndex:tag_x];
                        if ([[dic objectForKey:@"selected"]intValue] == 1) {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                        }else {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                            btn.tag = tag_x + CLOSE;
                        }
                    }
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if([product objectForKey:@"customer_package_id"]) {//套餐卡
            NSString *CellIdentifier = [NSString stringWithFormat:@"PackageCardCell%d", [indexPath row]];
            PayPackagecardCell *cell = (PayPackagecardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            int p_status = [[product objectForKey:@"status"]integerValue];//判断正常下单还是套餐卡下单
            if (cell == nil) {
                cell = [[PayPackagecardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:p_status];
            }
            NSArray *subViews = [cell subviews];
            for (UIView *v in subViews) {
                if ([v isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)v;
                    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
                    if (tagStr.length == 3) {
                        int tag_x = btn.tag - OPEN;
                        NSDictionary *dic = [[product objectForKey:@"products"] objectAtIndex:tag_x];
                        if ([[dic objectForKey:@"selected"]intValue] == 1) {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                            
                            UILabel *lab_prod = (UILabel *)[cell viewWithTag:tag_x+OPEN+OPEN];
                            lab_prod.text = [NSString stringWithFormat:@"%@(%@)次",[dic objectForKey:@"proname"],[dic objectForKey:@"pro_left_count"]];
                            lab_prod.tag = tag_x+CLOSE+CLOSE;
                        }else {
                            [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                            btn.tag = tag_x + CLOSE;
                        }
                    }
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

#pragma mark - 优惠信息

- (NSString *)checkForm
{
    NSMutableString *prod_ids = [NSMutableString string];
    int x=0;
    for (NSDictionary *product in self.preferentialArray) {
        if([product objectForKey:@"sale_id"] && [[product objectForKey:@"selected"] intValue] == 1){
            //活动
            x += 1;
            if ([DataService sharedService].saleArray.count>0) {
                for (int i=0; i<[DataService sharedService].saleArray.count; i++) {
                    NSMutableString *str = [[DataService sharedService].saleArray objectAtIndex:i];
                    NSArray *arr = [str componentsSeparatedByString:@"_"];
                    NSString *s_id = [arr objectAtIndex:0];//活动id
                    if ([s_id intValue] == [[product objectForKey:@"sale_id"] intValue]) {
                        [prod_ids appendFormat:@"1_%@,",str];
                    }
                }
            }
        }else if([product objectForKey:@"customer_discount_id"]){//打折卡
            NSMutableString *c_str = [NSMutableString string];
            for (NSDictionary *pro in [product objectForKey:@"products"]) {
                if([[pro objectForKey:@"selected"] intValue]==1) {
                    for (int i=0; i<[DataService sharedService].svcardArray.count; i++) {
                        NSMutableString *str = [[DataService sharedService].svcardArray objectAtIndex:i];
                        NSArray *arr = [str componentsSeparatedByString:@"_"];
                        NSString *s_id = [arr objectAtIndex:1];
                        if ([s_id intValue] == [[pro objectForKey:@"pid"]intValue]) {
                            CGFloat scard_discount = 1 -[[product objectForKey:@"discount"]floatValue]/100;//折扣
                            CGFloat y = [[pro objectForKey:@"pprice"] floatValue];//单价
                            [c_str appendFormat:@"%d=%.2f=%d_",[s_id intValue],scard_discount*y*[[arr objectAtIndex:2]intValue],[[arr objectAtIndex:2]intValue]];
                        }
                    }
                }
            }
            if (c_str.length>0) {
                [prod_ids appendFormat:@"2_%d_%@,",[[product objectForKey:@"customer_discount_id"] intValue],c_str];
            }
        }else if([product objectForKey:@"customer_package_id"]){
            //套餐卡
            NSMutableString *p_str = [NSMutableString string];
            for (NSDictionary *pro in [product objectForKey:@"products"]) {
                if([[pro objectForKey:@"selected"] intValue]==1){
                    int num = [[pro objectForKey:@"select_num"]intValue];
                    [p_str appendFormat:@"%d=%d_",[[pro objectForKey:@"proid"] intValue],num];
                }
            }
            if (p_str.length>0) {
                [prod_ids appendFormat:@"3_%d_%@,",[[product objectForKey:@"customer_package_id"] intValue],p_str];
            }
        }
    }
    if (x>1) {
        return @"x>1";
    }
    return prod_ids;
}

#pragma mark - 数据信息
-(NSMutableDictionary *)pastInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *str = [self checkForm];
    if (str.length>0) {
        [dic setObject:[str substringToIndex:str.length - 1] forKey:@"prods"];
    }
    [dic setObject:self.orderInfoObj.orderId forKey:@"order_id"];
    [dic setObject:[NSString stringWithFormat:@"%d",self.svSegBtn.selectedIndex] forKey:@"is_please"];
    [dic setObject:[NSString stringWithFormat:@"%.2f",self.total_count] forKey:@"total_price"];
    
    return dic;
}
#pragma mark -有付款权限－－前端支付
-(void)payOrderByAppWithImage:(UIImage *)image
{
    NSString *str = [self checkForm];
    if([str isEqualToString:@"x>1"]) {
        [Utility errorAlert:@"一次只能选择参加一个活动" dismiss:YES];
    }else {
        PayStyleViewController *payStyleView = [[PayStyleViewController alloc] initWithNibName:@"PayStyleViewController" bundle:nil];
        payStyleView.delegate = self;
        payStyleView.save_cardArray = [NSMutableArray arrayWithArray:self.save_cardArray];
        NSMutableDictionary *dic = [self pastInfo];
        payStyleView.orderDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        [self.mainViewControl addChildViewController:payStyleView];
        [payStyleView didMoveToParentViewController:self.mainViewControl];
        
        [self.mainViewControl presentPopupViewController:payStyleView animationType:MJPopupViewAnimationSlideBottomBottom width:171.5];
    }
}
#pragma mark -有付款权限－－前端支付－－代理
- (void)dismissPayStyleViewController:(PayStyleViewController *)payStyleViewController
{
    __block PayStyleViewController *viewControl = payStyleViewController;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop dismissBlock:^(BOOL isFinish){
        if (viewControl.isSuccess == YES) {
            self.order_type = 2;
            [self.delegate dismissOrderViewController:self];
        }
        
        [viewControl willMoveToParentViewController:nil];
        [viewControl removeFromParentViewController];
        viewControl = nil;
    }];
}
#pragma mark -没有付款权限－－后台支付
-(void)payOrderCheckstandWithImage:(UIImage *)image
{
    NSString *str = [self checkForm];
    if([str isEqualToString:@"x>1"]) {
        [Utility errorAlert:@"一次只能选择参加一个活动" dismiss:YES];
    }else {
        if (self.appDel.isReachable==NO) {
            [Utility errorAlert:@"请检查网络" dismiss:NO];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kPayByCheckstand];
            NSMutableDictionary *params= [self pastInfo];;
            [params setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
            
            if (image){
                [params setObject:image forKey:@"pic"];
            }
            
            [LTInterfaceBase request:params requestUrl:urlString method:@"POST" completeBlock:^(NSDictionary *dictionary) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    self.order_type = 1;
                    [self.delegate dismissOrderViewController:self];
                });
            } errorBlock:^(NSString *notice) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [Utility errorAlert:notice dismiss:YES];
                });
            }];
        }
    }
}
#pragma mark - 确认订单或者付款

-(IBAction)confirmOrderButtonPressed:(id)sender
{
    ///保存图片
    UIImage *signImage = nil;
    if (self.drawSignView.drawView.lineArray.count>0) {
        self.drawSignView.clearbtn.hidden = YES;
        self.drawSignView.backBtn.hidden = YES;
        
        UIGraphicsBeginImageContext(self.drawSignView.layer.frame.size);
        
        [self.drawSignView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        signImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
//    if ([[LTDataShare sharedService].user.userCashAuth intValue]==1) {//付款权限
        [self payOrderByAppWithImage:signImage];
//    }else {
//        [self payOrderCheckstandWithImage:signImage];
//    }
}

#pragma mark - 取消订单

-(IBAction)cancelOrderButtonClicked:(id)sender
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:kTitle message:@"确定取消订单?"];
    
    [alert setCancelButtonWithTitle:@"" block:nil];
    [alert addButtonWithTitle:@"" block:^{
        if (self.appDel.isReachable==NO) {
            BOOL success = NO;//记录添加本地是否成功
            LTDB *db = [[LTDB alloc]init];
            OrderModel *orderModel = [db getLocalOrderInfoWhereOid:self.orderInfoObj.orderId];
            if (orderModel != nil){
                orderModel.order_status = [NSString stringWithFormat:@"%d",7];//7:取消订单
                
                success = [db updateOrderInfoWithOrder:orderModel WhereOid:self.orderInfoObj.orderId];
            }else {
                orderModel = [[OrderModel alloc]init];
                orderModel.store_id = [LTDataShare sharedService].user.store_id;
                orderModel.order_id =[NSString stringWithFormat:@"%@",self.orderInfoObj.orderId];
                orderModel.order_status = [NSString stringWithFormat:@"%d",7];
                
                success = [db saveOrderDataToLocal:orderModel];
            }
            
            if (success) {
                self.order_type = 0;
                [self.delegate dismissOrderViewController:self];
            }else {
                [Utility errorAlert:@"订单取消失败" dismiss:NO];
            }
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,kSearchCancelOrder];
            
            NSMutableDictionary *paramas = [[NSMutableDictionary alloc] init];
            
            [paramas setObject:[LTDataShare sharedService].user.store_id forKey:@"store_id"];
            [paramas setObject:self.orderInfoObj.orderId forKey:@"order_id"];
            
            [LTInterfaceBase request:paramas requestUrl:urlString method:@"GET" completeBlock:^(NSDictionary *dictionary) {
                NSDictionary *stationDic = [dictionary objectForKey:@"work_orders"];
                [LTDataShare sharedService].stationDic = [NSMutableDictionary dictionaryWithDictionary:stationDic];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    self.order_type = 0;
                    [self.delegate dismissOrderViewController:self];
                });
            } errorBlock:^(NSString *notice) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    [Utility errorAlert:notice dismiss:YES];
                });
            }];
        }
    }];
    [alert show];
}

//退出
-(IBAction)quitViewControl:(id)sender
{
    self.order_type = -1;
    [self.delegate dismissOrderViewController:self];
}
@end
