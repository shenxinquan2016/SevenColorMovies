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
#import "SCTCPSocketManager.h"
#import "SCDLNAViewController.h"
#import "SCScanQRCodesVC.h"
#import "SCXMPPManager.h"

#import <Crashlytics/Crashlytics.h>

@interface SCDiscoveryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation SCDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#dddddd"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTableView];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 550, 60, 30);
    [button setTitle:@"Crash" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:@"#F0F1F2"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(crashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DONG_NotificationCenter addObserver:self selector:@selector(toSearchingDevicePage) name:CutOffTcpConnectByUser object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)dealloc {
    [DONG_NotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark- private methods
- (void)setTableView
{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F0F1F2"];
    _tableView.scrollEnabled = NO;
    
}

- (void)toSearchingDevicePage
{
    SCSearchDeviceVC *searchDeviceVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCSearchDeviceVC");
    searchDeviceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchDeviceVC animated:YES];
}

#pragma mark- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count > section) {
        NSArray *array = self.dataSource[section];
        return array.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 扫码

        SCScanQRCodesVC *scanQRCodesVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCScanQRCodesVC");
        scanQRCodesVC.isQQSimulator = YES;
        scanQRCodesVC.isVideoZoom = YES;
        scanQRCodesVC.entrance = @"Section0Click";
        scanQRCodesVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scanQRCodesVC animated:YES];
        
    } else if (indexPath.section == 1 && indexPath.row == 0){ // 遥控器
        
        if (XMPPManager.isConnected) {
            SCRemoteControlVC *remoteVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCRemoteControlVC");
            remoteVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:remoteVC animated:YES];
            
        } else {
            
            SCScanQRCodesVC *scanQRCodesVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCScanQRCodesVC");
            scanQRCodesVC.isQQSimulator = YES;
            scanQRCodesVC.isVideoZoom = YES;
            scanQRCodesVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scanQRCodesVC animated:YES];
            
        }
        
    } else if (indexPath.section == 1 && indexPath.row == 1) { // DLNA
        
//        SCDLNAViewController *dlnaVC = [[SCDLNAViewController alloc] initWithNibName:@"SCDLNAViewController" bundle:nil];;
//        SCDLNAViewController *dlnaVC = [[NSBundle mainBundle] loadNibNamed:
//         @"SCDLNAViewController" owner:nil options:nil ].lastObject;
//        [self.navigationController pushViewController:dlnaVC animated:YES];
        
        // TCP已经连接 进遥控器页  没有连接进遥控器搜索页
        if (TCPScoketManager.isConnected) {
            SCRemoteControlVC *remoteVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCRemoteControlVC");
            remoteVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:remoteVC animated:YES];
            
        } else {
            
            SCSearchDeviceVC *searchDeviceVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCSearchDeviceVC");
            searchDeviceVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchDeviceVC animated:YES];
        }

        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark- Getters and Setters

- (NSArray *)dataSource
{
    if (!_dataSource) {
        NSArray *array = @[@[@{@"leftImg":@"Scan",@"title":@"扫一扫",@"isShowBottmLine":@"YES"}],
                           @[@{@"leftImg":@"RemoteControl",@"title":@"遥控器",@"isShowBottmLine":@"NO"},
                             @{@"leftImg":@"DLNA",@"title":@"功能说明",@"isShowBottmLine":@"YES"},
                             /*@{@"leftImg":@"DLNA",@"title":@"DLNA",@"isShowBottmLine":@"YES"}*/],
                           /*@[@{@"leftImg":@"Activity",@"title":@"活动专区",@"isShowBottmLine":@"NO"},                           @{@"leftImg":@"Game_1",@"title":@"游戏中心",@"isShowBottmLine":@"YES"}],
                           @[@{@"leftImg":@"Application",@"title":@"应用中心",@"isShowBottmLine":@"NO"},                           @{@"leftImg":@"Live_1",@"title":@"直播伴侣",@"isShowBottmLine":@"YES"}]*/];
        _dataSource = array;
    }
    return _dataSource;
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}




- (IBAction)crashButtonTapped:(id)sender {
    [[Crashlytics sharedInstance] crash];
}


@end
