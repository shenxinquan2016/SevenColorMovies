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

@implementation SCMoiveAllEpisodesCollectionVC

{
    SCFilmSetModel *filmSetModel_;
    NSIndexPath *selectingIndexPath_;
}

static NSString *const cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0.初始化collectionView
    self.collectionView.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    self.collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCMovieEpisodeCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
    //自动播放下一个节目发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCellStateWhenPlayNextProgrom:) name:ChangeCellStateWhenPlayNextProgrom object:nil];
    //取消上一个cell的选中状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLastCellToUnselectedState:) name:ChangeCellStateWhenClickProgramList object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChangeCellStateWhenPlayNextProgrom object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChangeCellStateWhenClickProgramList object:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_for_VOD_selectedViewIndex];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_for_VOD_selectedCellIndex];

}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCMovieEpisodeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.filmSetModel = _dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(kMainScreenWidth-24-32)/5,(kMainScreenWidth/6-15)};
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

//点击某item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectingIndexPath_ = indexPath;
    //通过改变cell对应model的onLive属性来改变选中cell为选中状态
    filmSetModel_ = _dataSource[indexPath.row];
    filmSetModel_.onLive = YES;
    
    SCMovieEpisodeCell *cell = (SCMovieEpisodeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.filmSetModel = filmSetModel_;
    
    //通知选中的cell转为非选中状态
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCellStateWhenClickProgramList object:indexPath];
    
    //将当前页和选中的行index保存到本地
    [[NSUserDefaults standardUserDefaults] setInteger:_viewIdentifier forKey:k_for_VOD_selectedViewIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:k_for_VOD_selectedCellIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    //点击播放新的节目------->播放动作
//    if (self.clickToPlayBlock) {
//        
//        //将点击行和点击行的下一行model都传给播放器（以便获取下个节目的开始时间即本节目的结束时间）
//        //将该页的数组传过去，以便做循环播放
//        if (indexPath.row+1 < _liveProgramModelArr.count) {
//            
//            SCLiveProgramModel *nextProgramModel = _liveProgramModelArr[indexPath.row+1];
//            
//            self.clickToPlayBlock(_model, nextProgramModel, _liveProgramModelArr);
//        }else{
//            
//            self.clickToPlayBlock(_model, nil, _liveProgramModelArr);
//        }
//    }
}

- (void)changeLastCellToUnselectedState:(NSNotification *)notification{
    
    NSInteger selectedViewIndex = [[NSUserDefaults standardUserDefaults] integerForKey:k_for_VOD_selectedViewIndex];
    
    if (_viewIdentifier == selectedViewIndex) {
        
        NSInteger selectedCellIndex = [[NSUserDefaults standardUserDefaults] integerForKey:k_for_VOD_selectedCellIndex];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedCellIndex inSection:0];
        if (indexPath == selectingIndexPath_) return;//重复点击同一个cell，return
        SCMovieEpisodeCell *cell = (SCMovieEpisodeCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        //改变model onLive状态
        SCFilmSetModel *model = _dataSource[indexPath.row];
        model.onLive = NO;
        
        //给cell model赋值使cell变为非选中状态
        cell.filmSetModel = model;
        
    }
}

@end
