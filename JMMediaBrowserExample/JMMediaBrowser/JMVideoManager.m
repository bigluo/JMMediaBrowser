//
//  JMVideoService.m
//  KidRobot
//
//  Created by Mac on 2018/4/19.
//  Copyright © 2018年 qiwo. All rights reserved.
//

#import "JMVideoManager.h"
#import "JMMediaModel.h"
#import "JMVideoCollectionCell.h"
#import "JMHeader.h"




@interface JMVideoManager()
/** 播放模型 */
@property(nonatomic, strong) JMMediaModel *mediaModel;
/** 播放属性 */
@property (nonatomic, strong) AVPlayer               *player;
@property (nonatomic, strong) AVPlayerItem           *playerItem;
@property (nonatomic, strong) AVPlayerLayer          *playerLayer;
/** 预览图 */
@property (nonatomic, strong) UIImageView            *previewImageView;
/** 视频填充模式 */
@property (nonatomic, copy)   NSString                 *videoGravity;
/** 是否本地文件*/
@property (nonatomic, assign) BOOL                  isLocalVideo;
/** 主动停止*/
@property (nonatomic, assign) BOOL               initiativePause;

@property (nonatomic, strong) id                     timeObserve;

@property (nonatomic, strong)  NSString *seekTime;

@property (nonatomic, strong)  NSString *videoUrlStr;

@property (nonatomic, strong)  NSString *videoDocumentPath;

@end


@interface JMVideoManager(Helper)
- (CGSize)getVideoSizeWithAsset:(AVURLAsset *)asset;
- (UIImage* )thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
- (NSTimeInterval)availableDuration;
@end

@implementation JMVideoManager(Helper)
/**
 *  方法说明  ->  获取视频尺寸
 *  参数说明  ->  asset:urlAsset对象
 *  返回说明  ->  对应的尺寸
 */
- (CGSize)getVideoSizeWithAsset:(AVURLAsset *)asset{
    NSArray *array = asset.tracks;
    CGSize videoSize = CGSizeZero;
    
    for (AVAssetTrack *track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    JMLog(@"视频尺寸大小%@",[NSValue valueWithCGSize:videoSize]);
    return videoSize;
}

/**
 *  方法说明  ->  获取视频对应时间的图片
 *  参数说明  ->  videoURL:视频url，time:时间
 *  返回说明  ->  对应的图片
 */
- (UIImage* )thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    //   thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 1)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : [UIImage imageNamed:@"com_photoFail"];
    
    return thumbnailImage;
}


- (NSTimeInterval)availableDuration{
    
    //当前视频的，加载时间
    NSArray *timeRange = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange cmTimeRange = [timeRange.firstObject CMTimeRangeValue];
    
    //缓冲区间
    float startSecond = CMTimeGetSeconds(cmTimeRange.start);
    float durationSecond = CMTimeGetSeconds(cmTimeRange.duration);
    
    //计算
    NSTimeInterval result = startSecond + durationSecond;
    return result;
}
@end

@implementation JMVideoManager

- (NSString *)videoGravity {
    if (!_videoGravity) {
        _videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _videoGravity;
}



- (void)playWithModel:(JMMediaModel *)model
              success:(JMVideoSuccessBlock)success
              failure:(JMVideoFailureBlock)failure{
    NSAssert(model != nil, @"传入参数model不能为空");
    _playVideoSuccessBlock = success;
    _playVideoFailureBlock = failure;
    _mediaModel = model;
    [self configPlayer];
}

#pragma mark - 配置Player
- (void)configPlayer{
    if (self.player){
        [self resetPlayer];
    }
    // 配置系统音量
    [self configureVolume];
    
    //创建player属性
    NSURL *videoURL = [NSURL URLWithString:_mediaModel.mediaURLString];
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];

    self.playerItem = [AVPlayerItem playerItemWithURL:videoURL];//网络
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    self.playerLayer.videoGravity = self.videoGravity;
    
    //获取视频尺寸
    CGSize videoSize = [self getVideoSizeWithAsset:asset];
    self.playerLayer.frame = CGRectMake(0, 0,JMSCREEN_WIDTH,JMSCREEN_WIDTH/(videoSize.width/videoSize.height));
    
    //是否本地文件
    if ([videoURL.scheme isEqualToString:@"file"]) {
        self.isLocalVideo = YES;
    } else {
        self.isLocalVideo = NO;
    }
    
    self.initiativePause = NO;
    if (_isAutoPlay){
        [_player play];
    }
    
//    if (self.avPlayerStatusBlock) {
//        self.avPlayerStatusBlock(MoviePlayerPlayStatusPlay);
//    }
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    if (self.playVideoSuccessBlock) {
        self.playVideoSuccessBlock(self.playerLayer);
    }

    
    //[self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    //计时器
    if (_scheduletimer) {
        [_scheduletimer invalidate];
        _scheduletimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(Stack) userInfo:nil repeats:YES];
        [_scheduletimer fire];
        
    }else{
        _scheduletimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(Stack) userInfo:nil repeats:YES];
        [_scheduletimer fire];
    }
}

/**
 *  添加观察者、通知
 */
- (void)addNotifications {
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监听耳机插入和拔掉通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    // 监测设备方向
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onDeviceOrientationChange)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onStatusBarOrientationChange)
//                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
//                                               object:nil];
}

- (void)createTimer {
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;//0~1
            
        }
    }];
}

/**
 *  获取系统音量
 */
- (void)configureVolume {
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
//    NSError *setCategoryError = nil;
//    BOOL success = [[AVAudioSession sharedInstance]
//                    setCategory: AVAudioSessionCategoryPlayback
//                    error: &setCategoryError];
//
//    if (!success) { /* handle the error in setCategoryError */ }
}

- (void)generatePreviewImageView:(JMMediaModel *)model{
//    dispatch_queue_t concurrentQueue =
//    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(concurrentQueue, ^{
//        __block UIImage *image = nil;
//        dispatch_sync(concurrentQueue, ^{
//            if (self.isLocalVideo) {
//                image =  [self thumbnailImageForVideo:[NSURL fileURLWithPath:model.mediaURL] atTime:2];
//            }else{
//                image =  [self thumbnailImageForVideo:[NSURL URLWithString:model.mediaURL] atTime:2];
//            }
//        });
    
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            if(self.chatModel.chat_type == ChatType_video){
//                [self.imageButton setImage:image forState:UIControlStateNormal];
//                [self.imageButton setImage:image forState:UIControlStateHighlighted];
//            }
//        });
//     });
}




#pragma mark - 播放控制
/**
 *  手动播放
 */
- (void)manualPlay{
    self.initiativePause = NO;
    [self play];
}

/**
 *  手动暂停
 */
- (void)manualPause{
    self.initiativePause = YES;
    [self pause];
}

/**
 * 播放
 */
- (void)play{
    if (self.player == nil || self.mediaModel == nil){
        JMLog(@"操作失败，数据为空");
    }
    [self.player play];
}

/**
 * 暂停
 */
- (void)pause{
    [self.player pause];
}

- (void)resetPlayer{
//    if (self.timeObserve) {
//        [self.player removeTimeObserver:self.timeObserve];
//        self.timeObserve = nil;
//    }
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self pause];
    [self.playerLayer removeFromSuperlayer];
    //全部属性置nil

    self.seekTime    = 0;
    self.muted = NO;
    self.isAutoPlay  = NO;
    self.initiativePause = NO;
    self.playerLayer = nil;
    self.mediaModel  = nil;
    self.playerItem  = nil;
    self.player      = nil;
    [self.timeObserve invalidate];
    self.timeObserve = nil;
}

- (void)setStatus:(JMPlayerStatus)status{
    _status = status;
    if (self.avPlayerStatusBlock) {
        self.avPlayerStatusBlock(status);
    }
}

- (void)setMuted:(BOOL)muted{
    _muted =muted;
    self.player.muted = muted;
}
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"observeValueForKeyPath:%@,%@,%@",keyPath,object,change);
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
               
                // 跳到xx秒播放视频
//                if (self.seekTime) {
//                    [self seekToTime:self.seekTime completionHandler:nil];
//                }
//                self.player.muted = self.muted;
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration             = self.playerItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            // 当缓冲是空的时候
//            if (self.playerItem.playbackBufferEmpty) {
//                self.state = ZFPlayerStateBuffering;
//                [self bufferingSomeSecond];
//            }
            
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            
            // 当缓冲好的时候
//            if (self.playerItem.playbackLikelyToKeepUp && self.state == ZFPlayerStateBuffering){
//                self.state = ZFPlayerStatePlaying;
//            }
        }
    }
}

#pragma mark - 计时器事件
- (void)Stack
{
    if (_playerItem.duration.timescale != 0) {
        
        CGFloat sliderValue = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);
        
//        _slideView.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);//当前进度
//        _slideLanView.value = _slideView.value;
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
        //duration 总时长
        
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        //        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", proMin, proSec, durMin, durSec];
        NSString *currentTimeValue =  [NSString stringWithFormat:@"%01ld:%02ld", proMin, proSec];
        
       
//        self.currentTimeLabel.text = [NSString stringWithFormat:@"%01ld:%02ld", proMin, proSec];
//        self.currentTimeLanLabel.text = self.currentTimeLabel.text;
//    [self.cell changeSliderValue:sliderValue currentTime:currentTimeValue];
//    }
//    if (_player.status == AVPlayerStatusReadyToPlay) {
//        [self.cell hideActivity];
//    } else {
//        [self.cell showActivity];
//    }
    }
    
}

- (void)moviePlayDidEnd{
//    [self changedPlayerStatus:JMPlayerStatusFinish];
}


- (void)changeProgress:(CGFloat)progressValue{
    //拖动改变视频播放进度
    if (_player.status == AVPlayerStatusReadyToPlay) {
        //    //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        NSInteger dragedSeconds = floorf(total * progressValue);
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [_player pause];
        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            [_player play];
        }];
        
    }
}

@end

