//
//  TestLocolPhotoVC.m
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/6/13.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "TestLocolPhotoVC.h"
#import "JMMediaBrowser.h"
#import "UIImageView+WebCache.h"
@interface TestLocolPhotoVC ()

@property (nonatomic,strong) NSArray *imageNameArray;//本地图片名数组

@property (nonatomic,strong) NSArray *remoteImageNameArray;//网络图片名数组

@property (nonatomic,strong) NSMutableArray *imageViewArray;//图片控件数组

@end

@implementation TestLocolPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUIComponent];
}

- (void)createUIComponent{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat leftRightMargin = 15.0;//左右间距
    CGFloat marginBetweenImage = 10.0;//图片间间距
    CGFloat imageWidth = ([UIScreen mainScreen].bounds.size.width - 2 * leftRightMargin - 2 * marginBetweenImage) / 3.0;//图片宽
    CGFloat imageHeight = imageWidth / 3.0 * 2.0;//图片高
    CGFloat imagesBeginY = 100;

    if (self.photoSource == PhotoSourceLocal) {
        for (int i = 0; i < self.imageNameArray.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = [UIColor orangeColor];
            [self.view addSubview:imageView];
            [self.imageViewArray addObject:imageView];
            int row = i / 3;
            int col = i % 3;
            imageView.frame = CGRectMake(leftRightMargin + col * (imageWidth + marginBetweenImage), imagesBeginY + row * (imageHeight + marginBetweenImage), imageWidth, imageHeight);
            //        [self saveWindowFrameWithOriginalFrame:imageView.frame];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;//
            imageView.image = [UIImage imageNamed:self.imageNameArray[i]]; ;
            
            
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
        }
    }else{
        for (int i = 0; i < self.remoteImageNameArray.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = [UIColor orangeColor];
            [self.view addSubview:imageView];
            [self.imageViewArray addObject:imageView];
            int row = i / 3;
            int col = i % 3;
            imageView.frame = CGRectMake(leftRightMargin + col * (imageWidth + marginBetweenImage), imagesBeginY + row * (imageHeight + marginBetweenImage), imageWidth, imageHeight);
            //        [self saveWindowFrameWithOriginalFrame:imageView.frame];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;//
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.remoteImageNameArray[i]] placeholderImage:[UIImage imageNamed:@"temp.jpg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                ;
            }];
            
            
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
        }
        
    }
 
}

/** 点击了图片 */
- (void)clickImage:(UITapGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;
    NSLog(@"%ld",tag);
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *tempImageNameArr;
    if (self.photoSource == PhotoSourceLocal) {
        tempImageNameArr = self.imageNameArray;
    }else{
        tempImageNameArr = self.remoteImageNameArray;
    }

    for (NSInteger index = 0;index  < tempImageNameArr.count; index++) {
        JMMediaModel *model = [[JMMediaModel alloc]init];
        model.mediaType = JMMediaTypePhoto;
        
        model.mediaURLString = tempImageNameArr[index];//[NSString stringWithFormat:@"photo-%ld",index];
        model.placeholderString = @"temp.jpg";
        [arr addObject:model];
    }
    
    JMMediaBrowser *browser = [[JMMediaBrowser alloc]initWithResources:arr currentIndex:tag];
    [browser show];

}

#pragma mark - 懒加载
- (NSArray *)remoteImageNameArray{
    if (!_remoteImageNameArray)
    {
        _remoteImageNameArray = [NSArray arrayWithObjects:@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=597375154,2905536386&fm=27&gp=0.jpg",
                                 @"http://img5.imgtn.bdimg.com/it/u=2006592942,2480446407&fm=200&gp=0.jpg",@"http://pic36.photophoto.cn/20150711/0005018718403003_b.png",@"http://pic20.nipic.com/20120330/9693695_133542504156_2.jpg",@"http://img0.imgtn.bdimg.com/it/u=1451495581,2979778587&fm=27&gp=0.jpg",@"http://img1.imgtn.bdimg.com/it/u=4168922155,1724153302&fm=27&gp=0.jpg",nil];
    }
    return _remoteImageNameArray;
}

- (NSArray *)imageNameArray
{
    if (!_imageNameArray)
    {
        _imageNameArray = [NSArray arrayWithObjects:@"photo_0.jpg", @"photo_1.jpg", @"photo_2.jpg",@"photo_3.jpg",@"photo_4.jpg",@"photo_5.jpg",@"photo_6.jpg",nil];
    }
    return _imageNameArray;
}

- (NSMutableArray *)imageViewArray
{
    if (!_imageViewArray)
    {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
