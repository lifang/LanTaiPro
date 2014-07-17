//
//  ServiceBillingOrderCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-10.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ServiceBillingOrderCell.h"

@implementation ServiceBillingOrderCell

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
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:18];
    return label;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier product:(OrderProductModel *)product
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ServiceBillingOrderCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[ServiceBillingOrderCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
        
        self.proModel = product;
        
        UILabel *lab1 = [self returnlabel];
        lab1.text = product.name;
        lab1.frame = (CGRect){0,0,209,30};
        [self addSubview:lab1];
        
        UILabel *lab2 = [self returnlabel];
        lab2.text = product.price;
        lab2.frame = (CGRect){210,0,106,30};
        [self addSubview:lab2];
        
        UILabel *lab3 = [self returnlabel];
        lab3.text = [NSString stringWithFormat:@"%d",product.number];
        lab3.frame = (CGRect){315,0,106,30};
        [self addSubview:lab3];
        
        UILabel *lab4 = [self returnlabel];
        lab4.text = [NSString stringWithFormat:@"%.2f",[product.price floatValue]*product.validNumber];
        lab4.frame = (CGRect){420,0,106,30};
        [self addSubview:lab4];
    }
    return self;
}

@end
