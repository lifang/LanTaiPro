//
//  LTImageViewController.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-23.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTImageViewController.h"

#import "CustomView.h"

@interface LTImageViewController ()

@end

@implementation LTImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (self.classifyType) {
        case 0:
            self.count = self.productModel.productList.count;
            break;
        case 1:
            self.count = self.productModel.serviceList.count;
            break;
        case 2:
            self.count = self.productModel.cardList.count;
            break;
            
        default:
            self.count = 0;
            break;
    }
    
    
    [self.scrollView setCurPage:self.currentPage];
    [self.view insertSubview:self.scrollView belowSubview:self.bottomView];
    
    self.countLabel.text = [NSString stringWithFormat:@"%d / %d",self.currentPage+1,self.count];
    
    //定义button的tag＝10:加入购物车。tag＝9未加入购物车
    NSString *tagString = [NSString stringWithFormat:@"%d",self.currentPage];
    if ([self.selectedArray containsObject:tagString]) {
        [self.shopButton setImage:[UIImage imageNamed:@"product-shop-selected"] forState:UIControlStateNormal];
        self.shopButton.tag = 10;
    }else {
        [self.shopButton setImage:[UIImage imageNamed:@"product-shop"] forState:UIControlStateNormal];
        self.shopButton.tag = 9;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - property

-(XLCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView =[[XLCycleScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.datasource = self;
        _scrollView.backgroundColor = [UIColor blackColor];
    }
    return _scrollView;
}

#pragma mark - UIScrollView代理
- (NSInteger)numberOfPages
{
    return self.count;
}
-(CGSize)returnSizeWithString:(NSString *)string
{
    UIFont *aFont = [UIFont fontWithName:@"HiraginoSansGB-W3" size:17];
    CGSize size = [string sizeWithFont:aFont constrainedToSize:CGSizeMake(728, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
    
}
- (UIView *)pageAtIndex:(NSInteger)index
{
    NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
    CustomView *currentView = (CustomView*)[bundles objectAtIndex:0];
    
    NSString *detailString;
    if (self.classifyType==0  ) {
        ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.productList[index];
        [currentView.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,psModel.p_imageUrl]] placeholderImage:[UIImage imageNamed:@"userAdd"]];
        currentView.nameLab.text = psModel.p_name;
        currentView.priceLab.text = psModel.p_price;
        detailString = psModel.p_description;
        
    }else if (self.classifyType==1){
        ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.productModel.serviceList[index];
        [currentView.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,psModel.p_imageUrl]] placeholderImage:[UIImage imageNamed:@"userAdd"]];
        currentView.nameLab.text = psModel.p_name;
        currentView.priceLab.text = psModel.p_price;
        detailString = psModel.p_description;
    }else {
        CardModel *cardModel = (CardModel *)self.productModel.cardList[index];
        [currentView.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[LTDataShare sharedService].user.kHost,cardModel.c_imageUrl]] placeholderImage:[UIImage imageNamed:@"userAdd"]];
        currentView.nameLab.text = cardModel.c_name;
        currentView.priceLab.text = cardModel.c_price;
        detailString = cardModel.c_description;
    }

    CGRect frame = currentView.infoLab.frame;
    CGSize size = [self returnSizeWithString:detailString];
    if (size.height-70>0){
        frame.size.height = 70;
    }else {
        frame.size.height = size.height;
    }
    currentView.infoLab.text = detailString;
    currentView.infoLab.frame = frame;
    [currentView.infoLab layoutIfNeeded];
    
    return currentView;
}

-(void)scrollAtPage:(NSInteger)page
{
    self.currentPage = page;
    self.countLabel.text = [NSString stringWithFormat:@"%d / %d",page+1,self.count];
    NSString *tagString = [NSString stringWithFormat:@"%d",self.currentPage];
    if ([self.selectedArray containsObject:tagString]) {
        [self.shopButton setImage:[UIImage imageNamed:@"product-shop-selected"] forState:UIControlStateNormal];
        self.shopButton.tag = 10;
    }else {
        [self.shopButton setImage:[UIImage imageNamed:@"product-shop"] forState:UIControlStateNormal];
        self.shopButton.tag = 9;
    }
}

#pragma mark - 点击事件

-(IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(IBAction)addShop:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *tagString = [NSString stringWithFormat:@"%d",self.currentPage];
    NSDictionary *aDic;
    if (btn.tag == 10) {//取消
        [self.selectedArray removeObject:tagString];
        [self.shopButton setImage:[UIImage imageNamed:@"product-shop"] forState:UIControlStateNormal];
        self.shopButton.tag = 9;
        aDic = [NSDictionary dictionaryWithObjectsAndKeys:tagString,@"index",@"0",@"isSelected", nil];
    }else if (btn.tag == 9){//加入购物车
        [self.selectedArray addObject:tagString];
        [self.shopButton setImage:[UIImage imageNamed:@"product-shop-selected"] forState:UIControlStateNormal];
        self.shopButton.tag = 10;
        aDic = [NSDictionary dictionaryWithObjectsAndKeys:tagString,@"index",@"1",@"isSelected", nil];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"shoppingNotification" object:aDic];
}
@end
