//
//  ViewController.m
//  JMMediaBrowserExample
//
//  Created by 123 on 2018/5/29.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "ViewController.h"
#import "JMHeader.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataSoruce;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoruce = [NSMutableArray arrayWithObjects:@"本地图片",@"网络图片",@"网络视频", nil];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height- 64) style:UITableViewStylePlain];
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
}

- (void)toLocolPhotoBrowser{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger index = 0; index < 4; index++) {
        JMMediaModel *model = [[JMMediaModel alloc]init];
        model.mediaType = JMMediaTypePhoto;
        model.mediaURL = [NSString stringWithFormat:@"photo-%ld",index];
        model.placeholderImageFileStr = @"placeHolder";
        [arr addObject:model];
    }
    
    JMMediaBrowser *browser = [[JMMediaBrowser alloc]initWithResources:arr currentIndex:0];
    [browser show];
}

- (void)toRemotePhotoBrowser{
    //@"http://static.smartisanos.cn/common/video/proud-farmer.mp4";
    NSArray *urlArr = @[
                        @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=597375154,2905536386&fm=27&gp=0.jpg",
                        @"http://img5.imgtn.bdimg.com/it/u=2006592942,2480446407&fm=200&gp=0.jpg",@"http://pic36.photophoto.cn/20150711/0005018718403003_b.png",@"http://pic20.nipic.com/20120330/9693695_133542504156_2.jpg",@"http://img0.imgtn.bdimg.com/it/u=1451495581,2979778587&fm=27&gp=0.jpg",@"http://img1.imgtn.bdimg.com/it/u=4168922155,1724153302&fm=27&gp=0.jpg"
];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger index = 0; index < urlArr.count; index++) {
        JMMediaModel *model = [[JMMediaModel alloc]init];
        model.mediaType = JMMediaTypePhoto;
        model.mediaURL = urlArr[index];
        model.placeholderImageFileStr = @"placeHolder";
        [arr addObject:model];
    }
    
    JMMediaBrowser *browser = [[JMMediaBrowser alloc]initWithResources:arr currentIndex:0];
    [browser show];
}


- (void)toRemoteVideoBrowser{
    //@"http://static.smartisanos.cn/common/video/proud-farmer.mp4";
    NSArray *urlArr = @[@"http://static.smartisanos.cn/common/video/proud-farmer.mp4",@"http://static.smartisanos.cn/common/video/proud-farmer.mp4",@"http://static.smartisanos.cn/common/video/proud-farmer.mp4"];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger index = 0; index < urlArr.count; index++) {
        JMMediaModel *model = [[JMMediaModel alloc]init];
        model.mediaType = JMMediaTypeVideo;
        model.mediaURL = urlArr[index];
        model.placeholderImageFileStr = @"placeHolder";
        [arr addObject:model];
    }
    
    JMMediaBrowser *browser = [[JMMediaBrowser alloc]initWithResources:arr currentIndex:0];
    [browser show];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.dataSoruce.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier        = @"playerListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataSoruce[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0){
        [self toLocolPhotoBrowser];
    }else if(indexPath.row == 1){
        [self toRemotePhotoBrowser];
    }else if(indexPath.row == 2){
        [self toRemoteVideoBrowser];
    }else if(indexPath.row == 3){
        
    }else if(indexPath.row == 4){
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
