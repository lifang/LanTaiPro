//
//  OrderCell.m
//  LanTaiPro
//
//  Created by lantan on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "OrderCell.h"
#import "DataService.h"

@implementation OrderCell

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
        NSArray *arrayOfViews = [[NSBundle mainBundle]loadNibNamed:@"OrderCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[OrderCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

-(void)initOrderCell:(NSDictionary *)orderPro
{
    self.serviceLab.text = [NSString stringWithFormat:@"%@",[orderPro objectForKey:@"name"]];
    self.unitPriceLab.text = [NSString stringWithFormat:@"%@",[orderPro objectForKey:@"price"]];
    self.numLab.text = [NSString stringWithFormat:@"%@",[orderPro objectForKey:@"pro_num"]];
    self.subTotalLab.text = [NSString stringWithFormat:@"%@",[orderPro objectForKey:@"total_price"]];
    
    int sub = [self.subTotalLab.text intValue];
    int total = [[DataService sharedService].stationTotal intValue] + sub;
    //总计
    [[DataService sharedService].stationTotal setString:[NSString stringWithFormat:@"%d",total]];
    //添加通知，显示总计
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showTotal" object:self];
}

@end
