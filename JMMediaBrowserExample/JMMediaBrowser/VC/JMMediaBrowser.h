//
//  JMResourceBrowser.h
//  KidRobot
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 qiwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMMediaModel.h"

//忽略编译器的警告
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored"-Wdeprecated-declarations"

typedef NS_ENUM(NSUInteger, SlideDirect){
    SlideDirectDefault,
    SlideDirectLeft,
    SlideDirectRight,
};

typedef NS_ENUM(NSUInteger, JMMediaBrowserAnimation) {
    JMMediaBrowserAnimationNone,    //无动画
    JMMediaBrowserAnimationFade,    //渐隐
    JMMediaBrowserAnimationMove     //移动
};

/**
 第一种方案用scrollView里面加上两张View  划得太快导致view加载不上，来不急触发代理方法
 */
@interface JMMediaBrowser : UIViewController 
{

    
    UIButton     *saveButton;
    
    BOOL  havePreData;
    BOOL  haveMoreData;
    
    UIScrollView  *_externalScrollView; //外层scrollView
}

@property (nonatomic,strong) NSArray<JMMediaModel *> *mediaArray;



@property (nonatomic,assign) SlideDirect  slideDirect;//总图片数

@property (nonatomic,strong) UIView  *nearContentView;

@property (nonatomic,strong) UIView  *currentContentView;

@property (nonatomic,copy) void(^deleteResourceBlock)(JMMediaModel *model);

- (void)show;

- (instancetype)initWithResources:(NSArray *)array currentIndex:(NSInteger)index;
@end
