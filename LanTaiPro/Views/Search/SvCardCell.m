//
//  SvCardCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-3.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SvCardCell.h"

@implementation SvCardCell

- (void)awakeFromNib
{
    // Initialization code
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
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:15];
    return label;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier svCard:(SvCardModel *)svCard
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SvCardCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[SvCardCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel.text = svCard.name;
        self.timeLabel.text = [NSString stringWithFormat:@"最后消费日期:%@",svCard.last_time];
        self.totalPriceLabe.text = [NSString stringWithFormat:@"面值:%@",svCard.totle_price];
        
        
        self.applyContentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.applyContentLabel.textAlignment = NSTextAlignmentCenter;
        self.applyContentLabel.backgroundColor = [UIColor clearColor];
        self.applyContentLabel.numberOfLines = 0;
        self.applyContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.applyContentLabel.text = [NSString stringWithFormat:@"适用:%@",svCard.apply_content];
        self.applyContentLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:15];
        self.applyContentLabel.frame = (CGRect){10,65,141,svCard.recordList.count*30};
        self.applyContentLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.applyContentLabel];
        
        
        CGRect frame = CGRectMake(151, 65, 0, 30);
        for (int i=0; i<svCard.recordList.count; i++){
            frame.origin.y = 65+30*i;
            SvCardProductModel *svProduct = (SvCardProductModel *)svCard.recordList[i];
            //卡内金额
            UILabel *totalPriceLab = [self returnlabel];
            totalPriceLab.text = [NSString stringWithFormat:@"%.2f",[svProduct.origin_price floatValue]];
            
            frame.origin.x = 151;
            frame.size.width =90;
            totalPriceLab.frame = frame;
            [self.contentView addSubview:totalPriceLab];
            //日期
            UILabel *timeLab = [self returnlabel];
            timeLab.text = svProduct.created_at;
            
            frame.origin.x += frame.size.width;
            frame.size.width =100;
            timeLab.frame = frame;
            [self.contentView addSubview:timeLab];
            //项目
            UILabel *codeLab = [self returnlabel];
            codeLab.text = [NSString stringWithFormat:@"%@",svProduct.products];
            
            frame.origin.x += frame.size.width;
            frame.size.width =130;
            codeLab.frame = frame;
            [self.contentView addSubview:codeLab];
            //消费金额
            UILabel *useLab = [self returnlabel];
            useLab.text = svProduct.use_price;
            
            frame.origin.x += frame.size.width;
            frame.size.width =83;
            useLab.frame = frame;
            [self.contentView addSubview:useLab];
            //余额
            UILabel *unuseLab = [self returnlabel];
            unuseLab.text = svProduct.left_price;
            
            frame.origin.x += frame.size.width;
            frame.size.width =83;
            unuseLab.frame = frame;
            [self.contentView addSubview:unuseLab];

        }
        
    }
    return self;
}
@end
