//
//  JMPhotoCollectionCell.h
//  KidRobot
//
//  Created by Mac on 2018/4/18.
//  Copyright © 2018年 qiwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMMediaModel.h"
#import "JMProgressView.h"
#import "JMPhotoBaseCollectionCell.h"


@interface JMPhotoCollectionCell : JMPhotoBaseCollectionCell
@property (nonatomic, strong) UIImageView *showImageView;

@property (nonatomic, copy) void (^singleTapBlock)();

- (void)setShowImage:(UIImage *)image imageRect:(CGRect)imageRect animation:(BOOL)animation;

- (void)showProgressViewWithSchedule:(CGFloat)schedule;
@end
