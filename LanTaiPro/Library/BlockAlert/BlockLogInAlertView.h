//
//  BlockLogInAlertView.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-16.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "BlockAlertView.h"

@class BlockLogInAlertView;

typedef BOOL(^TextFieldCallBack)(BlockLogInAlertView *);

@interface BlockLogInAlertView : BlockAlertView <UITextFieldDelegate> {
    
    NSCharacterSet *unacceptedInput;
    NSInteger maxLength;
}
@property (nonatomic, retain) UIView *nameView;
@property (nonatomic, retain) UIView *passWordView;

+ (BlockLogInAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message nameTextField:(out UITextField**)nameTxt pwdTextField:(out UITextField**)pwdTxt block:(TextFieldCallBack) block;


- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block: (TextFieldCallBack) block;


- (void)setAllowableCharacters:(NSString*)accepted;
- (void)setMaxLength:(NSInteger)max;

@end
