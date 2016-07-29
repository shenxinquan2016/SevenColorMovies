//
//  SCHomePageViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCHomePageViewController.h"
#import "SCSycleBanner.h"
#import "SCDemandChannelItemCell.h"//section 0 cell
#import "SCRankTopRowCollectionViewCell.h"//其他cell
#import "SCHomePageFlowLayout.h"
#import "SCHomePageSectionBGReusableView.h"//senction header

#import "SCRankViewController.h"//排行
#import "SCChannelCatalogueVC.h"//点播栏目更多
#import "SCChannelCategoryVC.h"//节目频道分类

#import "SCTeleplayPlayerVC.h"
#import "SCBannerModel.h"




@interface SCHomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,NSXMLParserDelegate>

@property (nonatomic, strong) UICollectionView *collView;
/** tableView数据源 */
@property (nonatomic, strong) NSArray *dataSource;
/** tableView数据源 */
@property (nonatomic, copy) NSMutableArray *sectionArr;

/** 点播栏所有item */
@property (nonatomic, copy) NSMutableArray *allItemsArr;

@property (nonatomic, strong) SCSycleBanner *bannerView;
/** banner页图片地址数组 */
@property (nonatomic, copy) NSMutableArray *bannerImageUrlArr;

@end

@implementation SCHomePageViewController

static NSString *const cellId = @"cellId";
static NSString *const cellIdOther = @"cellIdOther";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";


#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#dddddd"];
    //1. 设置导航栏的颜色(效果只作用当前页面）
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:@"#F0F1F2"]];
    // 设置导航栏的颜色（效果作用到所有页面）
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor colorWithHex:@"#F1F1F1"]];
    //2. 初始化数组
    _sectionArr = [NSMutableArray arrayWithObjects:@"", @"观看记录",@"电影",@"电视剧",@"少儿剧场",@"动漫",@"综艺",nil];
    _bannerImageUrlArr = [NSMutableArray arrayWithCapacity:0];
    
    
    
    
    
    
    
    //3.添加collectionView
    
    [self addCollView];
    
    
    //banner网络请求测试
    [requestDataManager requestBannerDataWithUrl:BannerURL parameters:nil success:^(id  _Nullable responseObject) {
        
        NSMutableArray *dataArr = responseObject[@"Film"];
        
        if (![dataArr isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dic in dataArr) {
                SCBannerModel *model = [SCBannerModel mj_objectWithKeyValues:dic];
                [_bannerImageUrlArr addObject:model._ImgUrlOriginal];
                NSLog(@"====url::::%@",model._ImgUrlOriginal);
                
            }
            
            //添加banner
            if (_bannerImageUrlArr.count > 0) {
                [self addBannerView];
                _bannerView.imageURLStringsGroup = _bannerImageUrlArr;
            }}else if (_bannerImageUrlArr.count == 0){
                if (_bannerView) {
                    [_bannerView removeFromSuperview];
                    
                }
            }
        
    } failure:^(id  _Nullable errorObject) {
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- Initialize

#pragma mark- CustomDelegate


#pragma mark- Event reponse

#pragma mark- Public methods

#pragma mark- Private methods
- (void)addCollView{
    [self.view addSubview:self.collView];
    [_collView setFrame:self.view.bounds];
}

//section header
- (UIView *)addSectionHeaderViewWithTitle:(NSString *)title tag:(NSInteger)tag{
    UIView *view = [[UIImageView alloc] init];
    view.frame = CGRectMake(0, 10, kMainScreenWidth, 40.f);
    view.backgroundColor = [UIColor whiteColor];
    //图标
    UIImageView *iv = [[UIImageView alloc] init];
    [iv setImage:[UIImage imageNamed:@"SectionLeftImage"]];
    [view addSubview:iv];
    [iv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(iv.image.size);
    }];
    //标题label
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    [label setFont :[UIFont fontWithName :@"Helvetica-Bold" size :20]];//加粗
    label.font = [UIFont systemFontOfSize:13.f];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).and.offset(12);
        make.size.mas_equalTo(CGSizeMake(100, 21));
        
    }];
    //右侧btn
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = tag;
    [btn setTitle: @"更多" forState: UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn setTitleColor:[UIColor colorWithHex:@"#878889"]forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Right_single_arrow"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
    [btn addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        
    }];
    view.userInteractionEnabled = YES;
    return view;
}

- (void)addBannerView{
    
    _bannerView = [[SCSycleBanner alloc] initWithView:nil];
    _bannerView.delegate = self;
    [_collView addSubview:_bannerView];
}


#pragma mark ---- responce
- (void)sectionClick:(UIButton *)sender{
    
    NSLog(@"=====section:%ld",sender.tag);
    SCRankViewController *rankView = DONG_INSTANT_VC_WITH_ID(@"HomePage", @"SCRankViewController");
    rankView.title = @"排行";
    rankView.view.backgroundColor = [UIColor whiteColor];
    rankView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rankView animated:YES];
}



#pragma mark ---- UICollectionView  DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _sectionArr.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) return 8;
    else return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSDictionary *dict = [self.allItemsArr objectAtIndex:indexPath.row];
        SCDemandChannelItemCell *cell = [SCDemandChannelItemCell cellWithCollectionView:collectionView indexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setModel:dict IndexPath:indexPath];
        
        return cell;
        
    }else{
        SCRankTopRowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdOther forIndexPath:indexPath];
        //        cell.backgroundColor = [UIColor purpleColor];
        
        return cell;
        
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        //                headerView.backgroundColor = [UIColor purpleColor];
        UIView *view = [self addSectionHeaderViewWithTitle:_sectionArr[indexPath.section] tag:indexPath.section];
        [headerView addSubview:view];
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        if(footerView == nil)
        {
            footerView = [[UICollectionReusableView alloc] init];
        }
        footerView.backgroundColor = [UIColor lightGrayColor];
        
        return footerView;
    }
    
    return nil;
}


#pragma mark ---- UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return (CGSize){(kMainScreenWidth-10-15)/4,70};
    }else{
        return (CGSize){(kMainScreenWidth-10-15)/3,180};
    }
    
}

/** Section 四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.f;
}

/** item垂直间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0){
        return 5;
    }else{
        return 5;
    }
}

/** section Header 尺寸 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return (CGSize){kMainScreenWidth,0};
    }else{
        
        return (CGSize){kMainScreenWidth,50};
    }
}

/** section Footer 尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return (CGSize){kMainScreenWidth,0};
}

#pragma mark ---- UICollectionView DataDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    
    NSLog(@"点击了  ---=== %ld",(long)indexPath.item);
    //设置返回键标题
    NSDictionary *dict = [_allItemsArr objectAtIndex:indexPath.row];
    
    if (indexPath.section ==0) {//点播栏
        if ([[dict.allValues objectAtIndex:0] isEqualToString:@"更多"]) {
            SCChannelCatalogueVC *moreView = [[SCChannelCatalogueVC alloc] initWithWithTitle:[dict.allValues objectAtIndex:0]];
            moreView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreView animated:YES];
        }else{
            
            SCChannelCategoryVC *channelVC  = [[SCChannelCategoryVC alloc] initWithWithTitle:[dict.allValues objectAtIndex:0]];
            channelVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:channelVC animated:YES];
        }
        
    }else{
        
        SCTeleplayPlayerVC *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
        teleplayPlayer.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:teleplayPlayer animated:YES];
        
    }
}



#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    //    ALERT(@"点击banner");
    NSLog(@">>>>>> 第%ld张图", (long)index);
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    // NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
}


#pragma mark- Getters and Setters
- (UICollectionView *)collView{
    SCHomePageFlowLayout *layout = [[SCHomePageFlowLayout alloc]init]; // 布局对象
    layout.alternateDecorationViews = YES;
    // 读取xib背景
    layout.decorationViewOfKinds = @[@"SCHomePageSectionBGReusableView"];
    
    _collView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    
    _collView.alwaysBounceVertical=YES;
    _collView.dataSource = self;
    _collView.delegate = self;
    
    _collView.contentInset = UIEdgeInsetsMake(167, 0, 0, 0);//留白添加banner
    
    // 注册cell、sectionHeader、sectionFooter
    //点播栏cell
    [_collView registerNib:[UINib nibWithNibName:@"SCDemandChannelItemCell" bundle:nil] forCellWithReuseIdentifier:@"SCDemandChannelItemCell"];
    
    [_collView registerNib:[UINib nibWithNibName:@"SCRankTopRowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellIdOther"];//其他cell
    
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
    return _collView;
}

#pragma mark- Getters and Setters
- (NSMutableArray *)allItemsArr{
    if (!_allItemsArr) {
        NSArray *array =@[@{@"Live" : @"直播"}, @{@"Moive" : @"电影"}, @{@"Teleplay" : @"电视剧"}, @{@"ChildrenTheater" : @"少儿剧场"},@{@"Cartoon" : @"动漫"}, @{@"Arts" : @"综艺"}, @{@"CinemaPlaying" : @"院线热映"},@{@"GeneralChannel" : @"更多"}, @{@"SpecialTopic" : @"专题"}, @{@"LeaderBoard" : @"排行榜"}, @{@"OverseasFilm" : @"海外剧场"},@{@"Children" : @"少儿"}, @{@"Life" : @"生活"}, @{@"Music" : @"音乐"},@{@"Game" : @"游戏"}, @{@"Documentary" : @"纪录片"}, @{@"GeneralChannel" : @"通用频道"}];
        
        _allItemsArr = [NSMutableArray arrayWithCapacity:0];
        [_allItemsArr addObjectsFromArray:array];
    }
    return _allItemsArr;
}


//解析会循环执行以下三个方法
//开始元素的时候执行此方法
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    NSLog(@"开始标签  %@", elementName);
    if ([elementName isEqualToString:@"student"]) {
        
        NSLog(@"=====%@",attributeDict);
        
    }
}

//找到文本的时候
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    NSLog(@"发现文本  %@", string);
}
//结束元素的时候
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    NSLog(@"结束标签  %@", elementName);
}




@end
