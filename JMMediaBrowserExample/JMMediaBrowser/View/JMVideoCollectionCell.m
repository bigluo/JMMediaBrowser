//
//  JMVideoCollectionCell.m
//  KidRobot
//
//  Created by Mac on 2018/4/18.
//  Copyright © 2018年 qiwo. All rights reserved.
//

#import "JMVideoCollectionCell.h"
#import "JMVideoManager.h"

#import "JMHeader.h"

@interface JMVideoCollectionCell()
{
    
}
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@property (strong, nonatomic) UIView *playerBG;

@property(nonatomic,strong) UIActivityIndicatorView *activity; // 系统菊花

@property (nonatomic, strong) UIView *playerBottomView;

@property(nonatomic,strong) UISlider *scheduleSlider; // 系统菊花

@property(nonatomic,strong) UILabel *totalTimeLabel;

@property(nonatomic,strong) UILabel *currentTimeLabel;

@end
@implementation JMVideoCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
//        [self addGestureRecognizer:self.doubleTap];
    }
    return self;
    
}

- (void)createUI{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [self initSubView];
}

- (void)addPlayerLayer:(AVPlayerLayer *)playerLayer{
    self.playOrPauserBtn.selected = YES;
     [self.playerBG.layer insertSublayer:playerLayer below:_playerBottomView.layer];
}


- (void)initSubView{
    
    self.playerBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JMSCREEN_WIDTH, JMSCREEN_WIDTH * 24/32)];
    self.playerBG.center = self.contentView.center;
    [self.contentView addSubview:_playerBG];
    
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.contentView addSubview:_activity];
    
    self.activity.center = CGPointMake(JMSCREEN_WIDTH/2, JMSCREEN_HEIGHT/2); //self.center;//CGPointMake(100, 100);//self.contentView.center;
    self.activity.hidesWhenStopped = YES;
    
    
    self.playerBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.playerBG.frame.size.height - 35, self.playerBG.frame.size.width, 35)];
    [self.playerBG addSubview:_playerBottomView];
    
    self.playOrPauserBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 35)];
    [self.playerBottomView addSubview:_playOrPauserBtn];
    [self.playOrPauserBtn setImage:[UIImage imageNamed:@"video_play_left"] forState:UIControlStateNormal];
    [self.playOrPauserBtn setImage:[UIImage imageNamed:@"video_pause_left"] forState:UIControlStateSelected];
    [self.playOrPauserBtn addTarget:self action:@selector(playOrPauserAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.playOrPauserBtn.frame), 0, 40, 35)];
    [self.playerBottomView addSubview:_currentTimeLabel];
    self.currentTimeLabel.text = @"00:00";
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.font = [UIFont systemFontOfSize:12];
    self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    self.totalTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_playerBottomView.frame.size.width - 40, 0, 40, 35)];
    [self.playerBottomView addSubview:_totalTimeLabel];
    self.totalTimeLabel.text = @"00:00";
    self.totalTimeLabel.textColor = [UIColor whiteColor];
    self.totalTimeLabel.font = [UIFont systemFontOfSize:12];
    self.currentTimeLabel.textAlignment = NSTextAlignmentRight;
    
    CGFloat slideViewWidth = self.playerBottomView.frame.size.width - 40 - CGRectGetMaxX(_currentTimeLabel.frame);
    
    self.scheduleSlider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_currentTimeLabel.frame), 0, slideViewWidth, 35)];
    [self.playerBottomView addSubview:_scheduleSlider];
    self.scheduleSlider.maximumTrackTintColor = [UIColor whiteColor];
//    self.scheduleSlider.minimumTrackTintColor = [ThemeStyle getThemeColor];
    self.scheduleSlider.value = 0;
    [self.scheduleSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)showActivity{
    [self.activity startAnimating];
}

- (void)hideActivity{
    [self.activity stopAnimating];
}

- (void)playOrPauserAction:(UIButton *)button{
    button.selected = !button.selected;
    if (self.playOrPauseBlock) {
        self.playOrPauseBlock(button.selected);
    }
}

- (void)changeSliderValue:(CGFloat)value currentTime:(NSString *)currenTimeValue{
    self.scheduleSlider.value = value;
    self.currentTimeLabel.text = currenTimeValue;
}



- (void)sliderValueChange:(UISlider *)slider{
    JMLog(@"sliderValueChange:%f",slider.value);
    if (self.sliderChangeBlock) {
        self.sliderChangeBlock(slider.value);
    }
}

@end
