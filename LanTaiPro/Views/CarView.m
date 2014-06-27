//
//  CarView.m
//  LanTaiPro
//
//  Created by lantan on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "CarView.h"

@interface CarView()

@property (strong, nonatomic)UILabel *carNumberLab;//车牌
@property (nonatomic, strong)NSString *stationId;//工位ID
@property (strong, nonatomic)UIImageView *carImageView;
@end

@implementation CarView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.carImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.carImageView setImage:[UIImage imageNamed:@"Car"]];
        self.carImageView.userInteractionEnabled = YES;
        [self addSubview:self.carImageView];
        
        self.carNumberLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.carNumberLab.backgroundColor = [UIColor clearColor];
        self.carNumberLab.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:12];
//        self.carNumberLab.text = @"SU12345";
        
        [self addSubview:self.carNumberLab];
        self.stationCarModel = [[StationCarModel alloc]init];
//        NSLog(@"--------%@",self.stationCarModel);
        [self initCarViewWithCarModel:self.stationCarModel];
    }
    return self;
}

-(void)initCarViewWithCarModel:(StationCarModel *)stationCarModel;
{
    
    self.carNumberLab.text = stationCarModel.carPlateNumber;
    self.stationId =stationCarModel.station_id;
    self.orderId = stationCarModel.order_id;
    self.workId = stationCarModel.workOrder_id;
}

- (void)layoutSubviews
{
    self.carImageView.frame = CGRectMake(0, 25, 125, 30);
    self.carNumberLab.frame = CGRectMake(33, 0, 77, 21);
}


-(CarView *)copyCarView{
    
    CarView *copyView = [[CarView alloc] init];
//    copyView.carNumberLab.text = self.carNumberLab.text;
    copyView.carNumber = self.carNumber;
    copyView.state = self.state;
    
    copyView.frame = [self convertRect:self.frame toView:self.superview];
    return copyView;
    
}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//
////    [super touchesBegan:touches withEvent:event];
////    [[self tableView] setScrollEnabled:NO];
////    
////    UITouch *touch = [touches anyObject];
////    CGPoint point = [touch locationInView:[self.superview.superview superview]];
////    self.offset = CGSizeMake(self.center.x - point.x, self.center.y - point.y);
////    self.oldCenter = CGPointMake(self.center.x, self.center.y);
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    
////    [[self tableView] setScrollEnabled:YES];
////    CGPoint newCenter;
////    if (ABS(self.oldCenter.y - self.center.y)>79) {
////        int i = ABS(self.oldCenter.y - self.center.y)/79;
////        newCenter.x = self.oldCenter.x;
////        if (self.center.y > 0 && self.center.x > 0) {
////            if (self.oldCenter.y>self.center.y) {
////                newCenter.y = (self.oldCenter.y-79*i);
////            }
////            else
////            {
////                newCenter.y = (self.oldCenter.y+79*i);
////            }
////             self.center = newCenter;
////        }
////        else
////        {
////            newCenter.y = self.oldCenter.y;
////            newCenter.x = self.oldCenter.x;
////            self.center = newCenter;
////        }
////    }
////    else
////    {
////        newCenter.y = self.oldCenter.y;
////        newCenter.x = self.oldCenter.x;
////        self.center = newCenter;
////    }
//    }
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//    
////    UITouch *touch = [touches anyObject];
////    CGPoint point = [touch locationInView:[self.superview.superview superview]];
////    point.x += self.offset.width;
////    point.y += self.offset.height;
////    self.center = point;
////    NSString *pointStr ;
////    pointStr = NSStringFromCGPoint(self.center);
////    NSLog(@"%@",pointStr);
//}

-(void)setState:(CarState)state
{
    _state = state;
    switch (state) {
        case CARWAITTING:
        {
            [self.carImageView setImage:[UIImage imageNamed:@"Car"]];
            self.carNumberLab.text = self.carNumber;
            break;
        }
        case CARBEGINNING:
        {
            [self.carImageView setImage:[UIImage imageNamed:@"Car"]];
            self.carNumberLab.text = self.carNumber;
            break;
        }
        case CARPAYING:
        case CARFINISHED:
        {
            [self.carImageView setImage:[UIImage imageNamed:@"Car"]];
            self.carNumberLab.text = self.carNumber;
            break;
        }
        case CARNOTHING:
        {
            [self.carImageView setImage:nil];
            self.carNumberLab.text = nil;
            [self.coverView setHidden:YES];
            break;
        }
            
            
        default:
            break;
    }
}
@end
