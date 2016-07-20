//
//  SCHomePageViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCHomePageViewController.h"
#import "SCSycleBanner.h"
#import "SCDemandChannelCell.h" //tableviewCell
#import "SCDemandChannelItemCell.h"//colectionViewCell
#import "SCRankTopCell.h"//收看记录cell
#import "SCRankViewController.h"//排行


static  CGFloat const kSectionOneCellHeight = 185.f;
static  CGFloat const kSectionTwoCellHeight = 185.f;

@interface SCHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
/** tableView数据源 */
@property (nonatomic, strong) NSArray *dataSource;
/** tableView数据源 */
@property (nonatomic, copy) NSMutableArray *sectionArr;
/** tableView数据源 */
@property (nonatomic, copy) NSMutableArray *selDemandChannelArr;

@property (nonatomic, strong) SCSycleBanner *bannerView;
/** banner页图片地址数组 */
@property (nonatomic, copy) NSMutableArray *bannerImageUrlArr;

@end

@implementation SCHomePageViewController

#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#dddddd"];
    //1. 设置导航栏的颜色(效果只作用当前页面）
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:@"#F0F1F2"]];
    // 设置导航栏的颜色（效果作用到所有页面）
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor colorWithHex:@"#F0F1F2"]];
    //2. 初始化数组
    _bannerImageUrlArr = [NSMutableArray arrayWithObjects:@"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=风景&step_word=&pn=1&spn=0&di=170050045220&pi=&rn=1&tn=baiduimagedetail&is=&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=3392936970%2C1240433668&os=2295359357%2C2115524380&simid=4131811244%2C715106156&adpicid=0&ln=1000&fr=&fmq=1459502303089_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic1.nipic.com%2F2008-10-30%2F200810309416546_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3F8AzdH3F90AzdH3F09j81dmjujwvudmb_z%26e3Bip4s&gsm=0&rpstart=0&rpnum=0",@"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=风景&step_word=&pn=2&spn=0&di=201852181960&pi=&rn=1&tn=baiduimagedetail&is=&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=4122174456%2C238506339&os=2534432078%2C2727372066&simid=4261751445%2C601149228&adpicid=0&ln=1000&fr=&fmq=1459502303089_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic3.nipic.com%2F20090605%2F2166702_095614055_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3F8l8mn0c_z%26e3Bip4s&gsm=0&rpstart=0&rpnum=0",@"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=风景&step_word=&pn=3&spn=0&di=55559078410&pi=&rn=1&tn=baiduimagedetail&is=&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=2363027421%2C438461014&os=388455896%2C106895408&simid=4088773055%2C716705165&adpicid=0&ln=1000&fr=&fmq=1459502303089_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic24.nipic.com%2F20121003%2F10754047_140022530392_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3Fmlamc09_z%26e3Bip4s&gsm=0&rpstart=0&rpnum=0", nil];
    
    _sectionArr = [NSMutableArray arrayWithObjects:@"", @"观看记录",@"电影",@"电视剧",@"少儿剧场",@"动漫",@"综艺",nil];
    _selDemandChannelArr = [NSMutableArray arrayWithObjects:@"直播", @"电影",@"电视剧",@"少儿",@"游戏",@"动漫",@"综艺",@"更多",nil];
    //3.添加tableView
    [self addTableView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Initialize

#pragma mark- CustomDelegate


#pragma mark- Event reponse

#pragma mark- Public methods

#pragma mark- Private methods
- (void)addTableView{
    [self.view addSubview:self.tableView];
    [_tableView setFrame:self.view.bounds];
}

//section header
- (UIView *)addSectionHeaderViewWithTitle:(NSString *)title tag:(NSInteger)tag{
    UIView *view = [[UIImageView alloc] init];
    view.frame = CGRectMake(0, 0, kMainScreenWidth, 40.f);
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
        make.left.equalTo(view).and.offset(10);
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


#pragma mark- UITableViewDataSource && UITableViewDataDelegate
-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return _sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {//频道点播
        SCDemandChannelCell *cell = [SCDemandChannelCell cellWithTableView:tableView];
        
        return cell;
        
    }else{
        
        SCRankTopCell *cell = [SCRankTopCell cellWithTableView:tableView];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kSectionOneCellHeight;
    }else return kSectionTwoCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"======indexPath.section:%ld",indexPath.section);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else return 40.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [self addSectionHeaderViewWithTitle:_sectionArr[section] tag:section];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(SCDemandChannelCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    }
}

#pragma mark  UICollectionViewDataSource && delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SCDemandChannelItemCell *cell = [SCDemandChannelItemCell cellWithCollectionView:collectionView indexPath:indexPath];
//    cell.channelName = _selDemandChannelArr[indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了  ---=== %ld",(long)indexPath.item);
}


#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    //    ALERT(@"点击banner");
    
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    // NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
}


#pragma mark- Getters and Setters
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        _tableView = tableView;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //添加banner页
        _bannerView = [[SCSycleBanner alloc] initWithView:nil];
        _bannerView.delegate = self;
        self.tableView.tableHeaderView = _bannerView;
        _bannerView.imageURLStringsGroup = _bannerImageUrlArr;
    }
    
    return _tableView;
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
