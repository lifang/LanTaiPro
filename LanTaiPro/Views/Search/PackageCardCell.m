//
//  PackageCardCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-3.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PackageCardCell.h"

@implementation PackageCardCell

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
    return label;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier packageCardModel:(PackageCardModel *)package
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PackageCardCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[PackageCardCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
        
        self.packageModel = package;
        
        self.titleLabel.text = package.name;
        self.timeLabel.text = [NSString stringWithFormat:@"截止时间:%@",package.ended_at];
        
        
        CGRect frame = CGRectMake(0, 58, 0, 30);
        for (int i=0; i<package.productList.count; i++) {
            frame.size.height = 30;
            PackageCardProductModel *packageProduct = (PackageCardProductModel *)package.productList[i];
            //左边---------------------
            NSString *content = [NSString stringWithFormat:@"%@ %@次",packageProduct.name,packageProduct.product_num];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, packageProduct.name.length)];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1] range:NSMakeRange(packageProduct.name.length+1, packageProduct.product_num.length)];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(content.length-1, 1)];
            
            UILabel *leftLab = [self returnlabel];
            leftLab.attributedText = attributedString;
            leftLab.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:16];
            
            frame.origin.x = 0;
            frame.size.width = 168;
            frame.origin.y = 58+30*i;
            leftLab.frame = frame;
        
            [self.contentView addSubview:leftLab];
            //右边---------------------
            //项目
            UILabel *nameLab = [self returnlabel];
            nameLab.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
            nameLab.textColor = [UIColor whiteColor];
            nameLab.text = packageProduct.name;
            
            frame.origin.x = 169;
            frame.size.width = 200;
            frame.origin.y = 78+30*i;
            nameLab.frame = frame;
            [self.contentView addSubview:nameLab];
            //已使用
            UILabel *useLab = [self returnlabel];
            useLab.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
            useLab.textColor = [UIColor whiteColor];
            useLab.text = [NSString stringWithFormat:@"%d",[packageProduct.product_num integerValue]-[packageProduct.unused_num integerValue]];
            
            frame.origin.x = 369;
            frame.size.width = 100;
            frame.origin.y = 78+30*i;
            useLab.frame = frame;
            [self.contentView addSubview:useLab];
            //剩余
            UILabel *unuseLab = [self returnlabel];
            unuseLab.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
            unuseLab.textColor = [UIColor whiteColor];
            unuseLab.text = packageProduct.unused_num;
            
            frame.origin.x = 469;
            frame.size.width = 100;
            frame.origin.y = 78+30*i;
            unuseLab.frame = frame;
            [self.contentView addSubview:unuseLab];
            
            //选择框
            if ([packageProduct.unused_num integerValue]>0) {//还有未使用
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = [packageProduct.productId integerValue];
                
                [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateSelected];
                
                [btn addTarget:self action:@selector(checkboxButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                frame.origin.x = 592;
                frame.size.width = 22;
                frame.size.height = 22;
                frame.origin.y = 78+30*i;
                btn.frame = frame;
                [self.contentView addSubview:btn];
            }
        }
        
        
        
    }
    return self;
}

-(NSString *)returnStringWith:(NSString *)packageId productId:(int)productId
{
    NSString *str = [NSString stringWithFormat:@"%@_%d",self.packageModel.packageId,productId];
    
    return str;
}

-(void)checkboxButtonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    NSString *string = [self returnStringWith:self.packageModel.packageId productId:btn.tag];
    if (btn.selected) {//选中
        if (![LTDataShare sharedService].packageOrderArray) {
            [LTDataShare sharedService].packageOrderArray = [[NSMutableArray alloc]init];
        }
        [[LTDataShare sharedService].packageOrderArray addObject:string];
    }else {//取消选中
        [[LTDataShare sharedService].packageOrderArray removeObject:string];
    }
    
    DLog(@"%@",[LTDataShare sharedService].packageOrderArray);
}
@end
