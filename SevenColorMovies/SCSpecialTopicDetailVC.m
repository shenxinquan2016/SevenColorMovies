//
//  SCSpecialTopicDetailVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/11.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSpecialTopicDetailVC.h"
#import "SCCollectionViewPageVC.h"

@interface SCSpecialTopicDetailVC ()

@property (nonatomic, strong) SCCollectionViewPageVC *collectionVC;

@end

@implementation SCSpecialTopicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addCollectionView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)addCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
    SCCollectionViewPageVC *vc = [[SCCollectionViewPageVC alloc] initWithCollectionViewLayout:layout];
    self.collectionVC = vc;
    vc.urlString = self.urlString;
    [vc.view setFrame:CGRectMake(0, 72, kMainScreenWidth, kMainScreenHeight-72)];
    [self.view addSubview:vc.view];
    
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
