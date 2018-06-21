//
//  JMMediaBrowserTranslation.m
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/9.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "JMMediaBrowserTranslation.h"
#import "JMMediaBrowser.h"
#import "JMHeader.h"
@interface JMMediaBrowserTranslation()
{
    __weak JMMediaBrowser *browser;
}
@property (nonatomic, strong) UIImageView *animateImageView;
@end
@implementation JMMediaBrowserTranslation

//

/**
 * 转场时长
 *
 * @param transitionContext <#transitionContext description#>
 *
 * @return <#return value description#>
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
    
}

//代理方法-转场动画的代码
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //transitionContext:转场上下文
    //转场过程中显示的view，所有动画控件都应该加在这上面
    //这就是那个所谓的载体
    UIView* containerView = [transitionContext containerView];
    //在这里把要做动画效果的控件往containerView上面加
    /**
     containerView是动画过程中提供的暂时容器。
     fromView是转场开始页的视图。
     toView是转场结束页的视图。
     */
    //开始开心的做动画
    //最后，在动画完成的时候，记得标识转场结束[transitionContext completeTransition:YES];
    
    
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromController.view;
    UIView *toView = toController.view;
    
    if (self.mediaBrowserShow) {
        if (toController.isBeingPresented) {
        [self inAnimation_showWithContext:transitionContext containerView:containerView toView:toView];
        }
    }else{
        if (fromController.isBeingDismissed){
            [self inAnimation_hideWithContext:transitionContext containerView:containerView toView:toView];
        }
    }

    //入场动效
//    if (toController.isBeingPresented) {
//        //大多数情况下我们都是对toView作各种变换操作,需要先把它放到container上才能显示出来
//        [containerView addSubview:toView];
//        [[transitionContext containerView] bringSubviewToFront:fromView];
//        NSTimeInterval duration = [self transitionDuration:transitionContext];
//
//        [UIView animateWithDuration:duration animations:^{ fromView.alpha = 0.0; fromView.transform = CGAffineTransformMakeScale(0.2, 0.2); toView.alpha = 1.0;
//        } completion:^(BOOL finished) {
//            fromView.transform = CGAffineTransformMakeScale(1, 1); [transitionContext completeTransition:YES];
//
//        }];
//    }
//        switch (browser.inAnimation) {
//            case YBImageBrowserAnimationMove: {
//                [self inAnimation_moveWithContext:transitionContext containerView:containerView toView:toView];
//            }
//                break;
//            case YBImageBrowserAnimationFade: {
//                [self inAnimation_fadeWithContext:transitionContext containerView:containerView toView:toView];
//            }
//                break;
//            default:
//                [self inAnimation_noWithContext:transitionContext];
//                break;
//        }
//    }
    
}


/**
 转场进入动画

 @param transitionContext <#transitionContext description#>
 @param containerView <#containerView description#>
 @param toView <#toView description#>
 */
- (void)inAnimation_showWithContext:(id <UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView toView:(UIView *)toView {
    //是否被打断
    //    BOOL wasCancelled = [transitionContext transitionWasCancelled];
    
        //大多数情况下我们都是对toView作各种变换操作,需要先把它放到container上才能显示出来
        [containerView addSubview:toView];
      //  [[transitionContext containerView] bringSubviewToFront:fromView];
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        
//        [UIView animateWithDuration:duration animations:^{ fromView.alpha = 0.0; fromView.transform = CGAffineTransformMakeScale(0.2, 0.2); toView.alpha = 1.0;
//        } completion:^(BOOL finished) {
//            fromView.transform = CGAffineTransformMakeScale(1, 1); [transitionContext completeTransition:YES];
//
//        }];
    
    __block CGRect fromFrame = CGRectZero;
    __block UIImage *image = nil;
//    [self in_getShowInfoFromBrowser:browser complete:^(CGRect _fromFrame, UIImage *_fromImage) {
//        fromFrame = _fromFrame;
//        image = _fromImage;
//    }];
//    if (CGRectEqualToRect(fromFrame, CGRectZero) || !image) {
//        [self inAnimation_fadeWithContext:transitionContext containerView:containerView toView:toView];
//        return;
//    }
    __block CGRect toFrame = CGRectZero;
//    [YBImageBrowserCell countWithContainerSize:containerView.bounds.size image:image screenOrientation:browser.so_screenOrientation verticalFillType:browser.verticalScreenImageViewFillType horizontalFillType:browser.horizontalScreenImageViewFillType completed:^(CGRect imageFrame, CGSize contentSize, CGFloat minimumZoomScale, CGFloat maximumZoomScale) {
//        toFrame = imageFrame;
//    }];

    [containerView addSubview:toView];
    image = [UIImage imageNamed:@"photo_3.jpg"];
    self.animateImageView.image = image;
    self.animateImageView.frame = CGRectMake(50, 50, 50, 100);
//    self.animateImageView.frame = fromFrame;
//    [containerView addSubview:self.animateImageView];
//
//    toView.alpha = 0;
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        toView.alpha = 1;
//        self.animateImageView.center = CGPointMake(JMSCREEN_WIDTH/2, JMSCREEN_HEIGHT/2);
//        self.animateImageView.jm_size = CGSizeMake(JMSCREEN_WIDTH, JMSCREEN_WIDTH*9/16);
////        self.animateImageView.frame = toFrame;
//    } completion:^(BOOL finished) {
//        [transitionContext completeTransition:YES];
////        [self completeTransition:transitionContext];
//    }];
    [transitionContext completeTransition:YES];
    //告诉所在的转场环境对象已经结束
    

    
}


/**
 转场淡出动画

 @param transitionContext <#transitionContext description#>
 @param containerView <#containerView description#>
 @param toView <#toView description#>
 */
- (void)inAnimation_hideWithContext:(id <UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView toView:(UIView *)toView {
    
}

- (UIImageView *)animateImageView {
    if (!_animateImageView) {
        _animateImageView = [UIImageView new];
        _animateImageView.contentMode = UIViewContentModeScaleAspectFill;
        _animateImageView.layer.masksToBounds = YES;
    }
    return _animateImageView;
}

@end
