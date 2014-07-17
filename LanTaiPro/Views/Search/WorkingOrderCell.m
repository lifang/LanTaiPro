//
//  WorkingOrderCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "WorkingOrderCell.h"

@implementation WorkingOrderCell

- (void)awakeFromNib
{

}
-(NSMutableArray *)buttonArray
{
    if(!_buttonArray){
        _buttonArray = [[NSMutableArray alloc]init];
    }
    return _buttonArray;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIdxPath:(NSIndexPath *)idxPath
{
    _idxPath = idxPath;
}

- (UILabel *)returnlabel
{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1];
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
    return label;
}
///0等待施工 1正在施工 2等待付款  3已付款未施工 4已付款正在施工
-(NSString *)orderStatus:(int)status
{
    NSString *statusString = @"";
    
    self.payOrderButton.hidden = NO;
    self.returnOrderButton.hidden = NO;
    self.buttonArray = nil;
    
    if (status == 0) {//取消订单，付款
        statusString = @"等待施工的单子";
        
        self.returnOrderButton.hidden = YES;
        
        [self.buttonArray addObject:self.payOrderButton];
    }else if (status == 1){//取消订单，付款，结束施工
        statusString = @"施工中的单子";
        
        self.returnOrderButton.hidden = YES;
        [self.buttonArray addObject:self.payOrderButton];
    }else if (status == 2){//付款--有服务
        statusString = @"等待付款的单子";
        
        self.returnOrderButton.hidden = YES;
        [self.buttonArray addObject:self.payOrderButton];
    }else if (status == 3){//退单
        statusString = @"付款后的等待施工的单子";
        
        self.payOrderButton.hidden = YES;
        [self.buttonArray addObject:self.returnOrderButton];
    }else if (status == 4){//退单，结束施工
        statusString = @"付款后的施工中的单子";
        self.payOrderButton.hidden = YES;
        [self.buttonArray addObject:self.returnOrderButton];
    }else if (status == 5) {//付款--无服务
        statusString = @"等待付款的单子";
        
        self.returnOrderButton.hidden = YES;
        [self.buttonArray addObject:self.payOrderButton];
    }
    
    return statusString;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier workingOrder:(SearchOrder *)workOrder
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"WorkingOrderCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[WorkingOrderCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
        
        self.codeLabel.text = workOrder.code;
        self.salePeopleLabel.text = workOrder.name;
        self.techLabel.text = workOrder.staff_name;
        self.timeLabel.text = workOrder.created_at;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%@",workOrder.price];
        self.statusLabel.text = [self orderStatus:[workOrder.status integerValue]];
        
        CGRect frame = CGRectMake(0, 70, 258, 30);
        for (int i=0; i<workOrder.productList.count; i++) {
            SearchProduct *productModel = (SearchProduct *)workOrder.productList[i];
            //名称
            UILabel *nameLab = [self returnlabel];
            nameLab.frame = frame;
            nameLab.text = [NSString stringWithFormat:@"%@",productModel.name];
            [self.contentView addSubview:nameLab];
            nameLab = nil;
            frame.origin.x += frame.size.width;
            frame.size.width = 130;
            //单价
            UILabel *priceLab = [self returnlabel];
            priceLab.frame = frame;
            priceLab.text = [NSString stringWithFormat:@"%@",productModel.price];
            [self.contentView addSubview:priceLab];
            priceLab = nil;
            frame.origin.x += frame.size.width;
            //数量
            UILabel *numLab = [self returnlabel];
            numLab.frame = frame;
            numLab.text = [NSString stringWithFormat:@"%@",productModel.pro_num];
            [self.contentView addSubview:numLab];
            numLab = nil;
            frame.origin.x += frame.size.width;
            //小计
            UILabel *totalLab = [self returnlabel];
            totalLab.frame = frame;
            totalLab.text = [NSString stringWithFormat:@"%@",productModel.total_price];
            [self.contentView addSubview:totalLab];
            totalLab = nil;
            
            frame.origin.y += frame.size.height;
            frame.origin.x = 0;
            frame.size.width = 258;
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (int i=0; i<self.buttonArray.count; i++) {
        UIButton *btn = (UIButton *)self.buttonArray[i];
        CGRect frame = btn.frame;
        frame.origin.x = 540-98*i;
        btn.frame = frame;
        [btn layoutIfNeeded];
    }
}

#pragma mark -------------------------------

//付款
-(IBAction)payOrderClicked:(id)sender
{
    [self.delegate payWorkingOrder:self];
}

//退单
-(IBAction)returnBackClicked:(id)sender
{
    [self.delegate returnBackOrder:self];
}
@end
