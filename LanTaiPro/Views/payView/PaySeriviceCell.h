//
//  PaySeriviceCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-7-4.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySeriviceCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) IBOutlet UILabel *lblName,*lblCount,*lblPrice,*lbltotal;
@property (nonatomic,strong) NSMutableDictionary *product;
@property (nonatomic,strong) NSIndexPath *index;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier with:(NSMutableDictionary *)prod indexPath:(NSIndexPath *)idx type:(NSInteger)type;

@end
