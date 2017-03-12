//
//  SCDiscoveryViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDiscoveryViewController.h"
#import "SCDiscoveryTableViewCell.h"
#import "SCDiscoveryCellModel.h"
#import "SCRemoteControlVC.h"
#import "SCSearchDeviceVC.h"
#import "SCTCPSocketManager.h"
#import "SCDLNAViewController.h"
#import "SCScanQRCodesVC.h"
#import "SCXMPPManager.h"
#import "SCDiscoveryCollectionViewCell.h"
#import "SCSecondLevelVC.h"

#import <Crashlytics/Crashlytics.h>

@interface SCDiscoveryViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) UICollectionView *collView;/** collectionView */


@end

@implementation SCDiscoveryViewController

static NSString *const cellId = @"SCDiscoveryCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#dddddd"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self setTableView];
    
    //2.添加cellectionView
    [self loadCollectionView];
    
    
    // 崩溃测试
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 550, 60, 30);
    [button setTitle:@"Crash" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:@"#F0F1F2"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(crashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DONG_NotificationCenter addObserver:self selector:@selector(toSearchingDevicePage) name:CutOffTcpConnectByUser object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)dealloc {
    [DONG_NotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark- private methods

- (void)loadCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
    _collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) collectionViewLayout:layout];
    _collView.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    _collView.dataSource = self;
    _collView.delegate = self;
    _collView.scrollEnabled = NO;//禁止滚动
    [self.view addSubview:_collView];
    
    
    // 注册cell、sectionHeader、sectionFooter
    [_collView registerNib:[UINib nibWithNibName:@"SCDiscoveryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    
}


- (void)toSearchingDevicePage
{
    SCSearchDeviceVC *searchDeviceVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCSearchDeviceVC");
    searchDeviceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchDeviceVC animated:YES];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCDiscoveryCollectionViewCell *cell = [_collView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    [cell setModel:self.dataSource[indexPath.row] IndexPath:indexPath];
    
    return cell;
}



#pragma mark ---- UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(kMainScreenWidth-2)/3,80};
}

/** Section EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 1, 0);
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}

/** item垂直间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
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
    NSDictionary *dict = self.dataSource[indexPath.row];
    NSString *keyStr = [dict.allKeys objectAtIndex:0];
    SCSecondLevelVC *secondLevel  = [[SCSecondLevelVC alloc] initWithWithTitle:keyStr];
    secondLevel.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:secondLevel animated:YES];

}



#pragma mark- Getters and Setters
- (NSArray *)dataSource {
    
    if (!_dataSource) {
//        NSArray *array = @[@[@{@"leftImg":@"Scan",@"title":@"扫一扫",@"isShowBottmLine":@"YES"}],
//                           @[@{@"leftImg":@"RemoteControl",@"title":@"遥控器",@"isShowBottmLine":@"NO"},
//                             /*@{@"leftImg":@"DLNA",@"title":@"DLNA",@"isShowBottmLine":@"YES"}*/],
//                           /*@[@{@"leftImg":@"Activity",@"title":@"活动专区",@"isShowBottmLine":@"NO"},                           @{@"leftImg":@"Game_1",@"title":@"游戏中心",@"isShowBottmLine":@"YES"}],
//                           @[@{@"leftImg":@"Application",@"title":@"应用中心",@"isShowBottmLine":@"NO"},                           @{@"leftImg":@"Live_1",@"title":@"直播伴侣",@"isShowBottmLine":@"YES"}]*/];
        NSArray *array = @[@{@"水费":@"水费"}, @{@"电费":@"电费"}, @{@"燃气费":@"燃气费"}, @{@"有线电视":@"有线电视"}, @{@"固话宽带":@"固话宽带"}, @{@"物业费":@"物业费"}, @{@"交通违章":@"交通违章"}];
        _dataSource = array;
    }
    return _dataSource;
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}




- (IBAction)crashButtonTapped:(id)sender {
    [[Crashlytics sharedInstance] crash];
}


@end
