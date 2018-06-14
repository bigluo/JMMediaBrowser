//
//  JMPhotoBaseCollectionView.m
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/9.
//  Copyright © 2018年 JM. All rights reserved.
//


#import "JMPhotoBaseCollectionCell+Manager.h"
#import "UIView+JMExtension.h"
@interface JMPhotoBaseCollectionCell()

@property(nonatomic,strong) UIActivityIndicatorView *activity;

@end

@implementation JMPhotoBaseCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showImageView = [[UIImageView alloc]init];
        self.activity = [[UIActivityIndicatorView alloc]init];
        self.activity.hidesWhenStopped = YES;
    }
    return self;
    
}

- (void)loadImageWithModel:(JMMediaModel *)model{
    [self showActivity];
    __weak typeof(JMPhotoBaseCollectionCell *) weakCell = self;
    [self loadImageWithModel:model progress:^(CGFloat schedule) {
        ;
    } complete:^(UIImage *image, CGRect imageRect, NSError *error) {
        [self hideActivity];
        CGPoint center = weakCell.showImageView.center;
        weakCell.showImageView.jm_size = imageRect.size;
        weakCell.showImageView.center = center;
    }];
}

- (void)showActivity{
    self.activity.center = self.showImageView.center;
    [self.activity startAnimating];
}

- (void)hideActivity{
    [self.activity stopAnimating];
}

- (void)configShowImageViewFrame:(CGRect)imageViewFrame{
    self.showImageView.frame = imageViewFrame;
}

@end
