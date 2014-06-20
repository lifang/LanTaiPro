//
//  FastToOrderCell.h
//  LanTaiPro
//
//  Created by lantan on 14-6-5.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FastToOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *serveBt;
@property (nonatomic,strong) NSIndexPath *path;
@property (nonatomic,assign) BOOL isSelected;


@end


