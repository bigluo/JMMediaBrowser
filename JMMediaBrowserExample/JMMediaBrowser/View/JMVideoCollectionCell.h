//
//  JMVideoCollectionCell.h
//  KidRobot
//
//  Created by Mac on 2018/4/18.
//  Copyright © 2018年 qiwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JMVideoBaseCollectionCell.h"

@class JMMediaModel;
@class JMVideoService;
@interface JMVideoCollectionCell : JMVideoBaseCollectionCell

@property (strong, nonatomic)  UIButton *playOrPauserBtn;

- (void)showActivity;
- (void)hideActivity;
- (void)addPlayerLayer:(AVPlayerLayer *)playerLayer;
- (void)changeSliderValue:(CGFloat)value currentTime:(NSString *)currenTimeValue;
//- (void)pause;


@property (copy, nonatomic) void (^sliderChangeBlock)(CGFloat changeValue);

@property (copy, nonatomic) void (^playOrPauseBlock)(BOOL play);

//@property (strong, nonatomic) NSTimer *timer;
- (void)loadView;
@end
