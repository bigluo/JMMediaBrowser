//
//  JMMediaBrowserTranslation.h
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/9.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 自定义模态转场动画对象
 */
@interface JMMediaBrowserTranslation : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic,assign) BOOL mediaBrowserShow;//浏览器是显示还是隐藏

@property (nonatomic,assign) CGRect backViewFrame;//退回时的image的frame
@end
