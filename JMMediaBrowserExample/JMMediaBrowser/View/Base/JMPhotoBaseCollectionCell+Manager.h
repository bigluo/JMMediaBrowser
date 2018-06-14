//
//  JMPhotoBaseCollectionCell+Manager.h
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/14.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "JMPhotoBaseCollectionCell.h"

typedef void(^loadImageCompleteBlock)(UIImage *image,CGRect imageRect,NSError *error);
typedef void(^loadImageProgressBlock)(CGFloat schedule);
typedef void(^saveImageResult)(BOOL success);


@interface JMPhotoBaseCollectionCell (Manager)

- (void)loadImageWithModel:(JMMediaModel *)model
                  progress:(loadImageProgressBlock)progressBlock
                  complete:(loadImageCompleteBlock)completeBlock;

@end
