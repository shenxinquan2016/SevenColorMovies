//
//  SCSettingVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/23.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSettingVC.h"
#import "SCSettingCell.h"
#import "SCAboutViewController.h"

@interface SCSettingVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SCSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [CommonFunc noDataOrNoNetTipsString:@"功能建设中..." addView:self.view];}

    [self setTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- private methods
- (void)setTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F0F1F2"];
    _tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_tableView];
    
    
}

#pragma mark- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCSettingCell *cell = [SCSettingCell cellWithTableView:tableView];
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -  UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 56.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCAboutViewController *settingVC = DONG_INSTANT_VC_WITH_ID(@"Mine", @"SCAboutViewController");
    [settingVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:settingVC animated:YES];

}

#pragma mark- Getters and Setters
- (NSArray *)dataSource {
    
    if (!_dataSource) {
        NSArray *array = @[];
        _dataSource = array;
    }
    
    return _dataSource;
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}

@end
