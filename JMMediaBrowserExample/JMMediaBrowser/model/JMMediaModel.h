//
//  JMMediaModel.h
//  KidRobot
//
//  Created by Mac on 2018/4/18.
//  Copyright © 2018年 qiwo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,JMMediaType){
    JMMediaTypePhoto,
    JMMediaTypeVideo,
};
typedef NS_ENUM(NSUInteger,JMVideoPlayMode){
    JMVideoPlayModeDownload,//先下载
    JMVideoPlayModeFlow,//流式
};

@interface JMMediaModel : NSObject

@property (nonatomic, strong) NSString *mediaURLString;

@property (nonatomic, assign) JMMediaType mediaType;
/**预览图*/
@property (nonatomic, strong) NSString *placeholderString;

@property (nonatomic, assign, )  BOOL isCache;
@end
