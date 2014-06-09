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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
        self.totalPriceLabel.text = workOrder.price;
        
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

#pragma mark -------------------------------

-(IBAction)cancelOrderClicked:(id)sender
{
    [self.delegate cancelWorkingOrder:self];
}

-(IBAction)confirmOrderClicked:(id)sender
{
    [self.delegate confirmWorkingOrder:self];
}

@end
