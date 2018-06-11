//
//  JMHeader.h
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/5/29.
//  Copyright © 2018年 JM. All rights reserved.
//

#ifndef JMHeader_h
#define JMHeader_h

#import <UIKit/UIKit.h>

#import "JMMediaModel.h"

#import "UIView+JMExtension.h"

#import "JMPhotoManager.h"
#import "JMVideoManager.h"

#import "JMMediaBrowser.h"
#import "JMVideoCollectionCell.h"
#import "JMPhotoCollectionCell.h"

#define JMSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define JMSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#ifdef DEBUG
#define JMLog(fmt, ...) NSLog((@"\n%s [Line %d]\nlog:" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define JMLog(...)
#endif

#define JMMediaBrowserImage(file) [UIImage imageNamed:[@"JMMediaBrowser.bundle" stringByAppendingPathComponent:file]]


#define ZFPlayerImage(file)                  ? :[UIImage imageNamed:ZFPlayerFrameworkSrcName(file)]


#endif /* JMHeader_h */
