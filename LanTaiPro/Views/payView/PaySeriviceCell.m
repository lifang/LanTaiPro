//
//  PaySeriviceCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-7-4.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "PaySeriviceCell.h"

@implementation PaySeriviceCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSString *)checkFormWithID:(int)ID andCount:(int)count andPrice:(float)price {
    NSMutableString *prod_count = [NSMutableString string];
    [prod_count appendFormat:@"%d_%d_%.2f,",ID,count,price];
    return prod_count;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier with:(NSMutableDictionary *)prod indexPath:(NSIndexPath *)idx type:(NSInteger)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PaySeriviceCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[PaySeriviceCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.product = [prod mutableCopy];
        self.index = idx;
        
        self.lblName.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:16];
        self.lblCount.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:16];
        self.lblPrice.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:16];
        self.lbltotal.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:16];
    }
    return self;
}

@end
