//
//  OldOrderCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-30.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "OldOrderCell.h"

@implementation OldOrderCell

- (void)awakeFromNib
{

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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier oldOrder:(SearchOrder *)oldOrder
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"OldOrderCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[OldOrderCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
        
        self.codeLabel.text = oldOrder.code;
        self.salePeopleLabel.text = oldOrder.name;
        self.techLabel.text = oldOrder.staff_name;
        self.timeLabel.text = oldOrder.created_at;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%@",oldOrder.price];
        
        CGRect frame = CGRectMake(0, 70, 248, 30);
        for (int i=0; i<oldOrder.productList.count; i++) {
            SearchProduct *productModel = (SearchProduct *)oldOrder.productList[i];
            //名称
            UILabel *nameLab = [self returnlabel];
            nameLab.frame = frame;
            nameLab.text = [NSString stringWithFormat:@"%@",productModel.name];
            [self.contentView addSubview:nameLab];
            nameLab = nil;
            frame.origin.x += frame.size.width;
            frame.size.width = 100;
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
            frame.origin.x += frame.size.width;
            //付款方式
            UILabel *payLab = [self returnlabel];
            payLab.frame = frame;
            payLab.text = [NSString stringWithFormat:@"%@",productModel.total_price];
            [self.contentView addSubview:payLab];
            payLab = nil;
            
            frame.origin.y += frame.size.height;
            frame.origin.x = 0;
            frame.size.width = 248;
        }
        
    }
    return self;
}

#pragma mark -------------------------------

-(IBAction)complaintOrderClicked:(id)sender
{
    [self.delegate ComplaintOldOrder:self];
}

@end
