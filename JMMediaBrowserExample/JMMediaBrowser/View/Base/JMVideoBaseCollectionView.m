//
//  JMVideoBaseCollectionView.m
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/11.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "JMVideoBaseCollectionView.h"
#import "JMVideoManager.h"
#import "JMHeader.h"



@interface JMVideoBaseCollectionView()

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) UIView *playerContentView;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIView *playerBottomView;

@property (nonatomic, strong) UIButton *playCenterButton;

@property (nonatomic, strong) UIButton *playOrPauseButton;

@property (nonatomic, strong) UISlider *scheduleSlider;

@property (nonatomic, strong) UILabel *totalTimeLabel;

@property (nonatomic, strong) UILabel *currentTimeLabel;

@end

@implementation JMVideoBaseCollectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
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
    self.playOrPauseButton.selected = YES;
    [self.playerContentView.layer insertSublayer:playerLayer below:_playerBottomView.layer];
}

//
//- (void)setPlayStatus:(){
//    self.playOrPauserButton.selected = YES;
//}


- (void)initSubView{
    self.playerContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JMSCREEN_WIDTH, JMSCREEN_WIDTH * 24/32)];
    self.playerContentView.center = self.contentView.center;
    [self.contentView addSubview:_playerContentView];
    
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.contentView addSubview:_activity];
    
    self.activity.center = CGPointMake(JMSCREEN_WIDTH/2, JMSCREEN_HEIGHT/2); //self.center;//CGPointMake(100, 100);//self.contentView.center;
    self.activity.hidesWhenStopped = YES;
    
    
    self.playerBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.playerContentView.frame.size.height - 35, self.playerContentView.frame.size.width, 35)];
    [self.playerContentView addSubview:_playerBottomView];
    
    self.playOrPauseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 35)];
    [self.playerBottomView addSubview:_playOrPauseButton];
    [self.playOrPauseButton setImage:[UIImage imageNamed:@"video_play_left"] forState:UIControlStateNormal];
    [self.playOrPauseButton setImage:[UIImage imageNamed:@"video_pause_left"] forState:UIControlStateSelected];
    [self.playOrPauseButton addTarget:self action:@selector(playOrPauserAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.playOrPauseButton.frame), 0, 40, 35)];
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


@end
