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
#import "SCHomePageSectionBGReusableView.h"

#import "SCRankViewController.h"//排行
#import "SCChannelCatalogueVC.h"//点播栏目更多
#import "SCChannelCategoryVC.h"//节目频道分类

#import "SCTeleplayPlayerVC.h"




@interface SCHomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collView;
/** tableView数据源 */
@property (nonatomic, strong) NSArray *dataSource;
/** tableView数据源 */
@property (nonatomic, copy) NSMutableArray *sectionArr;
/** tableView数据源 */
@property (nonatomic, copy) NSMutableArray *selDemandChannelArr;
/** 点播栏数据源 */
@property (nonatomic, copy) NSArray *selectedItemArr;

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
    _bannerImageUrlArr = [NSMutableArray arrayWithObjects:@"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=风景&step_word=&pn=1&spn=0&di=170050045220&pi=&rn=1&tn=baiduimagedetail&is=&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=3392936970%2C1240433668&os=2295359357%2C2115524380&simid=4131811244%2C715106156&adpicid=0&ln=1000&fr=&fmq=1459502303089_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic1.nipic.com%2F2008-10-30%2F200810309416546_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3F8AzdH3F90AzdH3F09j81dmjujwvudmb_z%26e3Bip4s&gsm=0&rpstart=0&rpnum=0",@"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=风景&step_word=&pn=2&spn=0&di=201852181960&pi=&rn=1&tn=baiduimagedetail&is=&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=4122174456%2C238506339&os=2534432078%2C2727372066&simid=4261751445%2C601149228&adpicid=0&ln=1000&fr=&fmq=1459502303089_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic3.nipic.com%2F20090605%2F2166702_095614055_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3F8l8mn0c_z%26e3Bip4s&gsm=0&rpstart=0&rpnum=0",@"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=风景&step_word=&pn=3&spn=0&di=55559078410&pi=&rn=1&tn=baiduimagedetail&is=&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=2363027421%2C438461014&os=388455896%2C106895408&simid=4088773055%2C716705165&adpicid=0&ln=1000&fr=&fmq=1459502303089_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic24.nipic.com%2F20121003%2F10754047_140022530392_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3Fmlamc09_z%26e3Bip4s&gsm=0&rpstart=0&rpnum=0", nil];
    
    _sectionArr = [NSMutableArray arrayWithObjects:@"", @"观看记录",@"电影",@"电视剧",@"少儿剧场",@"动漫",@"综艺",nil];
    _selDemandChannelArr = [NSMutableArray arrayWithObjects:@"直播", @"电影",@"电视剧",@"少儿",@"游戏",@"动漫",@"综艺",@"更多",nil];
    //3.添加collectionView
    
    [self addCollView];
    
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
    
    if (section == 0) return self.selectedItemArr.count;
    else return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSDictionary *dict = [_selectedItemArr objectAtIndex:indexPath.row];
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
    if (indexPath.section ==0) {//点播栏
        if (indexPath.row == 7) {
            SCChannelCatalogueVC *moreView = [[SCChannelCatalogueVC alloc] init];
            moreView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreView animated:YES];
        }else{
            //设置返回键标题
            NSDictionary *dict = [_selectedItemArr objectAtIndex:indexPath.row];
            SCChannelCategoryVC *channelVC  = [[SCChannelCategoryVC alloc] initWithWithTitle:[dict.allValues objectAtIndex:0]];
            channelVC.hidesBottomBarWhenPushed = YES;
  
            [self.navigationController pushViewController:channelVC animated:YES];
        }
        
    }else{
        
        NSLog(@"======点击=====");
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
    //添加banner页
    _bannerView = [[SCSycleBanner alloc] initWithView:nil];
    _bannerView.delegate = self;
    [_collView addSubview:_bannerView];
    _bannerView.imageURLStringsGroup = _bannerImageUrlArr;
    
    // 注册cell、sectionHeader、sectionFooter
    //点播栏cell
    [_collView registerNib:[UINib nibWithNibName:@"SCDemandChannelItemCell" bundle:nil] forCellWithReuseIdentifier:@"SCDemandChannelItemCell"];
    
    [_collView registerNib:[UINib nibWithNibName:@"SCRankTopRowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellIdOther"];//其他cell
    
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
    return _collView;
}

#pragma mark- Getters and Setters
- (NSArray *)selectedItemArr{
    if (!_selectedItemArr) {
        NSArray *array =@[@{@"Live" : @"直播"}, @{@"Moive" : @"电影"}, @{@"Teleplay" : @"电视剧"}, @{@"ChildrenTheater" : @"少儿剧场"}, @{@"Cartoon" : @"动漫"}, @{@"Arts" : @"综艺"}, @{@"SpecialTopic" : @"专题"}, @{@"GeneralChannel" : @"更多"}];
        
        _selectedItemArr = array;
    }
    return _selectedItemArr;
}


- (NSArray *)dataSource{
    if (!_dataSource) {
        NSArray *array = @[@[@{@"FontSize":@"字体大小"},@{@"InfoPushSetting":@"推送设置"}],@[@{@"ClearCache":@"清理缓存"}],
                           @[@{@"FontSize":@"字体大小"},@{@"InfoPushSetting":@"推送设置"}],@[@{@"ClearCache":@"清理缓存"}],
                           @[@{@"FontSize":@"字体大小"},@{@"InfoPushSetting":@"推送设置"}],@[@{@"ClearCache":@"清理缓存"}],
                           @[@{@"FontSize":@"字体大小"},@{@"InfoPushSetting":@"推送设置"}],@[@{@"ClearCache":@"清理缓存"}],
                           @[@{@"FontSize":@"字体大小"},@{@"InfoPushSetting":@"推送设置"}],@[@{@"ClearCache":@"清理缓存"}],
                           @[@{@"FontSize":@"字体大小"},@{@"InfoPushSetting":@"推送设置"}],@[@{@"ClearCache":@"清理缓存"}],
                           @[@{@"About":@"关于"},@{@"Privacy":@"隐私政策"},@{@"AppStoreComment":@"去App Store评分"}],@[@{@"SignOut":@"退出登录"}]];
        _dataSource = array;
    }
    return _dataSource;
}



@end
