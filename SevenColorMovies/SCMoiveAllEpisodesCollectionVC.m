//
//  SCMoiveAllEpisodesCollectionVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMoiveAllEpisodesCollectionVC.h"
#import "SCMovieEpisodeCell.h"
#import "SCFilmSetModel.h"
#import "PlayerViewRotate.h" // 旋转控制

@interface SCMoiveAllEpisodesCollectionVC ()


@end

@implementation SCMoiveAllEpisodesCollectionVC

{
    SCFilmSetModel *filmSetModel_;
    NSInteger _screenWith;
    NSInteger _screenHeight;
}

static NSString *const cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0.初始化collectionView
    self.collectionView.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    self.collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCMovieEpisodeCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
    if ([PlayerViewRotate isOrientationLandscape]) { // 全屏
        _screenWith = kMainScreenHeight;
        _screenHeight = kMainScreenWidth;
    } else {
        _screenWith = kMainScreenWidth;
        _screenHeight = kMainScreenHeight;
    }


    // 自动播放下一个节目发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCellStateWhenPlayNextVODFilm:) name:ChangeCellStateWhenPlayNextVODFilm object:nil];
    // 取消上一个cell的选中状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLastCellToUnselectedState:) name:ChangeCellStateWhenClickProgramList object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear{
    [super viewDidAppear:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChangeCellStateWhenPlayNextVODFilm object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChangeCellStateWhenClickProgramList object:nil];
    //3.点播播放列表点击标识置为0
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:k_for_VOD_selectedViewIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:k_for_VOD_selectedCellIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCMovieEpisodeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.filmSetModel = _dataSourceArray[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return (CGSize){(_screenWith-24-32)/5,(_screenWith/6-15)};
}

/** CollectionView四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 12, 0, 12);
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}

/** item垂直间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.f;
}

/** section Header 尺寸 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){_screenWith,0};
}

/** section Footer 尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){_screenWith,80};
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//点击某item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //通过改变cell对应model的onLive属性来改变选中cell为选中状态
    filmSetModel_ = _dataSourceArray[indexPath.row];
    filmSetModel_.onLive = YES;
    
    SCMovieEpisodeCell *cell = (SCMovieEpisodeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.filmSetModel = filmSetModel_;
    
    NSInteger selectedViewIndex = [[NSUserDefaults standardUserDefaults] integerForKey:k_for_VOD_selectedViewIndex];
    if (_viewIdentifier == selectedViewIndex) {//点击同一页
        
        NSInteger selectedCellIndex = [[NSUserDefaults standardUserDefaults] integerForKey:k_for_VOD_selectedCellIndex];
        if (indexPath.row != selectedCellIndex){
            
            //通知选中的cell转为非选中状态
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCellStateWhenClickProgramList object:indexPath];
        }
    }else{//点击不同页
        //通知选中的cell转为非选中状态
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCellStateWhenClickProgramList object:indexPath];
    }
    
    //将当前页和选中的行index保存到本地
    [[NSUserDefaults standardUserDefaults] setInteger:_viewIdentifier forKey:k_for_VOD_selectedViewIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:k_for_VOD_selectedCellIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *message = @{@"model" : filmSetModel_};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayVODFilmWhenClick object:message];
}

#pragma mark - Event reponse
- (void)changeLastCellToUnselectedState:(NSNotification *)notification{
    
    NSInteger selectedViewIndex = [[NSUserDefaults standardUserDefaults] integerForKey:k_for_VOD_selectedViewIndex];
    
    if (_viewIdentifier == selectedViewIndex) {
        
        NSInteger selectedCellIndex = [[NSUserDefaults standardUserDefaults] integerForKey:k_for_VOD_selectedCellIndex];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedCellIndex inSection:0];
        
        NSLog(@"++++++上次点击页:%lu++++++上次点击行:%lu+++++",selectedViewIndex,selectedCellIndex);
        
        SCMovieEpisodeCell *cell = (SCMovieEpisodeCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        //改变model onLive状态
        SCFilmSetModel *model = _dataSourceArray[indexPath.row];
        model.onLive = NO;
        
        //给cell model赋值使cell变为非选中状态
        cell.filmSetModel = model;
    }
}

- (void)changeCellStateWhenPlayNextVODFilm:(NSNotification *)notification{
    
    NSDictionary *dic = notification.object;
    SCFilmSetModel *filmSetModel = dic[@"nextFilmSetModel"];
    SCFilmSetModel *lastFilmSetModel = dic[@"lastFilmSetModel"];
    
    //当发生跳转页播放时 要将前一页最后一个cell置为非播放状态
    if ([self.dataSourceArray containsObject:lastFilmSetModel] && ([self.dataSourceArray indexOfObject:lastFilmSetModel] == self.dataSourceArray.count-1)) {
        
        lastFilmSetModel.onLive = NO;
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.dataSourceArray.count-1 inSection:0];
        SCMovieEpisodeCell *lastCell = (SCMovieEpisodeCell *)[self.collectionView cellForItemAtIndexPath:lastIndexPath];
        lastCell.filmSetModel = lastFilmSetModel;
    }
    
    //将下一个置为播放状态 前一个置为非播放状态
    if ([self.dataSourceArray containsObject:filmSetModel]) {
        
        NSInteger index = [self.dataSourceArray indexOfObject:filmSetModel];
        DONG_Log(@">>>>>>>>%lu<<<<<<<<<",index);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        //获取即将播出的cell
        SCMovieEpisodeCell *cell = (SCMovieEpisodeCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        filmSetModel.onLive = YES;
        cell.filmSetModel = filmSetModel;
        
        //取消正在播放的cell的选中状态
        lastFilmSetModel.onLive = NO;
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:index-1 inSection:0];
        SCMovieEpisodeCell *lastCell = (SCMovieEpisodeCell *)[self.collectionView cellForItemAtIndexPath:lastIndexPath];
        lastCell.filmSetModel = lastFilmSetModel;
        
        //将当前页和即将播出的行index保存到本地
        [[NSUserDefaults standardUserDefaults] setInteger:_viewIdentifier forKey:k_for_VOD_selectedViewIndex];
        [[NSUserDefaults standardUserDefaults] setInteger:index forKey:k_for_VOD_selectedCellIndex];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}



@end
