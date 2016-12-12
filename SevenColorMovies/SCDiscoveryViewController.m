//
//  SCDiscoveryViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDiscoveryViewController.h"
#import "SCDiscoveryTableViewCell.h"
#import "SCDiscoveryCellModel.h"
#import "SCRemoteControlVC.h"
#import "SCSearchDeviceVC.h"


@interface SCDiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation SCDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark- private methods
- (void)setTableView{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F0F1F2"];
    _tableView.scrollEnabled = NO;

}

#pragma mark- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView{
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
    
    SCDiscoveryTableViewCell *cell = [SCDiscoveryTableViewCell cellWithTableView:tableView];
    if (indexPath.section < self.dataSource.count) {
        NSArray *array = self.dataSource[indexPath.section];
        if (indexPath.row < array.count) {
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            SCDiscoveryCellModel *model = [SCDiscoveryCellModel mj_objectWithKeyValues:dict];
            cell.model = model;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -  UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"======indexPath.section:%ld",indexPath.section);
    //遥控器
    if (indexPath.section == 1 && indexPath.row == 0){
        SCRemoteControlVC *remoteVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCRemoteControlVC");
        
        SCSearchDeviceVC *searchDeviceVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCSearchDeviceVC");

        remoteVC.hidesBottomBarWhenPushed = YES;
        searchDeviceVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchDeviceVC animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

#pragma mark- Getters and Setters
- (NSArray *)dataSource{
    if (!_dataSource) {
        NSArray *array = @[@[@{@"leftImg":@"Scan",@"title":@"扫一扫",@"isShowBottmLine":@"YES"}],
                         @[@{@"leftImg":@"RemoteControl",@"title":@"遥控器",@"isShowBottmLine":@"NO"},                          @{@"leftImg":@"DLNA",@"title":@"DLNA",@"isShowBottmLine":@"YES"}],
                         @[@{@"leftImg":@"Activity",@"title":@"活动专区",@"isShowBottmLine":@"NO"},                           @{@"leftImg":@"Game_1",@"title":@"游戏中心",@"isShowBottmLine":@"YES"}],
                         @[@{@"leftImg":@"Application",@"title":@"应用中心",@"isShowBottmLine":@"NO"},                           @{@"leftImg":@"Live_1",@"title":@"直播伴侣",@"isShowBottmLine":@"YES"}]];
        _dataSource = array;
    }
    return _dataSource;
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}

@end
