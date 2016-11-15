//
//  SCDownloadView.m
//  SCDSJDownloadView
//
//  Created by yesdgq on 16/11/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDSJDownloadView.h"
#import "SCDSJDownloadCell.h"

@interface SCDSJDownloadView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SCDSJDownloadView

static NSString *const cellId = @"cellId";

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setBackButton];
        [self setCollectionView];
    }
    return self;
}

#pragma mark - private method
- (void)setBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(15, 10, 70, 15);
    [backBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [backBtn setTitle:@"下载" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithHex:@"#666666"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"Back_Arrow"] forState:UIControlStateNormal];
    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    backBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(removeDownloadView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backBtn];
}

- (void)removeDownloadView {
    if (self.backBtnBlock) {
        self.backBtnBlock();
    }
}

- (void)setCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, kMainScreenWidth, ViewHeight(self)-30) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //0.初始化collectionView
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    [collectionView registerNib:[UINib nibWithNibName:@"SCDSJDownloadCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    self.collectionView = collectionView;
    [self addSubview:collectionView];
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
    SCDSJDownloadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
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

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//点击某item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}





@end
