//
//  UIViewController+MJPopupViewController.m
//  MJModalViewController
//
//  Created by Martin Juhasz on 11.05.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "UIViewController+MJPopupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MJPopupBackgroundView.h"

#define kPopupModalAnimationDuration 0.35
#define kMJSourceViewTag 10000
#define kMJPopupViewTag 20000
#define kMJBackgroundViewTag 30000
#define kMJOverlayViewTag 40000

@interface UIViewController (MJPopupViewControllerPrivate)
- (UIView*)topView;
@end

////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

@implementation UIViewController (MJPopupViewController)

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(MJPopupViewAnimation)animationType width:(CGFloat)width
{
    AppDelegate *appDel = [AppDelegate shareIntance];
    [appDel.popupedControllerArray addObject:self];
    
    [appDel.popupedWidthArray addObject:[NSString stringWithFormat:@"%.4f",width]];
    
    [self presentPopupView:popupViewController.view animationType:animationType width:width];
}

- (void)dismissPopupViewControllerWithanimationType:(MJPopupViewAnimation)animationType  dismissBlock:(DismissCallBack)dismissBlock
{
    AppDelegate *appDel = [AppDelegate shareIntance];
    UIViewController *presentedController = [appDel.popupedControllerArray lastObject];
    
    UIView *sourceView = [presentedController topView];
    UIView *popupView = [sourceView viewWithTag:kMJPopupViewTag+appDel.popupedControllerArray.count];
    UIView *overlayView = [sourceView viewWithTag:kMJOverlayViewTag+appDel.popupedControllerArray.count];
    
    if(animationType == MJPopupViewAnimationSlideBottomTop || animationType == MJPopupViewAnimationSlideBottomBottom || animationType == MJPopupViewAnimationSlideRightLeft) {
        [self slideViewOut:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType dismissBlock:dismissBlock];
    }
}


////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Handling
- (void)presentPopupView:(UIView*)popupView animationType:(MJPopupViewAnimation)animationType width:(CGFloat)width
{
    AppDelegate *appDel = [AppDelegate shareIntance];
    
    UIView *sourceView = [self topView];
    sourceView.tag = kMJSourceViewTag;
    popupView.tag = kMJPopupViewTag+appDel.popupedControllerArray.count;
    
    if ([sourceView.subviews containsObject:popupView]) return;
    
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    
    // Add semi overlay
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.tag = kMJOverlayViewTag+appDel.popupedControllerArray.count;
    overlayView.backgroundColor = [UIColor clearColor];
    
    // BackgroundView
    MJPopupBackgroundView *backgroundView = [[MJPopupBackgroundView alloc] initWithFrame:sourceView.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.tag = kMJBackgroundViewTag;
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.alpha = 0.0f;
    [overlayView addSubview:backgroundView];
    
    popupView.alpha = 0.0f;
    [overlayView addSubview:popupView];
    
    [sourceView addSubview:overlayView];
    
    if(animationType == MJPopupViewAnimationSlideBottomTop) {
        [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
    }
    else if (animationType == MJPopupViewAnimationSlideRightLeft) {
        [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
    }
    else if (animationType == MJPopupViewAnimationSlideBottomBottom) {
        [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
    }
}

-(UIView*)topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}


- (void)dismissPopupViewControllerWithanimationTypeSlideBottomTop
{
    DismissCallBack block;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop dismissBlock:block];
}

- (void)dismissPopupViewControllerWithanimationTypeSlideBottomBottom
{
    DismissCallBack block;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom dismissBlock:block];
}

- (void)dismissPopupViewControllerWithanimationTypeSlideRightLeft
{
    DismissCallBack block;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightLeft dismissBlock:block];
}

- (void)dismissPopupViewControllerWithanimationTypeFade
{
    DismissCallBack block;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade dismissBlock:block];
}



//////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Animations

#pragma mark --- Slide
- (void)slideViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(MJPopupViewAnimation)animationType
{
    AppDelegate *appDel = [AppDelegate shareIntance];
    
    CGFloat startWidth = [[appDel.popupedWidthArray lastObject]floatValue];
    
    UIView *backgroundView = [overlayView viewWithTag:kMJBackgroundViewTag];
    
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupStartRect;
    if(animationType == MJPopupViewAnimationSlideBottomTop || animationType == MJPopupViewAnimationSlideBottomBottom) {
        popupStartRect = CGRectMake(startWidth,
                                    0-popupSize.height,
                                    popupSize.width,
                                    popupSize.height);
    } else {
        popupStartRect = CGRectMake(sourceSize.width,
                                    (sourceSize.height - popupSize.height) / 2,
                                    popupSize.width,
                                    popupSize.height);
    }
    CGRect popupEndRect = CGRectMake(startWidth,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    
    // Set starting properties
    popupView.frame = popupStartRect;
    popupView.alpha = 1.0f;
    [UIView animateWithDuration:kPopupModalAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        backgroundView.alpha = 1.0f;
        popupView.frame = popupEndRect;
    } completion:^(BOOL finished) {
    }];
}

- (void)slideViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(MJPopupViewAnimation)animationType dismissBlock:(DismissCallBack)dismissBlock
{
    AppDelegate *appDel = [AppDelegate shareIntance];
    CGFloat startWidth = [[appDel.popupedWidthArray lastObject]floatValue];
    
    BOOL isDismissBackground = NO;
    UIView *backgroundView = nil;
    if (appDel.popupedControllerArray.count==1) {
        backgroundView = [overlayView viewWithTag:kMJBackgroundViewTag];
        isDismissBackground = YES;
    }
    
    
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect;
    if(animationType == MJPopupViewAnimationSlideBottomTop) {
        popupEndRect = CGRectMake(startWidth,
                                  -popupSize.height,
                                  popupSize.width,
                                  popupSize.height);
    } else if(animationType == MJPopupViewAnimationSlideBottomBottom) {
        popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                  sourceSize.height,
                                  popupSize.width,
                                  popupSize.height);
    } else {
        popupEndRect = CGRectMake(-popupSize.width,
                                  popupView.frame.origin.y,
                                  popupSize.width,
                                  popupSize.height);
    }
    
    [UIView animateWithDuration:kPopupModalAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        popupView.frame = popupEndRect;
        if (isDismissBackground) {
            backgroundView.alpha = 0.0f;
        }
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        [appDel.popupedControllerArray removeLastObject];
        [appDel.popupedWidthArray removeLastObject];
        if (dismissBlock) {
            dismissBlock(finished);
        }
    }];
}


@end
