//
//  SCLiveViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  直播首页面

#import "SCLiveViewController.h"
#import "SCLivePageCollectionVC.h"

@interface SCLiveViewController ()

@property (nonatomic, strong) UIScrollView *titleScroll;/** 标题栏scrollView */
@property (nonatomic, strong) UIScrollView *contentScroll;/** 内容栏scrollView */
@property (nonatomic, strong) NSMutableArray *titleArr;/** 标题数组 */
@property (nonatomic, strong) SCLivePageCollectionVC *needScrollToTopPage;/** 在当前页设置点击顶部滚动复位 */

@end

@implementation SCLiveViewController

#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //2.初始化数组
    self.titleArr = [NSMutableArray arrayWithCapacity:0];
    
    //3.网络请求
    [self getLiveClassData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark- private methods
/** 添加滚动标题栏*/
- (void)constructSlideHeaderView{
    
    
    
}

/** 添加标题栏label */
- (void)addLabel{
    
    
}

/** 添加正文内容页 */
- (void)constructContentView{
    
}

#pragma mark- Event reponse
// 点击标题label
- (void)labelClick:(UITapGestureRecognizer *)recognizer{
//    SCSlideHeaderLabel *label = (SCSlideHeaderLabel *)recognizer.view;
//    CGFloat offsetX = label.tag * _contentScroll.frame.size.width;
//    
//    CGFloat offsetY = _contentScroll.contentOffset.y;
//    CGPoint offset = CGPointMake(offsetX, offsetY);
//    
//    [_contentScroll setContentOffset:offset animated:YES];
//    
//    [self setScrollToTopWithTableViewIndex:label.tag];
}

#pragma mark- 网络请求
- (void)getLiveClassData{
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataWithUrl:LivePageUrl parameters:nil success:^(id  _Nullable responseObject) {
        
        if (responseObject) {
            
            //1.添加滑动headerView
            [self constructSlideHeaderView];
            //2.添加contentScrllowView
            [self constructContentView];
            
        }
                        NSLog(@"==========dic:::%@========",responseObject);
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];

}
@end
