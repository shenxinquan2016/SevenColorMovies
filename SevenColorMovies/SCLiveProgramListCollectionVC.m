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
    
    //0.初始化collectionView
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical=YES;
    //1.注册cell、sectionHeader、sectionFooter
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCLiveProgramListCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
    
    //2.第一次进入滚动到正在播放的位置
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_index inSection:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    });
    
    //4.自动播放下一个节目发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCellStateWhenPlayNextProgrom:) name:ChangeCellStateWhenPlayNextProgrom object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLastCellToUnselectedState:) name:ChangeCellStateWhenClickProgramList object:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

- (void)viewDidAppear{
    [super viewDidAppear:YES];
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChangeCellStateWhenPlayNextProgrom object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChangeCellStateWhenClickProgramList object:nil];
    // 播放列表点击标识置为0
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:k_for_Live_selectedViewIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:k_for_Live_selectedCellIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc{
    
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
    //通过改变cell对应model的onLive属性来改变选中cell为选中状态
    _model = _liveProgramModelArr[indexPath.row];
    _model.onLive = YES;
    
    if ([_model.programName isEqualToString:@"结束"]) return;//最后一行没有播放信息
    if (_model.programState == WillPlay){
        [MBProgressHUD showSuccess:@"节目暂未播出"];
        return;
    }
    
    SCLiveProgramListCell *cell = (SCLiveProgramListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.model = _model;
    
    NSInteger selectedViewIndex = [[NSUserDefaults standardUserDefaults] integerForKey:k_for_Live_selectedViewIndex];
    if (_viewIdentifier == selectedViewIndex) {//点击同一页
        
        NSInteger selectedCellIndex = [[NSUserDefaults standardUserDefaults] integerForKey:k_for_Live_selectedCellIndex];
        if (indexPath.row != selectedCellIndex){
            
            //通知选中的cell转为非选中状态
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCellStateWhenClickProgramList object:indexPath];
        }
    }else{//点击不同页
        //通知选中的cell转为非选中状态
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCellStateWhenClickProgramList object:indexPath];
    }
    //将当前页和选中的行index保存到本地
    [[NSUserDefaults standardUserDefaults] setInteger:_viewIdentifier forKey:k_for_Live_selectedViewIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:k_for_Live_selectedCellIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //点击播放新的节目------->播放动作
    if (self.clickToPlayBlock) {
        
        //将点击行和点击行的下一行model都传给播放器（以便获取下个节目的开始时间即本节目的结束时间）
        //将该页的数组传过去，以便做循环播放
        if (indexPath.row+1 < _liveProgramModelArr.count) {
            
            SCLiveProgramModel *nextProgramModel = _liveProgramModelArr[indexPath.row+1];
            
            self.clickToPlayBlock(_model, nextProgramModel, _liveProgramModelArr);
        }else{
            
            self.clickToPlayBlock(_model, nil, _liveProgramModelArr);
        }
    }
}

//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //通过改变cell对应model的onLive属性来改变cell字体颜色
    //    _model = _liveProgramModelArr[indexPath.row];
    //    _model.onLive = NO;
    //    SCLiveProgramListCell *cell = (SCLiveProgramListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.model = _model;
    
    
}

#pragma mark - Event reponse
- (void)changeCellStateWhenPlayNextProgrom:(NSNotification *)notification{
    
    NSDictionary *dic = notification.object;
    SCLiveProgramModel *nextPlayModel = dic[@"model"];//即将播出节目的model
    NSUInteger identifier = [dic[@"index"] integerValue];
    
    if (_viewIdentifier == identifier) {//只要求指定的页面收到消息后做出反应
        
        NSUInteger index = [_liveProgramModelArr indexOfObject:nextPlayModel];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index-1 inSection:0];
        NSIndexPath *nextPlayIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        //获取正在播出和即将播出的cell
        SCLiveProgramListCell *cell = (SCLiveProgramListCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        SCLiveProgramListCell *nextPlayCell = (SCLiveProgramListCell *)[self.collectionView cellForItemAtIndexPath:nextPlayIndexPath];
        //改变model onLive状态
        SCLiveProgramModel *model = _liveProgramModelArr[index-1];
        model.onLive = NO;
        nextPlayModel.onLive = YES;
        //给cell model赋值以给变cell字体显示
        cell.model = model;
        nextPlayCell.model = nextPlayModel;
        
        //将当前页和即将播出的行index保存到本地
        [[NSUserDefaults standardUserDefaults] setInteger:_viewIdentifier forKey:k_for_Live_selectedViewIndex];
        [[NSUserDefaults standardUserDefaults] setInteger:index forKey:k_for_Live_selectedCellIndex];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)changeLastCellToUnselectedState:(NSNotification *)notification{
    
    NSInteger selectedViewIndex = [[NSUserDefaults standardUserDefaults] integerForKey:k_for_Live_selectedViewIndex];
    if (_viewIdentifier == selectedViewIndex) {
        
        NSInteger selectedCellIndex = [[NSUserDefaults standardUserDefaults] integerForKey:k_for_Live_selectedCellIndex];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedCellIndex inSection:0];

        SCLiveProgramListCell *cell = (SCLiveProgramListCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        //改变model onLive状态
        SCLiveProgramModel *model = _liveProgramModelArr[selectedCellIndex];
        model.onLive = NO;
        
        //给cell model赋值使cell变为非选中状态
        cell.model = model;
        
    }
}


@end
