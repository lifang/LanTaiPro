//
//  AppointmentCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-20.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppointmentModel.h"
#import "AppointButton.h"

@protocol AppointCellDelegate;

@interface AppointmentCell : UITableViewCell

@property (nonatomic, assign) id<AppointCellDelegate>delegate;
///背景图片
@property (nonatomic, strong) UIImageView *backgroundImageView;
///会员信息
@property (nonatomic, weak) IBOutlet UIImageView *vipImage;
@property (nonatomic, weak) IBOutlet UILabel *vipLabel;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
///排单按钮
@property (nonatomic, weak) IBOutlet AppointButton *cancelOrderButton;
@property (nonatomic, weak) IBOutlet AppointButton *confirmOrderButton;
///开单按钮
@property (nonatomic, weak) IBOutlet AppointButton *cancelAcceptButton;
@property (nonatomic, weak) IBOutlet AppointButton *confirmAcceptButton;

@property (nonatomic, strong) NSIndexPath *idxPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier appoint:(AppointModel *)appointModel isAccept:(BOOL)isAccept;

@end

@protocol AppointCellDelegate <NSObject>

-(void)buttonPressedWithBtn:(AppointButton *)btn;
-(void)confirmAcceptButtonPressed;

@end