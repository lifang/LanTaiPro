//
//  LTAppointmentViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 预约界面
 * 预约信息
 * 受理，拒绝，取消
 * by－－－邱成西
 */

#import "AppointmentModel.h"
#import "AppointmentCell.h"

@interface LTAppointmentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AppointCellDelegate>

@property (nonatomic, strong) AppDelegate *appDel;
@property (nonatomic, weak) IBOutlet UITableView *appointmentTable;
///是否受理
@property (nonatomic, assign) BOOL isAccept;

@property (nonatomic, strong) AppointmentModel *appointmentModel;
@end
