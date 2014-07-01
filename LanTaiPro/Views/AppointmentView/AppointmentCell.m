//
//  AppointmentCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-20.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "AppointmentCell.h"

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@implementation AppointmentCell

- (void)awakeFromNib
{
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView setImage:[[UIImage imageNamed:@"appoint-cell"] stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
    [self.contentView insertSubview:self.backgroundImageView atIndex:0];
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
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = [UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1];
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:17];
    return label;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier appoint:(AppointModel *)appointModel isAccept:(BOOL)isAccept
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"AppointmentCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[AppointmentCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        
        /////////////////////////////////////////////////////////////////////////////////////
        if (isAccept) {
            self.cancelOrderButton.hidden = YES;
            self.confirmOrderButton.hidden = YES;
            self.cancelAcceptButton.hidden = NO;
            self.confirmAcceptButton.hidden = NO;
        }else {
            self.cancelOrderButton.hidden = NO;
            self.confirmOrderButton.hidden = NO;
            self.cancelAcceptButton.hidden = YES;
            self.confirmAcceptButton.hidden = YES;
        }
        
        //未受理
        self.cancelOrderButton.type = @"3";
        self.cancelOrderButton.reservation_id = appointModel.appointId;
        self.confirmOrderButton.type = @"1";
        self.confirmOrderButton.reservation_id = appointModel.appointId;
        
        //已受理
        self.cancelAcceptButton.type = @"3";
        self.cancelAcceptButton.reservation_id = appointModel.appointId;
        self.confirmAcceptButton.type = @"2";
        self.confirmAcceptButton.reservation_id = appointModel.appointId;
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@",appointModel.appointUserName];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",appointModel.appointCreatTime];
        //产品
        CGRect frame = CGRectMake(0, 70, 129, 30);
        frame.size.height = appointModel.appointProductList.count * 30;
        //车牌号
        UILabel *carNumLabel = [self returnlabel];
        carNumLabel.frame = frame;
        carNumLabel.text = [NSString stringWithFormat:@"%@",appointModel.appointCarNum];
        [self.contentView addSubview:carNumLabel];
        carNumLabel = nil;
        //车型
        frame.origin.x += frame.size.width;
        frame.size.width = 130;
        UILabel *carNameLabel = [self returnlabel];
        carNameLabel.frame = frame;
        carNameLabel.text = [NSString stringWithFormat:@"%@",appointModel.appointCarName];
        [self.contentView addSubview:carNameLabel];
        carNameLabel = nil;
        //联系电话
        frame.origin.x += frame.size.width;
        frame.size.width = 129;
        UILabel *phoneLabel = [self returnlabel];
        phoneLabel.frame = frame;
        phoneLabel.text = [NSString stringWithFormat:@"%@",appointModel.appointUserPhone];
        [self.contentView addSubview:phoneLabel];
        phoneLabel = nil;
        //预约项目
        frame.origin.x += frame.size.width;
        frame.size.width = 130;
        frame.size.height = 30;
        for (int i=0; i<appointModel.appointProductList.count; i++) {
            AppointproductModel *productModel = (AppointproductModel *)appointModel.appointProductList[i];
            UILabel *productLabel = [self returnlabel];
            productLabel.frame = frame;
            productLabel.text = [NSString stringWithFormat:@"%@",productModel.a_p_name];
            [self.contentView addSubview:productLabel];
            productLabel = nil;
            frame.origin.y += frame.size.height;
        }
        //预计到达时间
        frame.origin.x += frame.size.width;
        frame.size.height = appointModel.appointProductList.count * 30;
        frame.origin.y = 70;
        UILabel *resTimeLabel = [self returnlabel];
        resTimeLabel.frame = frame;
        resTimeLabel.text = [NSString stringWithFormat:@"%@",appointModel.appointResTime];
        [self.contentView addSubview:resTimeLabel];
        resTimeLabel = nil;
        //判断会员
        if ([appointModel.appointUserVip integerValue]==1) {
            self.vipImage.hidden = NO;
            self.vipLabel.hidden = NO;
        }else {
            self.vipImage.hidden = YES;
            self.vipLabel.hidden = YES;
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    
    self.backgroundImageView.frame = (CGRect){0,0,CELL_WIDTH,CELL_HEIGHT-8};
}

-(void)setIdxPath:(NSIndexPath *)idxPath{
    _idxPath = idxPath;
    self.cancelOrderButton.btnIndexPath = idxPath;
    self.confirmOrderButton.btnIndexPath = idxPath;
    self.cancelAcceptButton.btnIndexPath = idxPath;
    self.confirmAcceptButton.btnIndexPath = idxPath;
}
#pragma mark - 点击事件
-(IBAction)buttonPressedWithTag:(id)sender
{
    AppointButton *btn = (AppointButton *)sender;
    [self.delegate buttonPressedWithBtn:btn];
}
-(IBAction)confirmAcceptButtonPressed:(id)sender
{
    AppointButton *btn = (AppointButton *)sender;
    [self.delegate confirmAcceptButtonPressed:btn];
}


@end
