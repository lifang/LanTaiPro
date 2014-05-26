//
//  BlockLogInAlertView.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-16.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "BlockLogInAlertView.h"

#define kTextBoxHeight      45
#define kTextBoxSpacing     5
#define kTextBoxHorizontalMargin 5

#define kKeyboardResizeBounce         20

@interface BlockLogInAlertView()
@property(nonatomic, copy) TextFieldCallBack callBack;
@end

@implementation BlockLogInAlertView
@synthesize nameTextField,passWordTextField, callBack;


+ (BlockLogInAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message nameTextField:(out UITextField**)nameTxt pwdTextField:(out UITextField**)pwdTxt block:(TextFieldCallBack) block{
    BlockLogInAlertView *prompt = [[[BlockLogInAlertView alloc] initWithTitle:title message:message defaultText:nil block:block] autorelease];
    
    *nameTxt = prompt.nameTextField;
    *pwdTxt = prompt.passWordTextField;
    
    return prompt;
}
- (UITextField *)returnText
{
    UITextField *theTextField = [[[UITextField alloc]initWithFrame:(CGRect){45, 3, 205 , 40}]autorelease];
    theTextField.borderStyle = UITextBorderStyleNone;
    [theTextField setTextAlignment:NSTextAlignmentLeft];
    theTextField.textColor = [UIColor whiteColor];
    [theTextField setClearButtonMode:UITextFieldViewModeAlways];
    [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [theTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    theTextField.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:18];
    theTextField.delegate = self;
    return theTextField;
}
- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block: (TextFieldCallBack) block {
    
    self = [super initWithTitle:title message:message];
    
    if (self) {
        
        self.nameView = [[[UIView alloc]initWithFrame:CGRectMake(kTextBoxHorizontalMargin, _height, _view.bounds.size.width - kTextBoxHorizontalMargin * 2, kTextBoxHeight)] autorelease];
        self.nameView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"log-name-normal"]];
        
        UITextField *theTextField = [self returnText];
        theTextField.placeholder = @"输入帐号";
        theTextField.returnKeyType = UIReturnKeyNext;
        [self.nameView addSubview:theTextField];
        self.nameTextField = theTextField;
        [_view addSubview:self.nameView];
        
        _height += kTextBoxHeight + kTextBoxSpacing;
        
        self.passWordView = [[[UIView alloc]initWithFrame:CGRectMake(kTextBoxHorizontalMargin, _height, _view.bounds.size.width - kTextBoxHorizontalMargin * 2, kTextBoxHeight)] autorelease];
        self.passWordView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"log-password-normal"]];
        
        UITextField *theTextField2 = [self returnText];
        theTextField2.placeholder = @"输入密码";
        theTextField2.secureTextEntry = YES;
        theTextField2.returnKeyType = UIReturnKeyDone;
        [self.passWordView addSubview:theTextField2];
        self.passWordTextField = theTextField2;
        [_view addSubview:self.passWordView];
        
        _height += kTextBoxHeight + kTextBoxSpacing;
        
        self.callBack = block;
    }
    
    return self;
}
- (void)show {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [super show];
    
    [self.nameTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    __block CGRect frame = _view.frame;
    
    if (frame.origin.y + frame.size.height > screenHeight - keyboardSize.height) {
        
        frame.origin.y = screenHeight - keyboardSize.height - frame.size.height;
        
        if (frame.origin.y < 0)
            frame.origin.y = 0;
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _view.frame = frame;
                         }
                         completion:nil];
    }
}


- (void)setAllowableCharacters:(NSString*)accepted {
    unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:accepted] invertedSet];
    self.nameTextField.delegate = self;
    self.passWordTextField.delegate = self;
}

- (void)setMaxLength:(NSInteger)max {
    maxLength = max;
    self.nameTextField.delegate = self;
    self.passWordTextField.delegate = self;
}

#pragma mark - textField代理
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        self.nameView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-name-active"]];
        self.passWordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-password-normal"]];
    }else {
        self.nameView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-name-normal"]];
        self.passWordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-password-active"]];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        self.nameView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-name-normal"]];
    }else {
        self.passWordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"log-password-normal"]];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)_textField{
    
    if ([_textField isEqual:self.nameTextField]) {
        [self.nameTextField resignFirstResponder];
        [self.passWordTextField becomeFirstResponder];
    }else {
        [self.passWordTextField resignFirstResponder];
        if(callBack){
            return callBack(self);
        }
    }
    
    return NO;
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [self.nameTextField.text length] + [string length] - range.length;
    
    if (maxLength > 0 && newLength > maxLength)
        return NO;
    
    if (!unacceptedInput)
        return YES;
    
    if ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] > 1)
        return NO;
    else
        return YES;
}
*/
- (void)dealloc
{
    self.callBack = nil;
    [super dealloc];
}

@end
