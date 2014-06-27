//
//  DrawSignView.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-20.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"

@interface DrawSignView : UIView

@property (nonatomic, strong) DrawView *drawView;

@property (nonatomic, weak) IBOutlet UIButton *clearbtn,*backBtn;
@end
