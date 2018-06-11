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
@interface JMPhotoCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *showImageView;
- (void)showActivity;
- (void)hideActivity;

- (void)setPlaceholderImage:(NSString *)imageURL;

- (void)setShowImage:(UIImage *)image imageRect:(CGRect)imageRect animation:(BOOL)animation;

- (void)showProgressViewWithSchedule:(CGFloat)schedule;
@end
