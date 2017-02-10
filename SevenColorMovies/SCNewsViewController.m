//
//  SCNewsViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCNewsViewController.h"
#import "Dong_NullDataView.h"
#import "SCHTMLViewController.h"
#import "SCNewsTableViewCell.h"
#import "SCNetRequsetManger+iCloudRemoteControl.h"

@interface SCNewsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SCNewsViewController

#pragma mark - ViewLife Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [CommonFunc noDataOrNoNetTipsString:@"功能建设中..." addView:self.view];
//    [Dong_NullDataView addImage:[UIImage imageNamed:@"NoBanner"] text:@"HTML" view:self.view];
//    [Dong_NullDataView addTapAction:self action:@selector(jkdljlj) view:self.view];
    
    
    self.dataArray = [NSMutableArray arrayWithObjects:@1, @2, @3, nil];
    
    
    //2.添加TableView
    [self loadTableView];
    
    [self requestData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://10.177.4.25/mobile/"]];
    // 取出当前的导航控制器
//    DONG_MAIN_AFTER(0.5, UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                    tabBarVC.selectedIndex = 0;);
    
//    [self loadHtml5View];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Private methods

- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F0F1F2"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.tableView];
    
}

- (void)loadHtml5View
{
    SCHTMLViewController *htmlVC = [[SCHTMLViewController alloc] init];
    htmlVC.hidesBottomBarWhenPushed = YES;
    htmlVC.urlString = @"http://10.177.4.25/mobile/";
    [self.navigationController pushViewController:htmlVC animated:YES];
    
}

#pragma mark- UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCNewsTableViewCell *cell = [SCNewsTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -  UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    return 56.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SCHTMLViewController *htmlVC = [[SCHTMLViewController alloc] init];
    htmlVC.hidesBottomBarWhenPushed = YES;
    
    if (indexPath.row == 0) {
        
        htmlVC.urlString = @"http://10.177.4.25/mobile/";
        
    } else if (indexPath.row == 1) {
        
        htmlVC.urlString = @"https://www.baidu.com";
        
    } else if (indexPath.row ==2){
        
        htmlVC.urlString = @"https://www.baidu.com";
    }
    
    
    [self.navigationController pushViewController:htmlVC animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (void)requestData
{
    NSString *urlString = @"http://10.10.5.5:8085/load/file/handheldHallData.txt";

    [requestDataManager postRequestDataToCloudRemoteControlServerWithUrl:urlString parameters:nil success:^(id  _Nullable responseObject) {
        
        
        NSArray *resultArray = responseObject;
        
        NSDictionary *dic = [resultArray firstObject];
        
        DONG_Log(@"resultArray:%@",dic);
        

    } failure:^(id  _Nullable errorObject) {
        
        
    }];
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}


@end
