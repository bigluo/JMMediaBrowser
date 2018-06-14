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

@protocol JMVideoManagerDelegate <NSObject>
@optional


@end

typedef void(^loadImageCompleteBlock)(UIImage *image,CGRect imageRect,NSError *error);
typedef void(^loadImageProgressBlock)(CGFloat schedule);
typedef void(^saveImageResult)(BOOL success);

@protocol JMPhotoManagerDelegate
@optional
- (void)jm_loadImageProgress:(CGFloat)schedule;

- (void)jm_loadImageCompleteWithURLStr:(NSString *)urlStr Image:(UIImage *)image imageRect:(CGRect)imageRect error:(NSError *)error;

@end

@interface JMPhotoManager : NSObject

@property (nonatomic, strong, readonly) JMMediaModel *model;

@property (nonatomic, assign, readonly) CGRect *currentImageRcet;


@property (nonatomic, weak, nullable) id <JMPhotoManagerDelegate> delegate;


- (void)loadImageWithModel:(JMMediaModel *)model;

//- (void)saveImagetoSystem:(saveImageResult)saveBlock;

- (CGFloat)zoomScale;

@end
