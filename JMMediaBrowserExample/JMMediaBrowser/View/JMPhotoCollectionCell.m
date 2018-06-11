//
//  JMPhotoCollectionCell.m
//  KidRobot
//
//  Created by Mac on 2018/4/18.
//  Copyright © 2018年 qiwo. All rights reserved.
//

#import "JMPhotoCollectionCell.h"
#import "JMHeader.h"

@interface JMPhotoCollectionCell()<UIScrollViewDelegate>
@property(nonatomic,strong) UIActivityIndicatorView *activity; // 系统菊花

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

@end

@implementation JMPhotoCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self addGestureRecognizer:self.doubleTap];
    }
    return self;
    
}

- (void)showActivity{
    [self.activity startAnimating];
}

- (void)hideActivity{
    [self.activity stopAnimating];
}

- (void)showProgressViewWithSchedule:(CGFloat)schedule{
    [self jm_showProgressViewWithSchedule:schedule];
}

- (void)createUI{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [self initSubView];
}

- (void)initSubView{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.frame = self.contentView.frame;

    [self.contentView addSubview:_scrollView];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.bounces = NO;

    self.showImageView = [[UIImageView alloc]init];
    self.showImageView.jm_size = CGSizeMake(self.scrollView.jm_width, self.scrollView.jm_width*9/16);
    self.showImageView.center = self.contentView.center;
    [self.scrollView addSubview:_showImageView];
}



//- (void)initShowImageView{
//
//    self.showImageView.frame = CGRectZero;
//    self.showImageView = [[UIImageView alloc]init];
//    //    self.showImageView.image = stdImg.imageView.image;
//    //    self.showImageView.contentMode = stdImg.imageView.contentMode;
//    //    self.showImageView.clipsToBounds = stdImg.imageView.clipsToBounds;
//    //    progressView.hidden = YES;
//    if ([self.mediaModel.mediaURL hasPrefix:@"http"]) {
//        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:_mediaModel.mediaURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            [self finishLoadingImage:image animation:NO];;
//        }];
//    }else{
//        NSData *imageData = [NSData dataWithContentsOfFile:self.mediaModel.mediaURL];
//        UIImage *image = [[UIImage alloc]initWithData:imageData];
//        [self finishLoadingImage:image animation:NO];
//    }
//}

//- (void)finishLoadingImage:(UIImage *)image animation:(BOOL)animation
//{
////    progressView.hidden = YES;
//    if (animation) {
//        //如果是gif图片，放大的时候只赋值第一帧放大，完成后在赋值所有帧数。
//        if (image.images.count > 1 ) {
//            self.showImageView.image = [image.images objectAtIndex:0];
//        }else{
//            self.showImageView.image = image;
//        }
//
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.scrollView addSubview:_showImageView];
//            CGRect frame = [self getRectFromImage:image];
//            self.showImageView.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
//            self.showImageView.center = CGPointMake(JMSCREEN_WIDTH/2, JMSCREEN_HEIGHT/2);
//        } completion:^(BOOL finished) {
//            if (image.images.count > 1) {
//                self.showImageView.image = image;
//            }
//        }];
//    }else{
//         [self.scrollView addSubview:_showImageView];
//        CGRect frame = [self getRectFromImage:image];
//        self.showImageView.image = image;
//        self.showImageView.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        self.showImageView.center = CGPointMake(JMSCREEN_WIDTH/2, JMSCREEN_HEIGHT/2);
//    }
//}

#pragma mark - Scare
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
//    NSLog(@"开始zoom");
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
//    NSLog(@"结束zoom");
//}
/*
 图片放大
 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
//    ITLog(@"scrollView.zoomScale:%f",scrollView.zoomScale);
    return _showImageView;
}

/*
 设置图片放大缩小后的中心点
 1、如果缩放后scrollView可以滚动的宽度不大于它当前的宽度，中心点x坐标位置不变。
 2、如果缩放后scrollView可以滚动的高度度不大于它当前的宽度，中心点y坐标位置不变。
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//     ITLog(@"scrollView.zoomScale:%f",scrollView.zoomScale);
    //中心点偏移的x坐标
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    //中心点偏移的y坐标
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    //重设缩放后图片的中心点
    _showImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                      scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)setShowImage:(UIImage *)image imageRect:(CGRect)imageRect animation:(BOOL)animation{
    if (self.scrollView.jm_height < imageRect.size.height) {
        self.scrollView.contentSize = imageRect.size;
    }else{
        if (self.scrollView.contentSize.height != JMSCREEN_HEIGHT) {
            self.scrollView.contentSize = self.scrollView.frame.size;
        }
    }
    if (animation) {
        //如果是gif图片，放大的时候只赋值第一帧放大，完成后在赋值所有帧数。
        //        if (image.images.count > 1 ) {
        //            [self setShowImage:[image.images objectAtIndex:0]];
        //        }else{
        //            [self setShowImage:[image.images objectAtIndex:0]];
        //
        //        }
        
        [UIView animateWithDuration:0.3 animations:^{
            //            [self.scrollView addSubview:_showImageView];
            //            CGRect frame = [self getRectFromImage:image];
            self.showImageView.image = image;
            self.showImageView.bounds = imageRect;
            self.showImageView.center = self.scrollView.center;
        } completion:^(BOOL finished) {
            
            //            if (image.images.count > 1) {
            //                self.showImageView.image = image;
            //            }
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.showImageView.image = image;
            self.showImageView.bounds = imageRect;
            self.showImageView.center = self.scrollView.center;
//            self.showImageView.center = CGPointMake(JMSCREEN_WIDTH/2, JMSCREEN_HEIGHT/2);
        });

    }
}
//会优先滚动里面的scrollView
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
////    self.showImageView.centerX = _scrollView.contentOffset.x;
//    NSLog(@"%@",[NSValue valueWithCGPoint:scrollView.contentOffset]);
//}
- (void)setPlaceholderImage:(NSString *)imageURL{
    if (!imageURL || [imageURL isEqualToString:@""]) {
        self.showImageView.image = JMMediaBrowserImage(@"placeHolder");
    }else{
        self.showImageView.image = [UIImage imageNamed:imageURL];
    }
    
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap)
    {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  =1;
    }
    return _doubleTap;
}

/** 双击 */
- (void)doDoubleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollView.zoomScale <= 1.0)
    {
        CGFloat scaleX = touchPoint.x + self.scrollView.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.scrollView.contentOffset.y;//需要放大的图片的Y点
        [self.scrollView zoomToRect:CGRectMake(scaleX, sacleY, 1, 1) animated:YES];
    }
    else
    {
        [self.scrollView setZoomScale:1.0 animated:YES]; //还原
    }
}



@end
