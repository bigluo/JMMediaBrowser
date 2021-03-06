//
//  JMResourceBrowser.m
//  KidRobot
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 qiwo. All rights reserved.
//

#import "JMMediaBrowser.h"
#import "JMPhotoCollectionCell.h"
#import "JMVideoCollectionCell.h"
#import "JMVideoManager.h"
#import "JMPhotoManager.h"
#import "UIView+JMExtension.h"
#import "JMHeader.h"
#import "UIImageView+WebCache.h"
#import "JMMediaBrowserTranslation.h"

NSString * const JMPhotoCellIdentifier = @"JMPhotoCellIdentifier";
NSString * const JMVideoCellIdentifier = @"JMVideoCellIdentifier";
@interface JMMediaBrowser()<UICollectionViewDataSource, UICollectionViewDelegate>//UIViewControllerTransitioningDelegate
{
    
}
@property (nonatomic,strong) JMMediaBrowserTranslation *translation;//转场动画管理者

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic,assign) NSInteger  currentIndex;//当前图片

@property (nonatomic,assign) NSInteger   totalCount;//总图片数

@property (nonatomic,weak)UILabel *titleLabel;

@property (nonatomic,weak)UILabel *tipLabel;

@property (strong, nonatomic)  UIView *lanpScapeVideoView;

@property (strong, nonatomic) JMVideoManager *videoManager;

@property (strong, nonatomic) JMPhotoManager *photoManager;

@property (nonatomic, assign) BOOL animateShow;

@property (nonatomic, assign) CGRect fromViewRect;

@property (nonatomic, weak)   UIViewController *fromVC;

@property (nonatomic, assign) BOOL  statusBarHidden;
@end

@implementation JMMediaBrowser

-(instancetype)init{
    @throw  [NSException exceptionWithName:@"JMMediaBrowser init error" reason:@"please use the disignated initializer and pass 'mediaArray' and 'index'" userInfo:nil];
    return [self initWithResources:nil currentIndex:0];
}

- (instancetype)initWithResources:(NSArray *)array currentIndex:(NSInteger)index{
    self =[super init];
    if (self) {
        _mediaArray   = array;
        _totalCount   = [array count];
        _currentIndex = index;
        _animateShow  = YES;
    }
    return self;
}

- (instancetype)initWithResources:(NSArray *)array currentIndex:(NSInteger)index fromVC:(UIViewController *)fromVC{
    self =[super init];
    if (self) {
        _mediaArray   = array;
        _totalCount   = [array count];
        _currentIndex = index;
        _animateShow  = YES;
        _fromVC       = fromVC;
    }
    return self;
    
}

#pragma mark - 懒加载
- (JMMediaBrowserTranslation *)translation
{
    if (!_translation)
    {
        _translation = [[JMMediaBrowserTranslation alloc] init];
        //        _translation.endBlock = ^{
        //            NSLog(@"end");
        //        };
//        _translation.photoBrowserMainScrollView = (UIView *)self.mainScrollView;
//        _translation.imageViewArray = self.imageViewArray;
//        _translation.imageViewFrameArray = self.imageViewFrameArray;
//        _translation.imageNameArray = self.imageNameArray;
//        _translation.currentIndex = self.currentImageIndex;//这个参数要最后赋值，因为他的setter中用到了上面的参数
    }
    return _translation;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.transitioningDelegate = self;
    [self addNotification];
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self configeStatusBarHidden:YES];
    
    self.videoManager = [[JMVideoManager alloc]init];
    self.videoManager.isAutoPlay = YES;
    self.photoManager = [[JMPhotoManager alloc]init];
    [self initSubView];
    self.collectionView.backgroundColor = [UIColor orangeColor];
    

}

- (void)addNotification{
    // 监测设备方向
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onDeviceOrientationChange)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(appBecomeActive:)
    //                                                 name:UIApplicationDidBecomeActiveNotification
    //                                               object:nil];
    //
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(appWillResignActive:)
    //                                                 name:UIApplicationWillResignActiveNotification
    //                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        //调用隐藏方法
//        [self prefersStatusBarHidden];
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//
//    }
    //[self configeStatusBarHidden:YES];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    [self.playerItem  removeObserver:self forKeyPath:@"loadedTimeRanges"];
    //[self configeStatusBarHidden:NO];
    
//     [UIView animateWithDuration:0.5 animations:^{
//                 [self setNeedsStatusBarAppearanceUpdate];
//             }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}


- (void)configeStatusBarHidden:(BOOL)hidden {
    self.statusBarHidden = hidden;
    [UIView animateWithDuration:0.5 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];

}

#pragma mark 旋转
- (BOOL)shouldAutorotate{
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) {
        return;
        
    }else if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight){
        [self.collectionView removeFromSuperview];
        self.collectionView.frame = self.view.frame;//CGSizeMake(self.view.jm_height, self.view.jm_width);
        [self.view addSubview:self.collectionView];
        
    }else if (orientation == UIDeviceOrientationPortrait){
        [self.collectionView removeFromSuperview];
        self.collectionView.frame = self.view.frame;
        [self.view addSubview:self.collectionView];
    }
    [self.view setNeedsLayout];
}

//
////实现隐藏方法
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (void)initSubView{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.view.frame = screenRect;
    [self createCollectionView];
//    [self createTitleLabel];
    [self createBackButton];
//    [self createSaveBtn];
//    [self createDeleteBtn];
//    [self createBottomTipLabel];

}

- (void)createCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout .itemSize = self.view.bounds.size;
    self.layout .minimumLineSpacing = 0;
    self.layout .scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                             collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView  registerClass:[JMVideoCollectionCell class]
             forCellWithReuseIdentifier:JMVideoCellIdentifier];
    [self.collectionView  registerClass:[JMPhotoCollectionCell class]
             forCellWithReuseIdentifier:JMPhotoCellIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)createTitleLabel{
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0, 30, 200, 35);
    titleLabel.jm_centerX = self.view.frame.size.width/2;
    [self.view addSubview:titleLabel];
}

-(void)createSaveBtn{
//    UIButton *saveBtn = [[UIButton alloc]init];
//    saveBtn.bounds = CGRectMake(0, 0, kScreenWidth - 2*AutoSize(20), 45);
//    saveBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    saveBtn.layer.borderWidth = 1;
//    saveBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 80);
//    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [saveBtn setTitle:@"  保存至本地相册" forState:UIControlStateNormal];
//    [saveBtn setTitle:@"  保存至本地相册" forState:UIControlStateDisabled];
//    [saveBtn setImage:[UIImage imageNamed:@"ic_download"] forState:UIControlStateNormal];
////    [saveBtn setBackgroundImage:[UIImage imageNamed:@"preSaveBtnBg"] forState:UIControlStateNormal];
////    [saveBtn setBackgroundImage:[UIImage imageNamed:@"SaveBtnBg"] forState:UIControlStateDisabled];
//    [saveBtn addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
//    saveButton = saveBtn;
//    [self.view addSubview:saveBtn];
}

- (void)createDeleteBtn{
//    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-45, 30, 35, 35)];
//    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
//    [deleteBtn setImage:[UIImage imageNamed:@"video_delete"] forState:UIControlStateNormal];
//    [self.view addSubview:deleteBtn];
}

- (void)createBackButton{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 35, 35)];
    [backBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:JMMediaBrowserImage(@"JM_back") forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
}

- (void)createBottomTipLabel{
//    UILabel *tipLabel = [[UILabel alloc]init];
//    self.tipLabel = tipLabel;
//    tipLabel.font = [UIFont systemFontOfSize:12];
//    tipLabel.textColor = [UIColor whiteColor];
//    tipLabel.textAlignment = NSTextAlignmentCenter;
//    tipLabel.frame = CGRectMake(0,self.view.frame.size.height - 25 - 30 , self.view.frame.size.width, 35);
//    tipLabel.centerX = self.view.frame.size.width/2;
//    [self.view addSubview:tipLabel];
}


#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
- (void)deleteAction{
//    NSInteger deleteIndex = _currentIndex;
//    JMMediaModel *model = self.mediaArray[deleteIndex];
//     [Uility showSVHUD:@"删除中..."];
//    [[WebServiceManager shareManager] deleteWithMethod:    API_baby_deleteActivity(model.mediaID) withParam:@{@"familyId":@([User sharedInstance].selectDeviceModel.baby_familyId)} success:^(id response){
//        [Uility showSVHUDWithSuccess:@"删除成功"];
//        if (deleteIndex > self.mediaArray.count - 1) {
//            return;
//        }
//            [weakSelf.mediaArray removeObject:model];
//            [self.collectionView reloadData];
//            if (deleteIndex >= 1) {
//                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:deleteIndex-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//            }
//        if (self.deleteResourceBlock) {
//            self.deleteResourceBlock(model);
//        }
////        [Uility dismissSVHUD];
//    } failure:^(id response) {
//        [Uility showSVHUDWithError:@"删除失败，请稍后再试"];
//    }];
   
}

- (void)downloadAction{
//    JMMediaModel *model = self.mediaArray[_currentIndex];
//    if (model.mediaType == JMMediaTypePhoto) {
//        [self.photoManager saveImagetoSystem];
//        [Uility showSuccessTipView];
//    }else if(model.mediaType == JMMediaTypeVideo){
//        self.collectionView.scrollEnabled = NO;
//        [self.videoManager saveVideoToSystem:^(BOOL success) {
//             self.collectionView.scrollEnabled = YES;
//        }];
//    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.totalCount;
}
/**
 返回的数据要对应哪一个cell
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentIndex = indexPath.row;
    JMMediaModel *model =  self.mediaArray[indexPath.row];
    if (model.mediaType == JMMediaTypePhoto) {
        return [self configNormalPhotoCollectionCellForIndexPath:indexPath mediaModel:model];
    }else{
        return [self configNormalVideoCollectionCellForIndexPath:indexPath mediaModel:model];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    JMMediaModel *model = self.mediaArray[indexPath.row];
    if (model.mediaType == JMMediaTypeVideo) {
        [self.videoManager manualPause];
    }
    
}

- (JMPhotoCollectionCell *)configNormalPhotoCollectionCellForIndexPath:(NSIndexPath *)indexPath mediaModel:(JMMediaModel *)model{
    
    JMPhotoCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:JMPhotoCellIdentifier
                                                                            forIndexPath:indexPath];
    [cell loadImageWithModel:model];
//    __block JMPhotoCollectionCell* blockCell = cell;
//    [cell setPlaceholderImage:model.placeholderString];
//    [self.photoManager loadImageWithModel:model];
//    [self.photoManager loadImageWithModel:model progress:^(CGFloat schedule) {
//        //        [cell showProgressViewWithSchedule:schedule];
//        // [cell jm_showProgressViewWithSchedule:schedule];
//    } Completion:^(UIImage *image, CGRect imageRect, NSError *error) {
//        //            [cell jm_removeActivityIndicator];
//        //        [cell jm_removeProgressView];
//        if (!error) {
//            [blockCell setShowImage:image imageRect:imageRect animation:_animateShow];
//            if (_animateShow) {
//                _animateShow = NO;
//            }
//        }
//    }];
//    [cell jm_showActivityIndicatorView];
    return cell;
}

- (JMVideoCollectionCell *)configNormalVideoCollectionCellForIndexPath:(NSIndexPath *)indexPath mediaModel:(JMMediaModel *)model{
    __weak typeof(self) weakSelf = self;

    JMVideoCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:JMVideoCellIdentifier
                                                                            forIndexPath:indexPath];
    
    cell.playOrPauseBlock = ^(BOOL play) {
        if (play) {
            [weakSelf.videoManager manualPlay];
        }else{
            [weakSelf.videoManager manualPause];
        }
    };
    cell.sliderChangeBlock = ^(CGFloat changeValue) {
        [weakSelf.videoManager changeProgress:changeValue];
    };
    [self.videoManager playWithModel:model success:^(AVPlayerLayer *playerLayer) {
        [cell addPlayerLayer:playerLayer];;
    } failure:^(NSString *errMsg) {
        ;
    }];
    
    return cell;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    JMMediaModel *model = self.mediaArray[_currentIndex];
//    if (model.mediaType == JMMediaTypeVideo) {
//        [self.videoManager manualPause];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (self.model.mediaType == JMMediaTypeVideo) {
//        [self.videoManager manualPlay];
//
//    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.t == 0) {
//        return;
//    }
    
//    if (self.didSelectItemBlock) {
//        self.didSelectItemBlock(indexPath.item % self.imageUrls.count);
//    }
}



- (void)show{
//    _currentContentView.x = _externalScrollView.bounds.size.width*_currentPage;
//    JMResourcePhotoView *photoView = [[JMResourcePhotoView alloc]initWithFrame:_currentContentView.frame];
//    photoView.model = self.resourceArray[_currentPage];
//    [photoView showImage];
//    [_currentContentView addSubview:photoView];
//     _externalScrollView.contentOffset = CGPointMake(_externalScrollView.bounds.size.width*_currentPage, 0);
//    if (self.fromVC) {
//        [self.fromVC addChildViewController:self];
//        [self.fromVC.view addSubview:self.view];
//    }else{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window.rootViewController addChildViewController:self];
        [window.rootViewController.view addSubview:self.view];
//    }

//    [window addSubview:self.view];

}

- (void)hide
{
    [self configeStatusBarHidden:NO];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
//    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    if ([delegate respondsToSelector:@selector(STDImageBrowserWillHide:)]) {
//        [delegate STDImageBrowserWillHide:self];
//    }
//    [[UIApplication sharedApplication] setStatusBarHidden:statusBarHidden];
//    pageLabel.hidden = YES;
//    selectBtn.hidden = YES;
    
//    [self removeFromSuperview];
}

- (void)jm_getTranslationAnimateImage:(JMGetTranslationAnimateImageBlock)translationAnimateImageblock{
    JMMediaModel *model = self.mediaArray[_currentIndex];
//    if (model.mediaType == JMMediaTypePhoto) {
//        self.photoManager
//    }else if (model.mediaType == JMMediaTypeVideo){
//        self.videoManager
//    }
}

#pragma mark UIViewControllerTransitioningDelegate(转场动画代理)
//这个是B回到A时执行的方法
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.translation.mediaBrowserShow = YES;
    return self.translation;
}

//这个是A跳到B时执行的方法
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.translation.mediaBrowserShow = NO;
    return self.translation;
}

@end
