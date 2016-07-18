//
//  SCHomePageViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCHomePageViewController.h"

@interface SCHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *leftBBI;//商标
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
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
    //添加商户商标
    [self addLeftBBI];

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
    [btn setBackgroundImage:[UIImage imageNamed:@"Business Logo"] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -6;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    _leftBBI = btn;

    
}
#pragma mark- NSNotification

#pragma mark- Getters and Setters
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        _tableView = tableView;
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //        _tableView.rowHeight = 51.f;
//        UIView *backgroundView = [[UIView alloc] init];
//        backgroundView.backgroundColor = [UIColor colorWithDesignIndex:9];
//        _tableView.backgroundView = backgroundView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerClass:[LPNewsSettingCell class] forCellReuseIdentifier:kCellIdentify];
    }
    
    return _tableView;
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        NSArray *array = @[@[@{@"FontSize":@"字体大小"},@{@"InfoPushSetting":@"推送设置"}],@[@{@"ClearCache":@"清理缓存"}],@[@{@"About":@"关于"},@{@"Privacy":@"隐私政策"},@{@"AppStoreComment":@"去App Store评分"}],@[@{@"SignOut":@"退出登录"}]];
        _dataSource = array;
    }
    return _dataSource;
}



@end
