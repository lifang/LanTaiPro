//
//  FastToOrderCell.m
//  LanTaiPro
//
//  Created by lantan on 14-6-5.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "FastToOrderCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FastToOrderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}

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
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FastToOrderCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[FastToOrderCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.serveBt addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonClicked{
 
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        [self.serveBt setBackgroundImage:[UIImage imageNamed:@"serveRedbg.png"] forState:UIControlStateNormal];
    }else{
        [self.serveBt setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

-(void)fastToOrderCell:(FastToOrderCell*)itemView didSelectedItemAtIndexPath:(NSIndexPath*)path;
{
    NSLog(@"------------");
}



@end
