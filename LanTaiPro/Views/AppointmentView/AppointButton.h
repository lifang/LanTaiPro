//
//  AppointButton.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-21.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointButton : UIButton

@property (nonatomic, strong) NSString *reservation_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSIndexPath *btnIndexPath;
@end
