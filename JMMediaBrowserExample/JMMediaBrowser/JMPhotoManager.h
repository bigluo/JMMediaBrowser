//
//  JMPhotoService.h
//  KidRobot
//
//  Created by 123 on 2018/4/27.
//  Copyright © 2018年 qiwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JMMediaModel;
@class JMPhotoCollectionCell;

typedef void(^loadImageCompleteBlock)(UIImage *image,CGRect imageRect,NSError *error);
typedef void(^loadImageProgressBlock)(CGFloat schedule);
typedef void(^saveImageResult)(BOOL success);

@interface JMPhotoManager : NSObject
@property (nonatomic, strong, readonly) JMMediaModel *model;

//@property (nonatomic, strong) JMPhotoCollectionCell *cell;


- (void)loadImageWithModel:(JMMediaModel *)model
                  progress:(loadImageProgressBlock)progress
                Completion:(loadImageCompleteBlock)completeBlock;

- (void)saveImagetoSystem:(saveImageResult)saveBlock;

- (CGFloat)zoomScale;

@end
