//
//  SCLiveProgramListCollectionVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  直播节目列表

#import "SCLiveProgramListCollectionVC.h"
#import "SCLiveProgramListCell.h"

@interface SCLiveProgramListCollectionVC ()

@end


@implementation SCLiveProgramListCollectionVC
{
    SCLiveProgramModel *_model;
}
static NSString *const cellId = @"SCLiveProgramListCell";
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
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCLiveProgramListCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //滚动 却不滚动
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_index inSection:0];
    [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
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
    
    return self.liveProgramModelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SCLiveProgramListCell *cell = [SCLiveProgramListCell cellWithCollectionView:collectionView identifier:cellId indexPath:indexPath];
    cell.model = _liveProgramModelArr[indexPath.row];
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>

#pragma mark ---- UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return (CGSize){kMainScreenWidth,53};
}

/** CollectionView四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 5, 0);
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
    return (CGSize){kMainScreenWidth, 0};
}

#pragma mark ---- UICollectionViewDelegate
//点击某item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //通过改变cell对应model的onLive属性来改变cell字体颜色
    _model = _liveProgramModelArr[indexPath.row];
    _model.onLive = YES;
    SCLiveProgramListCell *cell = (SCLiveProgramListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.model = _model;
    
    /* 以下部分为控制首次进入时正在播出的cell字体颜色 */
    SCLiveProgramModel *model1 = _liveProgramModelArr[_index];//取正在播出的节目model
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_index inSection:0];
    SCLiveProgramListCell *cell1 = (SCLiveProgramListCell *)[collectionView cellForItemAtIndexPath:selectedIndexPath];
    
    if (indexPath.row != _index) {
        
        if (cell1.selected == YES) {
            model1.onLive = NO;//更改model状态以控制cell字体颜色
            cell1.model = model1;
            cell1.selected = NO;
        }
        
    }else if (indexPath.row == _index){
        model1.onLive = YES;
        cell1.model = model1;
    }
    
    
}

//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //通过改变cell对应model的onLive属性来改变cell字体颜色
    _model = _liveProgramModelArr[indexPath.row];
    _model.onLive = NO;
    SCLiveProgramListCell *cell = (SCLiveProgramListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.model = _model;
    
}


@end
