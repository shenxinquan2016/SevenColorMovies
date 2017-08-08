//
//  SCMineViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
// 我的控制器

#import "SCMineViewController.h"
#import "SCMineTopCell.h"
#import "SCMineOtherCell.h"
#import "SCMyProgramListVC.h"
#import "SCMyWatchingHistoryVC.h"
#import "SCMyCollectionVC.h"
#import "SCMyDownloadManagerVC.h"
#import "SCMessageCenterVC.h"
#import "SCSettingVC.h"
#import "SCLoginView.h"
#import "SCRegisterVC.h"
#import "SCForgetPasswordVC.h"
#import "SCCustomerCenterVC.h"

@interface SCMineViewController ()

@property (nonatomic,strong) UIButton *leftBBI; // leftBarItem 商标
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) SCLoginView *loginView; // 登录页

@end

@implementation SCMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 1.商标
    [self addLeftBBI];
    // 2.tableView
    [self setTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _loginView.alpha = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark- private methods

- (void)addLeftBBI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 105, 27);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"BusinessLogo"] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    _leftBBI = btn;
}

#pragma mark- private methods

- (void)setTableView
{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F0F1F2"];
    //  _tableView.scrollEnabled = NO;
    
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
    if (indexPath.section < self.dataSource.count) {
        NSArray *array = self.dataSource[indexPath.section];
        if (indexPath.row < array.count) {
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            
            if (indexPath.section == 0) {
                
                SCMineTopCell *cell = [SCMineTopCell cellWithTableView:tableView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            } else {
                
                SCMineOtherCell *cell = [SCMineOtherCell cellWithTableView:tableView];
                [cell setModel:dict IndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    return nil;
}

#pragma mark -  UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return 90.f;
    return 56.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (UserInfoManager.isLogin) {
            
            SCCustomerCenterVC *customerCenterVC = DONG_INSTANT_VC_WITH_ID(@"Mine", @"SCCustomerCenterVC");
            customerCenterVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:customerCenterVC animated:YES];
            
        } else {
            
            // 读取登录
            _loginView = [[NSBundle mainBundle] loadNibNamed:@"SCLoginView" owner:nil options:nil][0];
            [[UIApplication sharedApplication].keyWindow addSubview:_loginView];
            [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            }];
            
            // 登录回调
            DONG_WeakSelf(self);
            _loginView.loginSuccessBlock = ^(NSString *mobile, NSString *password) {
               
               [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            
            // 注册回调
            _loginView.registerBlock = ^{
                
                [weakself.loginView removeFromSuperview];
                SCRegisterVC *registerVC = DONG_INSTANT_VC_WITH_ID(@"Mine", @"SCRegisterVC");
                registerVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:registerVC animated:YES];
            };
            
            // 找回密码回调
            _loginView.forgetPasswordBlock = ^{
                
                [weakself.loginView removeFromSuperview];
                SCForgetPasswordVC *findPasswordVC = DONG_INSTANT_VC_WITH_ID(@"Mine", @"SCForgetPasswordVC");
                findPasswordVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:findPasswordVC animated:YES];
            };
        }
        
    } else if (indexPath.section == 1 ) {
        
        switch (indexPath.row) {
            case 0: {
                SCMyProgramListVC *programListVC = [[SCMyProgramListVC alloc] initWithWithTitle:@"我的节目单"];
                [programListVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:programListVC animated:YES];
                break;
            }
                
            case 1: {
                SCMyWatchingHistoryVC *watchHistoryVC = [[SCMyWatchingHistoryVC alloc] initWithWithTitle:@"观看记录"];
                [watchHistoryVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:watchHistoryVC animated:YES];
                break;
            }
                
            case 2: {
                SCMyCollectionVC *collectionVC = [[SCMyCollectionVC alloc] initWithWithTitle:@"我的收藏"];
                [collectionVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:collectionVC animated:YES];
                break;
            }
                
            default:
                break;
        }
        
    } else if (indexPath.section == 2) {
        
        SCMyDownloadManagerVC *downloadManangerVC = [[SCMyDownloadManagerVC alloc] initWithWithTitle:@"下载管理"];
        [downloadManangerVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:downloadManangerVC animated:YES];
        
        //    } else if (indexPath.section == 1) {
        //
        //        SCMessageCenterVC *messageVC = [[SCMessageCenterVC alloc] initWithWithTitle:@"消息"];
        //        [messageVC setHidesBottomBarWhenPushed:YES];
        //        [self.navigationController pushViewController:messageVC animated:YES];
        //
    } else if (indexPath.section == 3) {
        
        SCSettingVC *settingVC = [[SCSettingVC alloc] initWithWithTitle:@"设置"];
        [settingVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:settingVC animated:YES];
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
        NSArray *array = @[@[@{@"Default_Avatar" : @"Hi,您好"}],
                           /* @[@{@"Associator" : @"会员中心"}],*/
                           @[@{@"Moive_list" : @"我的节目单"}, @{@"Watch_Record" : @"观看记录"}, @{@"Collection_1" : @"我的收藏"}],
                           @[@{@"Download" : @"下载管理"}],
                           /*@[@{@"Message" : @"消息"}],*/
                           @[@{@"Setting" : @"设置"}]];
        _dataSource = array;
    }
    return _dataSource;
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}



@end
