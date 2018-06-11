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
//@property (nonatomic, assign) NSInteger mediaID;

@property (nonatomic, strong) NSString *mediaURL;

//@property (nonatomic, assign) NSInteger timeSP;

@property (nonatomic, assign) JMMediaType mediaType;

//@property (nonatomic, assign) JMMediaType JMVideoPlayMode;
/**预览图*/
@property (nonatomic, strong) NSString *placeholderImageFileStr;

//@property (nonatomic, assign, readonly) BOOL isLocal;

@property (nonatomic, assign, )  BOOL isCache;
@end
