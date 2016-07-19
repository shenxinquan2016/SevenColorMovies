//
//  SCHomePageViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCHomePageViewController.h"
#import "SCSycleBanner.h"

@interface SCHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIButton *leftBBI;//商标
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) SCSycleBanner *bannerView;
/**
 *  banner页图片地址数组
 */
@property (nonatomic, copy) NSMutableArray *bannerImageUrlArr;

@end

@implementation SCHomePageViewController

#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏的主题(效果只作用当前页面）
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:@"#0E2747"]];
    // 设置导航栏的主题（效果作用到所有页面）
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor colorWithHex:@"#0E2747"]];
    //初始化数组
    _bannerImageUrlArr = [NSMutableArray arrayWithObjects:@"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=风景&step_word=&pn=1&spn=0&di=170050045220&pi=&rn=1&tn=baiduimagedetail&is=&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=3392936970%2C1240433668&os=2295359357%2C2115524380&simid=4131811244%2C715106156&adpicid=0&ln=1000&fr=&fmq=1459502303089_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic1.nipic.com%2F2008-10-30%2F200810309416546_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3F8AzdH3F90AzdH3F09j81dmjujwvudmb_z%26e3Bip4s&gsm=0&rpstart=0&rpnum=0",@"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=风景&step_word=&pn=2&spn=0&di=201852181960&pi=&rn=1&tn=baiduimagedetail&is=&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=4122174456%2C238506339&os=2534432078%2C2727372066&simid=4261751445%2C601149228&adpicid=0&ln=1000&fr=&fmq=1459502303089_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic3.nipic.com%2F20090605%2F2166702_095614055_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3F8l8mn0c_z%26e3Bip4s&gsm=0&rpstart=0&rpnum=0",@"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=风景&step_word=&pn=3&spn=0&di=55559078410&pi=&rn=1&tn=baiduimagedetail&is=&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=2363027421%2C438461014&os=388455896%2C106895408&simid=4088773055%2C716705165&adpicid=0&ln=1000&fr=&fmq=1459502303089_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic24.nipic.com%2F20121003%2F10754047_140022530392_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3Fmlamc09_z%26e3Bip4s&gsm=0&rpstart=0&rpnum=0", nil];
    
    //添加商户商标
    [self addLeftBBI];
    //添加tableView
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

#pragma mark- private methods
- (void)addLeftBBI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 30);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"BusinessLogo"] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -6;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    _leftBBI = btn;
}

- (void)addTableView{
    [self.view addSubview:self.tableView];
    [_tableView setFrame:self.view.bounds];
}
#pragma mark- UITableViewDataSource && UITableViewDataDelegate
-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource.count > section) {
        NSArray *array = self.dataSource[section];
        
        return array.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ALERT(@"点击");
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIImageView alloc] init];
    view.frame = CGRectMake(0, 0, kMainScreenWidth, 35.f);
    view.backgroundColor = [UIColor colorWithHex:@"#4DB1FC"];
    
    //战绩label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"战绩";
//    label.font = TL_FONT_NAME(DEFALUT_BOLD, 15);
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).and.offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 21));
        
    }];
    return view;
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
        
//        UIView *backgroundView = [[UIView alloc] init];
//        backgroundView.backgroundColor = [UIColor colorWithDesignIndex:9];
//        _tableView.backgroundView = backgroundView;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerClass:[LPNewsSettingCell class] forCellReuseIdentifier:kCellIdentify];
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
