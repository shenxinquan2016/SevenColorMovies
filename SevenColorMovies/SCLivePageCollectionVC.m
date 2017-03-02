//
//  SCLivePageCollectionVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  直播频道列表页

#import "SCLivePageCollectionVC.h"
#import "SCLivePageCell.h"
#import "SCLivePlayerVC.h"

@interface SCLivePageCollectionVC () <UIAlertViewDelegate>

/** 非wifi弹出alert时存储filmModel */
@property (nonatomic, strong) SCFilmModel *alertViewClickFilmModel;

@end

@implementation SCLivePageCollectionVC

static NSString *const cellId = @"SCLivePageCell";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 让上次选中的单元格不被清空
     self.clearsSelectionOnViewWillAppear = NO;
    
    //0.初始化collectionView
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCLivePageCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
}

- (void)viewDidAppear{
    [super viewDidAppear:YES];
    // 让上次选中的单元格闪动一次
    [self.collectionView flashScrollIndicators];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filmModelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SCLivePageCell *cell = [SCLivePageCell cellWithCollectionView:collectionView identifier:cellId indexPath:indexPath];
    cell.filmModel = _filmModelArr[indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

#pragma mark ---- UICollectionViewDelegateFlowLayout

/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return (CGSize){kMainScreenWidth,100};
}

/** CollectionView四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 0, 5, 0);
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

/** item垂直间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

/** section Header 尺寸 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){kMainScreenWidth,0};
}

/** section Footer 尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){kMainScreenWidth,80};
}

#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     BOOL mobileNetworkAlert = [DONG_UserDefaults boolForKey:kMobileNetworkAlert];
     if (![[SCNetHelper getNetWorkStates] isEqualToString:@"WIFI"] && mobileNetworkAlert) {
         
         self.alertViewClickFilmModel = _filmModelArr[indexPath.row];
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前为移动网络，继续播放将消耗流量" delegate:nil cancelButtonTitle:@"取消播放" otherButtonTitles:@"确认播放", nil];
         [alertView show];
         alertView.delegate = self;
         
     } else {
         
         SCLivePlayerVC *livePlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCLivePlayerVC");
         
         SCFilmModel *model = _filmModelArr[indexPath.row];
         livePlayer.filmModel = model;
         livePlayer.channelNameLabel.text = @"zhibozhibo";
         [self.navigationController pushViewController:livePlayer animated:YES];
     }
   
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        BOOL mobileNetworkAlert = NO;
        [DONG_UserDefaults setBool:mobileNetworkAlert forKey:kMobileNetworkAlert];
        [DONG_UserDefaults synchronize];
        
        SCLivePlayerVC *livePlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCLivePlayerVC");
        SCFilmModel *model = self.alertViewClickFilmModel;
        livePlayer.filmModel = model;
        livePlayer.channelNameLabel.text = @"zhibozhibo";
        [self.navigationController pushViewController:livePlayer animated:YES];
        
    }
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}

@end
