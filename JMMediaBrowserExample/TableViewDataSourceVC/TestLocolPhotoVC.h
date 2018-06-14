//
//  TestLocolPhotoVC.h
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/13.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,PhotoSource) {
    PhotoSourceLocal,
    PhotoSourceRemote,
};
@interface TestLocolPhotoVC : UIViewController

@property (nonatomic, assign) PhotoSource photoSource;

@end
