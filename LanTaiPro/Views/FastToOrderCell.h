//
//  FastToOrderCell.h
//  LanTaiPro
//
//  Created by lantan on 14-6-5.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FastDelegate <NSObject>

-(void)print;

@end

@interface FastToOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *serveBt;
@property (nonatomic,strong) NSIndexPath *path;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) id<FastDelegate>delegate;

@end

//@protocol FastToOrderCellDelegate <NSObject>
//
//-(void)fastToOrderCell:(FastToOrderCell *)itemView didSelectedItemAtIndexPath:(NSIndexPath*)path;
//-(void)print;

