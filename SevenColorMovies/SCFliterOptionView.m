//
//  SCFliterOptionView.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/9/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  筛选项视图

#import "SCFliterOptionView.h"
#import "SCFliterOptionCell.h"

@interface SCFliterOptionView ()< UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout >

@property (weak, nonatomic) IBOutlet UILabel *filterTypeLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *filterOptionCollectionView;


@end

@implementation SCFliterOptionView

static NSString *const cellId = @"SCFliterOptionCell";

#pragma mark- Initialize
+ (instancetype)viewWithType:(NSString *)type{
    
    SCFliterOptionView *view = [[NSBundle mainBundle] loadNibNamed:@"SCFliterOptionView" owner:nil options:nil][0];
    view.filterTypeLabel.text = type;
        return view;
    
}

- (void)awakeFromNib{
    
    //添加一个自定义布局 必须继承UICollectionViewFlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //滚动方向  水平方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    [self.filterOptionCollectionView setCollectionViewLayout:layout];
    self.filterOptionCollectionView.backgroundColor = [UIColor lightGrayColor];
    self.filterOptionCollectionView.alwaysBounceHorizontal = YES;//只水平滑动
    
    self.filterOptionCollectionView.showsHorizontalScrollIndicator = NO;
    self.filterOptionCollectionView.delegate = self;
    self.filterOptionCollectionView.dataSource = self;
    
    [self.filterOptionCollectionView registerNib:[UINib nibWithNibName:@"SCFliterOptionCell" bundle:nil] forCellWithReuseIdentifier:cellId];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return (CGSize){65,21};
}

/** CollectionView四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}

/** item垂直间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

/** section Header 尺寸 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){0,0};
}


/** section Footer 尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){0,0};
}

#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"======点击=====");
    
    
    
}

@end
