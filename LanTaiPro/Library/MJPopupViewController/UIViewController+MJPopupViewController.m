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
#define kMJSourceViewTag 23941
#define kMJPopupViewTag 23942
#define kMJBackgroundViewTag 23943
#define kMJOverlayViewTag 23945

//弹出试图左边的起点
static CGFloat startWidth = 0;

@interface UIViewController (MJPopupViewControllerPrivate)
- (UIView*)topView;
@end

////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

@implementation UIViewController (MJPopupViewController)

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(MJPopupViewAnimation)animationType width:(CGFloat)width
{
    [self presentPopupView:popupViewController.view animationType:animationType width:width];
}

- (void)dismissPopupViewControllerWithanimationType:(MJPopupViewAnimation)animationType  dismissBlock:(DismissCallBack)dismissBlock
{
    UIView *sourceView = [self topView];
    UIView *popupView = [sourceView viewWithTag:kMJPopupViewTag];
    UIView *overlayView = [sourceView viewWithTag:kMJOverlayViewTag];
    
    if(animationType == MJPopupViewAnimationSlideBottomTop || animationType == MJPopupViewAnimationSlideBottomBottom || animationType == MJPopupViewAnimationSlideRightLeft) {
        [self slideViewOut:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType dismissBlock:dismissBlock];
    } else {
        [self fadeViewOut:popupView sourceView:sourceView overlayView:overlayView];
    }
}


////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Handling

- (void)presentPopupView:(UIView*)popupView animationType:(MJPopupViewAnimation)animationType width:(CGFloat)width
{
    startWidth = width;
    UIView *sourceView = [self topView];
    sourceView.tag = kMJSourceViewTag;
    popupView.tag = kMJPopupViewTag;
    
    // check if source view controller is not in destination
    if ([sourceView.subviews containsObject:popupView]) return;
    
    // customize popupView
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    
    // Add semi overlay
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.tag = kMJOverlayViewTag;
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
    } else if (animationType == MJPopupViewAnimationSlideRightLeft) {
        [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
    } else if (animationType == MJPopupViewAnimationSlideBottomBottom) {
        [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
    } else {
        [self fadeViewIn:popupView sourceView:sourceView overlayView:overlayView];
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
    UIView *backgroundView = [overlayView viewWithTag:kMJBackgroundViewTag];
    // Generating Start and Stop Positions
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
    UIView *backgroundView = [overlayView viewWithTag:kMJBackgroundViewTag];
    // Generating Start and Stop Positions
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
        backgroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        
        if (dismissBlock) {
            dismissBlock(finished);
        }
        
    }];
}

#pragma mark --- Fade

- (void)fadeViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    UIView *backgroundView = [overlayView viewWithTag:kMJBackgroundViewTag];
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2, 
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width, 
                                     popupSize.height);
    
    // Set starting properties
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        backgroundView.alpha = 0.5f;
        popupView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- (void)fadeViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    UIView *backgroundView = [overlayView viewWithTag:kMJBackgroundViewTag];
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        backgroundView.alpha = 0.0f;
        popupView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
    }];
}


@end
