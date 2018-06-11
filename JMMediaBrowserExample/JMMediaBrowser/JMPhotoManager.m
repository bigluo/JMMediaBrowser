//
//  JMPhotoService.m
//  KidRobot
//
//  Created by 123 on 2018/4/27.
//  Copyright © 2018年 qiwo. All rights reserved.
//

#import "JMPhotoManager.h"
#import "JMPhotoCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "JMHeader.h"

//#define JMWeakSelf __weak typeof(self) weakSelf = self;
@interface JMPhotoManager()
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) NSFileManager *fileManager;
@end

@implementation JMPhotoManager

-(NSFileManager *)fileManager{
    if (_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (void)loadImageWithModel:(JMMediaModel *)model
                  progress:(loadImageProgressBlock)progress
                Completion:(loadImageCompleteBlock)completeBlock{
    _model = model;
    __weak typeof(self) weakSelf = self;
    
    //网络图片
    if ([self.model.mediaURL hasPrefix:@"http"]) {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:model.mediaURL]
                                                    options:SDWebImageRetryFailed
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            if ([targetURL.absoluteString isEqualToString:model.mediaURL]){
                progress(receivedSize/expectedSize);
            }
        }completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            if ([imageURL.absoluteString isEqualToString:model.mediaURL]){
                CGRect imageRect = [weakSelf getRectFromImage:image];
                completeBlock(image,imageRect,error);
            }

        }];

    }else{
        UIImage *image =[UIImage imageNamed:@"flower"];
        if (image) {
            CGRect imageRect = [self getRectFromImage:image];
            completeBlock(image,imageRect,nil);
            return;
        }
        
        if ([self.fileManager fileExistsAtPath:self.model.mediaURL]) {
            NSData *imageData = [NSData dataWithContentsOfFile:self.model.mediaURL];
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                CGRect imageRect = [self getRectFromImage:image];
                completeBlock(image,imageRect,nil);
            }else{
                completeBlock(nil,CGRectNull,nil);
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
    if (self.currentImage) {
        UIImageWriteToSavedPhotosAlbum(_currentImage, nil, nil,nil);
    }
}
@end
