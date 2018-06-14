//
//  JMMediaBrowserTranslation.m
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/9.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "JMMediaBrowserTranslation.h"
#import "JMMediaBrowser.h"
@interface JMMediaBrowserTranslation()
{
    __weak JMMediaBrowser *browser;
}
@end
@implementation JMMediaBrowserTranslation
//代码方法-转场时长
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
    //开始开心的做动画
    //最后，在动画完成的时候，记得标识转场结束
    [transitionContext completeTransition:YES];
    
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromController.view;
    UIView *toView = toController.view;
    
    //入场动效
    if (toController.isBeingPresented) {
        [containerView addSubview:toView];
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
    }
    
}

//
//- (void)inAnimation_moveWithContext:(id <UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView toView:(UIView *)toView {
//
//    __block CGRect fromFrame = CGRectZero;
//    __block UIImage *image = nil;
//    [self in_getShowInfoFromBrowser:browser complete:^(CGRect _fromFrame, UIImage *_fromImage) {
//        fromFrame = _fromFrame;
//        image = _fromImage;
//    }];
////    if (CGRectEqualToRect(fromFrame, CGRectZero) || !image) {
////        [self inAnimation_fadeWithContext:transitionContext containerView:containerView toView:toView];
////        return;
////    }
//    __block CGRect toFrame = CGRectZero;
//    [YBImageBrowserCell countWithContainerSize:containerView.bounds.size image:image screenOrientation:browser.so_screenOrientation verticalFillType:browser.verticalScreenImageViewFillType horizontalFillType:browser.horizontalScreenImageViewFillType completed:^(CGRect imageFrame, CGSize contentSize, CGFloat minimumZoomScale, CGFloat maximumZoomScale) {
//        toFrame = imageFrame;
//    }];
//
//    [containerView addSubview:toView];
//    self.animateImageView.image = image;
//    self.animateImageView.frame = fromFrame;
//    [containerView addSubview:self.animateImageView];
//
//    toView.alpha = 0;
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        toView.alpha = 1;
//        self.animateImageView.frame = toFrame;
//    } completion:^(BOOL finished) {
//        [self completeTransition:transitionContext isIn:YES];
//    }];
//}

@end
