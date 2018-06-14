//
//  JMPhotoBaseCollectionView.h
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/9.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMPhotoBaseCollectionCell.h"
@class JMMediaModel;

@interface JMPhotoBaseCollectionCell : UICollectionViewCell
@property (nonatomic, strong) JMMediaModel *model;

@property (nonatomic, assign, readonly) CGRect *currentImageRcet;

@property (nonatomic, strong) UIImageView *showImageView;

- (void)showActivity;
- (void)hideActivity;

- (void)loadImageWithModel:(JMMediaModel *)model;

- (void)configShowImageViewFrame:(CGRect)ImageViewFrame;
@end
