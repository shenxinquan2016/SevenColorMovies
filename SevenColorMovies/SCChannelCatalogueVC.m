//
//  ChannelCatalogueVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  点播栏 —— 更多

#import "SCChannelCatalogueVC.h"
#import "SCChannelCatalogueCell.h"

@interface SCChannelCatalogueVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIGestureRecognizerDelegate>
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
    _cellAttributesArray = [NSMutableArray arrayWithCapacity:0];
    _selectedArray = [NSMutableArray arrayWithCapacity:0];

    //1.返回按钮
    [self addLeftBBI];
    //2.添加cellectionView
    [self loadCollectionView];
    //创建长按手势监听
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(myHandleTableviewCellLongPressed:)];
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
//    [_collView addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- private methods
- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    
    CGPoint pointTouch = [gestureRecognizer locationInView:_collView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        
        NSIndexPath *indexPath = [_collView indexPathForItemAtPoint:pointTouch];
        if (indexPath == nil) {
            NSLog(@"空");
            
            
        }else{
            
            NSLog(@"Section = %ld,Row = %ld",(long)indexPath.section,(long)indexPath.row);
            
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
}

- (void)addLeftBBI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 22);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setImage:[UIImage imageNamed:@"Back_Arrow"] forState:UIControlStateNormal];
    [btn setTitle: @"更多" forState: UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 19.0];
    [btn setTitleColor:[UIColor colorWithHex:@"#878889"]forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -6;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    _leftBBI = btn;
    
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
    _collView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collView.backgroundColor = [UIColor colorWithHex:@"dddddd"];
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
    return 16;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_collView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    // 拖动排序
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sortChannelItem:)];
    panGesture.delegate = self;
    [cell addGestureRecognizer:panGesture];

    
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


- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    
    
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(kMainScreenWidth/3-4),80};
}

/** CollectionView四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
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
    NSLog(@"======点击=====");
}


#pragma mark - 频道排序
- (void)sortChannelItem:(UIPanGestureRecognizer *)recognizer {
    UICollectionViewCell *cell = (UICollectionViewCell *)recognizer.view;
    NSIndexPath *cellIndexPath = [self.collView indexPathForCell:cell];
    BOOL ischange = YES;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (cellIndexPath == nil) {
                break;
            }
            // 获取所有cell的attributes
            [self.cellAttributesArray removeAllObjects];
            for (NSInteger i = 0 ; i < self.selectedArray.count; i++) {
                [self.cellAttributesArray addObject:[_collView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
            }
            break;
        case UIGestureRecognizerStateChanged:
            if (cellIndexPath.item != 0) {
                // 移动的相对位置
                CGPoint point = [recognizer translationInView:_collView];
                cell.center = CGPointMake(cell.center.x + point.x, cell.center.y + point.y);
                // 移动以后的坐标
                [recognizer setTranslation:CGPointMake(0, 0) inView:_collView];
                for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
                    CGRect rect = CGRectMake(attributes.center.x - 12, attributes.center.y - 12, 25, 25);
                    // 判断重叠区域
                    if (CGRectContainsPoint(rect, CGPointMake(recognizer.view.center.x, recognizer.view.center.y)) && (cellIndexPath != attributes.indexPath) && attributes.indexPath.item != 0) {
                        
                        //后面跟前面交换
                        if (cellIndexPath.row > attributes.indexPath.row) {
                            //交替操作0 1 2 3 变成（3<->2 3<->1 3<->0）
                            for (NSInteger index = cellIndexPath.row; index > attributes.indexPath.row; index -- ) {
                                [self.selectedArray exchangeObjectAtIndex:index withObjectAtIndex:index - 1];
                                // 交换CellIdentifier
//                                [self.cardCellIdentifierDictionary setObject:[NSString stringWithFormat:@"%@%ld",cardCellIdentifier,index - 1] forKey:@(index)];
//                                [self.cardCellIdentifierDictionary setObject:[NSString stringWithFormat:@"%@%ld",cardCellIdentifier,(long)index] forKey:@(index - 1)];
                            }
                        } else {
                            //前面跟后面交换
                            //交替操作0 1 2 3 变成（0<->1 0<->2 0<->3）
                            for (NSInteger index = cellIndexPath.row; index < attributes.indexPath.row; index ++ ) {
                                [self.selectedArray exchangeObjectAtIndex:index withObjectAtIndex:index + 1];
                                
//                                [self.cardCellIdentifierDictionary setObject:[NSString stringWithFormat:@"%@%ld",cardCellIdentifier,index + 1] forKey:@(index)];
//                                [self.cardCellIdentifierDictionary setObject:[NSString stringWithFormat:@"%@%ld",cardCellIdentifier,(long)index] forKey:@(index + 1)];
                            }
                        }
                        ischange = YES;
                        [_collView moveItemAtIndexPath:cellIndexPath toIndexPath:attributes.indexPath];
                    } else {
                        ischange = YES;
                    }
                }
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (!ischange) {
                cell.center = [_collView layoutAttributesForItemAtIndexPath:cellIndexPath].center;
//                [self updatePageindexMapToChannelItemDictionary];
            }
            break;
        default:
            break;
    }
}

@end
