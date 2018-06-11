//
//  UIView+JMExtension.m
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/3.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "UIView+JMExtension.h"
#import "JMProgressView.h"
#import <objc/runtime.h>

@implementation UIView (JMExtension)

-(void)setJm_x:(CGFloat)jm_x{
    CGRect frame = self.frame;
    frame.origin.x = jm_x;
    self.frame = frame;
}

- (void)setJm_y:(CGFloat)jm_y
{
    CGRect frame = self.frame;
    frame.origin.y = jm_y;
    self.frame = frame;
}

- (CGFloat)jm_y
{
    return self.frame.origin.y;
}

- (void)setJm_width:(CGFloat)jm_width
{
    CGRect frame = self.frame;
    frame.size.width = jm_width;
    self.frame = frame;
}

- (CGFloat)jm_width
{
    return self.frame.size.width;
}

- (void)setJm_height:(CGFloat)jm_height
{
    CGRect frame = self.frame;
    frame.size.height = jm_height;
    self.frame = frame;
}

- (CGFloat)jm_height
{
    return self.frame.size.height;
}

-(void)setJm_centerX:(CGFloat)jm_centerX{
    CGPoint center = self.center;
    center.x = jm_centerX;
    self.center = center;
}

-(CGFloat)jm_centerX{
    return self.center.x;
}

-(void)setJm_centerY:(CGFloat)jm_centerY{
    CGPoint center = self.center;
    center.y = jm_centerY;
    self.center = center;
}

-(CGFloat)jm_centerY{
    return self.center.y;
}

- (void)setJm_size:(CGSize)jm_size
{
    CGRect frame = self.frame;
    frame.size = jm_size;
    self.frame = frame;
}

- (CGSize)jm_size
{
    return self.frame.size;
}

- (void)setJm_origin:(CGPoint)jm_origin
{
    CGRect frame = self.frame;
    frame.origin = jm_origin;
    self.frame = frame;
}

- (CGPoint)jm_origin
{
    return self.frame.origin;
}

#pragma mark - ProgressView
static const char JMProgressViewKey = '\0';

- (JMProgressView *)JM_ProgressView{
    return (JMProgressView *)objc_getAssociatedObject(self, &JMProgressViewKey);
}

- (void)setJM_ProgressView:(JMProgressView *)progressView{
    if (self.JM_ProgressView) {
        [self jm_removeProgressView];
    }
    objc_setAssociatedObject(self, &JMProgressViewKey, progressView, OBJC_ASSOCIATION_RETAIN);
}

- (void)jm_showProgressViewWithSchedule:(CGFloat)schedule{
    
    if (!self.JM_ProgressView) {
        JMProgressView *progressView = [[JMProgressView alloc]init];
        [self insertSubview:progressView atIndex:0];
//        [self addSubview:progressView];
        progressView.center = self.center;
        self.JM_ProgressView = progressView;
    }
    self.JM_ProgressView.progress = schedule;
    self.JM_ProgressView.hidden  = NO;
    
}
- (void)jm_removeProgressView{
    if (self.JM_ProgressView) {
        [self.JM_ProgressView removeFromSuperview];
        self.JM_ProgressView = nil;
    }

//    objc_removeAssociatedObjects(&JMProgressViewKey);
    
}
static const char JMActivityIndicatorViewKey = '\0';

- (UIActivityIndicatorView *)JM_ActivityIndicatorView{
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &JMActivityIndicatorViewKey);
}

- (void)jm_showActivityIndicatorView{
    if (!self.JM_ActivityIndicatorView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.hidesWhenStopped = YES;
        activityView.center = self.center;
        [self addSubview:activityView];
        objc_setAssociatedObject(self, &JMActivityIndicatorViewKey, activityView, OBJC_ASSOCIATION_RETAIN);
    }
    [self.JM_ActivityIndicatorView startAnimating];
}

- (void)jm_removeActivityIndicator{
    if (self.JM_ActivityIndicatorView) {
        [self.JM_ActivityIndicatorView stopAnimating];
//        self.JM_ActivityIndicatorView = nil;
    }
}


@end
