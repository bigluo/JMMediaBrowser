//
//  JMVideoBaseCollectionView.h
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/11.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface JMVideoBaseCollectionView : UICollectionViewCell

- (void)addPlayerLayer:(AVPlayerLayer *)playerLayer;
- (void)changeSliderValue:(CGFloat)value currentTime:(NSString *)currenTimeValue;

- (void)showActivity;
- (void)hideActivity;

@end
