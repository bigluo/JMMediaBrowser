//
//  JMPhotoBaseCollectionCell+Manager.m
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/14.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "JMPhotoBaseCollectionCell+Manager.h"
#import "JMMediaModel.h"
#import "UIImageView+WebCache.h"
#import "JMHeader.h"

@implementation JMPhotoBaseCollectionCell (Manager)

- (void)loadImageWithModel:(JMMediaModel *)model
                  progress:(loadImageProgressBlock)progressBlock
                  complete:(loadImageCompleteBlock)completeBlock{
    
    self.model = model;
    __weak typeof(self) weakSelf = self;
    
    //网络图片
    if ([self.model.mediaURLString hasPrefix:@"http"]) {
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.mediaURLString] placeholderImage:[UIImage imageNamed:model.placeholderString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if ([imageURL.absoluteString isEqualToString:model.mediaURLString]) {
                    ;
                if (error) {
                    completeBlock(image,CGRectNull,error);
                }else{
                    CGRect imageRect = [weakSelf getRectFromImage:image];
                    completeBlock(image,imageRect,error);
                }
                }
        }];
        
    }else{
        if (!model.placeholderString || [model.placeholderString isEqualToString:@""]) {
            self.showImageView.image = JMMediaBrowserImage(@"placeHolder");
        }else{
            self.showImageView.image = [UIImage imageNamed:model.placeholderString];
        }
        
        UIImage *image =[UIImage imageNamed:model.mediaURLString];
        if (image) {
            CGRect imageRect = [self getRectFromImage:image];
            self.showImageView.image = image;
            completeBlock(image,imageRect,nil);
            return;
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.model.mediaURLString]) {
            NSData *imageData = [NSData dataWithContentsOfFile:self.model.mediaURLString];
            
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                CGRect imageRect = [self getRectFromImage:image];
                self.showImageView.image = image;
                completeBlock(image,imageRect,nil);
            }else{
                NSError *error;
                completeBlock(nil,CGRectNull,error);
            }
            
        }else{
            
            
        }
        
        
        
    }
}


//获取图片要显示的大小
-(CGRect)getRectFromImage:(UIImage *)image
{
    CGRect frame = CGRectZero;
    if ((image.size.width > JMSCREEN_WIDTH) && (image.size.height > JMSCREEN_HEIGHT)) {
        float  widthMutiple = image.size.width / JMSCREEN_WIDTH;
        float  heightMutiple = image.size.height / JMSCREEN_HEIGHT;
        if (widthMutiple > heightMutiple) {
            frame = CGRectMake(0, 0, JMSCREEN_WIDTH, image.size.height /widthMutiple);
        }else{
            frame = CGRectMake(0, 0, image.size.width / heightMutiple, JMSCREEN_HEIGHT);
        }
        return frame;
    }
    else if(image.size.width > JMSCREEN_WIDTH){
        float  widthMutiple = image.size.width / JMSCREEN_WIDTH;
        frame = CGRectMake(0, 0, JMSCREEN_WIDTH, image.size.height / widthMutiple);
        return frame;
    }else if(image.size.height > JMSCREEN_HEIGHT){
        float  heightMutiple = image.size.height / JMSCREEN_HEIGHT;
        frame = CGRectMake(0, 0, image.size.width / heightMutiple, JMSCREEN_HEIGHT);
        return frame;
    }else{
        frame = CGRectMake(0, 0, image.size.width, image.size.height);
        return frame;
    }
}

- (void)saveImagetoSystem:(saveImageResult)saveBlock{
    if (self.showImageView.image) {
        UIImageWriteToSavedPhotosAlbum(self.showImageView.image, nil, nil,nil);
    }
}
@end
