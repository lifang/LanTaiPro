//
//  carCell.m
//  LanTaiPro
//
//  Created by lantan on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "carCell.h"
#import "CarModel.h"

@implementation carCell

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
        NSArray *arrayOfViews = [[NSBundle mainBundle]loadNibNamed:@"carCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[carCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

-(void)initCellWithValue:(NSInteger)type
{
    
}

//给cell中除工位以为的，赋值
-(void)initCarCellWithCarModel:(CarModel *)carModel
{
    self.carImg.hidden = NO;
    self.stationNameLab.hidden = NO;
    self.carNumLab.hidden = NO;
    self.checkOrderBtn.hidden = NO;
    self.serviceNameLab.hidden = NO;
#warning !!!
//    NSString *startTime = carModel.serviceStartTime;
//    NSString *endrtTime = carModel.serviceEndTime;
//    self.serviceNameLab.text = carModel.serviceName;
//    self.carNumLab.text = carModel.carPlateNumber;
//    self.stationId = carModel.station_id;
//    self.orderId = carModel.order_id;
}

//给工位赋值
-(void)initcarcellStation:(StationModel *)carModel
{
    self.carImg.hidden = YES;
    self.stationTimeLab.hidden = YES;
    self.carNumLab.hidden = YES;
    self.checkOrderBtn.hidden = YES;
    self.serviceNameLab.hidden = YES;
    self.stationId = carModel.station_id;
    self.stationNameLab.text = carModel.name;
}

@end
