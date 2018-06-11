//
//  UIView+JMExtension.h
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/3.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JMExtension)
@property (nonatomic, assign) CGFloat jm_x;
@property (nonatomic, assign) CGFloat jm_y;
@property (nonatomic, assign) CGFloat jm_width;
@property (nonatomic, assign) CGFloat jm_height;
@property (nonatomic, assign) CGFloat jm_centerX;
@property (nonatomic, assign) CGFloat jm_centerY;
@property (nonatomic, assign) CGSize  jm_size;
@property (nonatomic, assign) CGPoint jm_origin;


#pragma mark - Activity indicator
//- (void)jm_setIndicatorStyle:(UIActivityIndicatorViewStyle)style;
- (void)jm_showActivityIndicatorView;
//- (void)jm_addActivityIndicator;
- (void)jm_removeActivityIndicator;

#pragma mark - ProgressView
- (void)jm_showProgressViewWithSchedule:(CGFloat)schedule;
//- (void)jm_showProgressViewWithSchedule:(CGFloat)schedule;
- (void)jm_removeProgressView;



@end





