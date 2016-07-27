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

@interface SCChannelCatalogueVC ()<LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout,UICollectionViewDelegate>
/**  */
@property (nonatomic, strong) UICollectionView *collView;

@property (nonatomic, copy) NSMutableArray *cellAttributesArray;
@property (nonatomic, copy) NSMutableArray *selectedArray;



@end

@implementation SCChannelCatalogueVC

static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    //1.初始化数组
    _cellAttributesArray = [NSMutableArray arrayWithCapacity:0];
    _selectedArray = [NSMutableArray arrayWithCapacity:0];
    
    //    self.allItemsArr = [NSArray array];
    self.selectedItemArr = [NSArray array];
    
    //2.添加cellectionView
    [self loadCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
    // 自定义流水布局
//    LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    
    _collView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collView.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    _collView.dataSource = self;
    _collView.delegate = self;
    //    _collView.scrollEnabled = NO;//禁止滚动
    [self.view addSubview:_collView];
    
    
    // 9.0以上版本适用 使用系统布局
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
            //此处给其增加长按手势，用此手势触发cell移动效果
            UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sortChannelItem:)];
            longGesture.minimumPressDuration = 0.2;
            [_collView addGestureRecognizer:longGesture];
        }
    
    // 注册cell、sectionHeader、sectionFooter
    [_collView registerNib:[UINib nibWithNibName:@"SCChannelCatalogueCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
}


#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.allItemsArr.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.allItemsArr.count > section) {
        NSArray *array = self.allItemsArr[section];
        return array.count;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < _allItemsArr.count) {
        NSArray *array = self.allItemsArr[indexPath.section];
        if (indexPath.row < array.count) {
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            SCChannelCatalogueCell *cell = [_collView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            [cell setModel:dict IndexPath:indexPath];
            
            return cell;
        }
    }
    
    return nil;
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 350, 30)];
        label.text = @"—o 点击编辑，可长按分类栏目进行排序 o—";
        [footerView addSubview:label];
        footerView.backgroundColor = [UIColor whiteColor];
        
        return footerView;
    }
    
    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


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

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    id objc = [self.allItemsArr objectAtIndex:fromIndexPath.item];
    //从资源数组中移除该数据
    [self.allItemsArr removeObject:objc];
    //将数据插入到资源数组中的目标位置上
//    [self.allItemsArr insertObject:objc atIndex:toIndexPath.item];
}


- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    return YES;
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"======点击=====");
}


//#pragma mark - 9.0以上版本适用以下方法 (保留代码)
- (void)sortChannelItem:(UILongPressGestureRecognizer *)recognizer {
    //判断手势状态
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [_collView  indexPathForItemAtPoint:[recognizer locationInView:_collView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [_collView  beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [_collView updateInteractiveMovementTargetPosition:[recognizer locationInView:_collView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [_collView  endInteractiveMovement];
            break;
        default:
            [_collView  cancelInteractiveMovement];
            break;
    }
}


- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath  {
    /* 判断两个indexPath参数的section属性, 是否在一个分区 */
    if (originalIndexPath.section != proposedIndexPath.section) {
        return originalIndexPath;
    } else if (proposedIndexPath.section == 0 && proposedIndexPath.item == 0) {
        return originalIndexPath;
    } else {
        return proposedIndexPath;
    }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    id objc = [self.allItemsArr objectAtIndex:sourceIndexPath.item];
//    //从资源数组中移除该数据
//    [self.allItemsArr removeObject:objc];
//    //将数据插入到资源数组中的目标位置上
//    [self.allItemsArr insertObject:objc atIndex:destinationIndexPath.item];
}



#pragma mark- Getters and Setters
- (NSArray *)allItemsArr{
    if (!_allItemsArr) {
        NSArray *array =@[@[@{@"Live" : @"直播"}, @{@"Moive" : @"电影"}, @{@"Teleplay" : @"电视剧"}, @{@"ChildrenTheater" : @"少儿剧场"},@{@"Cartoon" : @"动漫"}, @{@"Arts" : @"综艺"}, @{@"CinemaPlaying" : @"院线热映"},@{@"SpecialTopic" : @"专题"}, @{@"LeaderBoard" : @"排行榜"}, @{@"OverseasFilm" : @"海外剧场"},@{@"Children" : @"少儿"}, @{@"Life" : @"生活"}, @{@"Music" : @"音乐"},@{@"Game" : @"游戏"}, @{@"Documentary" : @"纪录片"}, @{@"GeneralChannel" : @"通用频道"}]];
        
        _allItemsArr = [array copy];
    }
    return _allItemsArr;
}

@end
