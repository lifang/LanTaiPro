//
//  SelectedView.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"

@interface SelectedView : UIView<QRadioButtonDelegate>

@property(nonatomic, strong) void (^selectedBlock)(NSInteger tag);
@property(nonatomic, strong) QRadioButton *button1;
@property(nonatomic, strong) QRadioButton *button2;

+(SelectedView *)defaultSelectedViewWithFrame:(CGRect)frame type:(NSInteger)type withDefault:(NSString*)string selected:(void (^)(NSInteger tag))block;

@end
