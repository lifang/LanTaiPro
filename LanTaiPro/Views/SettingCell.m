//
//  SettingCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-20.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[SettingCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        
        
        self.infoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.textColor = [UIColor whiteColor];
        self.infoLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:14];
        [self.contentView addSubview:self.infoLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    UIFont *font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:14];
    CGSize size = [self.infoLabel.text sizeWithFont:font];
    
    self.infoLabel.frame = (CGRect){448-15-size.width,(60-size.height)/2,size.width,size.height};
}
@end
