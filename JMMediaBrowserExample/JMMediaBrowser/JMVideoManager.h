//
//  JMVideoService.h
//  KidRobot
//
//  Created by Mac on 2018/4/19.
//  Copyright © 2018年 qiwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class JMMediaModel;
@class JMVideoCollectionCell;

typedef NS_ENUM(NSUInteger,JMPlayerStatus){
    JMPlayerStatusDefault,  //初始化
    JMPlayerStatusFailed,   //失败
    JMPlayerStatusBuffering,//缓冲中
    JMPlayerStatusPlay,     //播放
    JMPlayerStatusPause,    //暂停
    JMPlayerStatusStop,     //停止
    JMPlayerStatusFinish,   //结束
    
};

@protocol JMVideoManagerDelegate <NSObject>
@optional
- (void)jm_playerStatusChange:(JMPlayerStatus)status urlString:(NSString *)urlString;

@end



typedef void (^JMVideoSuccessBlock)(AVPlayerLayer *playerLayer);
typedef void (^JMVideoFailureBlock)(NSString *errMsg);
typedef void (^videoServiceAVPlayStatus)(JMPlayerStatus status);
typedef void (^videoServiceSaveVideoBlock)(BOOL success);

//提供给外部的接口原则就是简单

/**
 JM视频管理类
 */
@interface JMVideoManager : NSObject


/** 自动播放 */
@property (nonatomic,assign) BOOL isAutoPlay;
/** 代理 */
//@property (nonatomic, weak) id<JMVideoManagerDelegate> delegate;

@property (nonatomic, copy) JMVideoSuccessBlock playVideoSuccessBlock;
@property (nonatomic, copy) JMVideoFailureBlock playVideoFailureBlock;

@property (nonatomic, copy) videoServiceAVPlayStatus avPlayerStatusBlock;

@property (nonatomic, copy) NSTimer *scheduletimer;
/** 视频播放状态 */
@property (nonatomic, assign) JMPlayerStatus status;
/** 静音状态  */
@property (nonatomic, assign) BOOL muted;

//@property (nonatomic, assign) BOOL isPlay;

+ (instancetype)shareInstance;

/**
    开始播放
 */
- (void)playWithModel:(JMMediaModel *)model
              success:(JMVideoSuccessBlock)success
              failure:(JMVideoFailureBlock)failure;

/**
 *  手动播放
 */
- (void)manualPlay;

/**
 *  手动暂停
 */
- (void)manualPause;

/**
 * 暂停
 */
- (void)pause;

/**
 * 设置静音
 */
- (void)setMuted:(BOOL)muted;

///**
// 是否在播放中
// */
//- (BOOL)isPlay;

/**
 *  重置player
 */
- (void)resetPlayer;

/**
 改变播放状态
 @param status <#status description#>
 */
//- (void)changedPlayerStatus:(JMPlayerStatus)status;

- (void)changeProgress:(CGFloat)progressValue;





@end
