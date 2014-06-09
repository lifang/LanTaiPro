//
//  ServiceBillingCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-3.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ServiceBillingCell.h"

@implementation ServiceBillingCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ServiceBillingCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[ServiceBillingCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    
}
@end
