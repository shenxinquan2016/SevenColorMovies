//
//  SCMineViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMineViewController.h"
#import "SCMineTopCell.h"
#import "SCMineOtherCell.h"
#import "SCMyProgramListVC.h"
#import "SCMyWatchingHistoryVC.h"
#import "SCMyCollectionVC.h"
#import "SCMyDownloadManagerVC.h"


@interface SCMineViewController ()

/** leftBarItem 商标 */
@property (nonatomic,strong) UIButton *leftBBI;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SCMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTableView];
    //1.商标
    [self addLeftBBI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

#pragma mark- private methods
- (void)setTableView {
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F0F1F2"];
//    _tableView.scrollEnabled = NO;
    
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
    if (indexPath.section < self.dataSource.count) {
        NSArray *array = self.dataSource[indexPath.section];
        if (indexPath.row < array.count) {
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
//            if (indexPath.section == 0) {
//                SCMineTopCell *cell = [SCMineTopCell cellWithTableView:tableView];
//                
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return cell;
//                
//            }else{
                SCMineOtherCell *cell = [SCMineOtherCell cellWithTableView:tableView];
                [cell setModel:dict IndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
//            }
        }
    }
    return nil;
}

#pragma mark -  UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) return 90.f;
//    else return 56.f;
    return 56.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        switch (indexPath.row) {
            case 0:{
                SCMyProgramListVC *programListVC = [[SCMyProgramListVC alloc] initWithWithTitle:@"我的节目单"];
                [programListVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:programListVC animated:YES];
                
                break;
            }
                
            case 1:{
                SCMyWatchingHistoryVC *watchHistoryVC = [[SCMyWatchingHistoryVC alloc] initWithWithTitle:@"观看记录"];
                [watchHistoryVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:watchHistoryVC animated:YES];
                break;
            }
                
            case 2:{
                SCMyCollectionVC *collectionVC = [[SCMyCollectionVC alloc] initWithWithTitle:@"我的收藏"];
                [collectionVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:collectionVC animated:YES];
                break;
            }
                
            default:
                break;
        }
        
    }else if (indexPath.section == 1){
        
        SCMyDownloadManagerVC *downloadManangerVC = [[SCMyDownloadManagerVC alloc] initWithWithTitle:@"下载管理"];
        [downloadManangerVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:downloadManangerVC animated:YES];
        
        
    }else if (indexPath.section == 2){
        
    }else if (indexPath.section == 3){
        
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
        NSArray *array = @[/*@[@{@"Default_Avatar" : @"Hi,您好"}],
                           @[@{@"Associator" : @"会员中心"}],*/
                           @[@{@"Moive_list" : @"我的节目单"}, @{@"Watch_Record" : @"观看记录"}, @{@"Collection_1" : @"我的收藏"}],
                           @[@{@"Download" : @"下载管理"}],
                           @[@{@"Message" : @"消息"}],
                           @[@{@"Setting" : @"设置"}]];
        _dataSource = array;
    }
    return _dataSource;
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}


@end
