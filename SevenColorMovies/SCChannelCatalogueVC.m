//
//  ChannelCatalogueVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  点播栏 —— 更多

#import "SCChannelCatalogueVC.h"
#import "SCChannelCatalogueCell.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "SCChannelCategoryVC.h"
#import "SCFilmListModel.h"
#import "SCFilmClassModel.h"
#import "SCLiveViewController.h"
#import "SCLovelyBabyCenterVC.h"


@interface SCChannelCatalogueVC ()<LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collView;/** collectionView */
@property (nonatomic, strong) UIButton *editBtn;/** 编辑按钮 */
@property (nonatomic, strong) NSMutableDictionary *filmClassModelDictionary;/** 将filmClassModel放入字典 */

@end

@implementation SCChannelCatalogueVC

static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //-1.组建filmClassModelDictionary
    [self setFilmClassModelDictionary];
    
    //0.编辑按钮
    [self addRightBBI];
    
    //2.添加cellectionView
    [self loadCollectionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -Private Method
- (void)addRightBBI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 45, 23);
    
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.enlargedEdge = 5.f;
    [btn.layer setBorderWidth:1.5f];
    [btn.layer setBorderColor:[UIColor grayColor].CGColor];
    [btn addTarget:self action:@selector(doEditingAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
    _editBtn = btn;
    _editBtn.selected = NO;
}

- (void)doEditingAction
{
    if (_editBtn.selected == NO) {
        _editBtn.selected = YES;
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
        
    }else if (_editBtn.selected != NO){
        _editBtn.selected = NO;
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        NSArray *array = [NSArray arrayWithArray:self.filmClassTitleArray];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:kFilmClassTitleArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.refreshHomePageBlock();//调整后刷新首页
        NSLog(@">>>>>>>>>>完成编辑>>>>>>>>>>>>");
    }
}

- (void)setFilmClassModelDictionary
{
    self.filmClassModelDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    for (SCFilmClassModel *filmClassModel in self.filmClassArray) {
        NSString *key = filmClassModel._FilmClassName;
        [_filmClassModelDictionary setObject:filmClassModel forKey:key];
    }
}

- (void)loadCollectionView
{
    //        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
    // 自定义流水布局
    LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    
    _collView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collView.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    _collView.dataSource = self;
    _collView.delegate = self;
    //    _collView.scrollEnabled = NO;//禁止滚动
    [self.view addSubview:_collView];
    
    
    // 注册cell、sectionHeader、sectionFooter
    [_collView registerNib:[UINib nibWithNibName:@"SCChannelCatalogueCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
}


#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filmClassArray.count + 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCChannelCatalogueCell *cell = [_collView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    [cell setModel:self.filmClassTitleArray IndexPath:indexPath];
    
    return cell;
}

/** 段头段尾设置 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [_collView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        headerView.backgroundColor = [UIColor grayColor];
        
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footerView = [_collView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        if(footerView == nil)
        {
            footerView = [[UICollectionReusableView alloc] init];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 350, 30)];
        label.text = @"—o 点击编辑，可长按分类栏目进行排序 o—";
        label.textColor = [UIColor colorWithHex:@"#666666"];
        label.font = [UIFont systemFontOfSize:15.f];
        [footerView addSubview:label];
        footerView.backgroundColor = [UIColor whiteColor];
        
        return footerView;
    }
    
    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_editBtn.selected == YES) {//编辑模式
        if (indexPath.row == 0) return NO; // 🚫第1个单元格不让移动
        if (indexPath.row == 1) return NO; // 🚫第2个单元格不让移动
        if (indexPath.row == 2) return NO; // 🚫第3个单元格不让移动
        if (indexPath.row == 3) return NO; // 🚫第4个单元格不让移动
        if (indexPath.row == _filmClassTitleArray.count+5-1) return NO; // 🚫最后一个单元格不让移动
        return YES;
        
    } else {
        return NO;
    }
}

//- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath
//{
//    /* 判断两个indexPath参数的section属性, 是否在一个分区 */
//    if (originalIndexPath.section != proposedIndexPath.section) {
//        return originalIndexPath;
//    } else if (proposedIndexPath.section == 0 && proposedIndexPath.item == 0) {
//        return originalIndexPath;
//    } else {
//        return proposedIndexPath;
//    }
//}
//
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
//
//
//}

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

#pragma mark - LXReorderableCollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.row-4 < self.filmClassTitleArray.count && toIndexPath.row-4 < self.filmClassTitleArray.count) {
        
        NSString *filmClassTitle = self.filmClassTitleArray[fromIndexPath.row-4];
        [self.filmClassTitleArray removeObject:filmClassTitle];
        [self.filmClassTitleArray insertObject:filmClassTitle atIndex:toIndexPath.row-4];
    }
}


- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (toIndexPath.row == 0) return NO; // 🚫禁止移动到第1个cell
    if (toIndexPath.row == 1) return NO; // 🚫禁止移动到第2个cell
    if (toIndexPath.row == 2) return NO; // 🚫禁止移动到第3个cell
    if (toIndexPath.row == 3) return NO; // 🚫禁止移动到第4个cell
    if (toIndexPath.row == _filmClassTitleArray.count+5-1) return NO; // 🚫禁止移动到最后一个cell
    
    return YES;
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DONG_Log(@"政府");
        // 数据采集
        NSString *keyValue = @"web";
        [UserInfoManager addCollectionDataWithType:@"FilmClass" filmName:@"政府" mid:keyValue];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hlj.gov.cn/szfsjz/index.shtml"]];
        
    } else if (indexPath.row == 1) {
        DONG_Log(@"先锋网");
        // 数据采集
        NSString *keyValue = @"web";
        [UserInfoManager addCollectionDataWithType:@"FilmClass" filmName:@"先锋网" mid:keyValue];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ljxfw.gov.cn/dyjy"]];
        
    } else if (indexPath.row == 2) {
        DONG_Log(@"直播");
        // 数据采集
        NSString *keyValue = @"app";
        [UserInfoManager addCollectionDataWithType:@"FilmClass" filmName:@"直播" mid:keyValue];
        
        SCLiveViewController *liveVC = [[SCLiveViewController alloc] initWithWithTitle:@"直播"];
        [self.navigationController pushViewController:liveVC animated:YES];
        
    } else if (indexPath.row == 3) {
        DONG_Log(@"营业厅");
        // 数据采集
        NSString *keyValue = @"web";
        [UserInfoManager addCollectionDataWithType:@"FilmClass" filmName:@"营业厅" mid:keyValue];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.96396.cn/mobile/"]];
        
    } else if (indexPath.row == _filmClassTitleArray.count+5-1) {
        DONG_Log(@"萌宝");
        SCLovelyBabyCenterVC *babyCenterVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCLovelyBabyCenterVC");
        [self.navigationController pushViewController:babyCenterVC animated:YES];

        
    } else {
    
        if (_filmClassArray.count != 0) {
            SCChannelCategoryVC *channelVC  = [[SCChannelCategoryVC alloc] initWithWithTitle:_filmClassTitleArray[indexPath.row-4]];
            channelVC.bannerFilmModelArray = self.bannerFilmModelArray;
            
            NSString *key = _filmClassTitleArray[indexPath.row-4];
            channelVC.filmClassModel = _filmClassModelDictionary[key];
            channelVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:channelVC animated:YES];
        }
    }
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}


@end
