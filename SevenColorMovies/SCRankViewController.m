//
//  SCRankViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/20.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCRankViewController.h"

static  CGFloat const kSectionOneCellHeight = 185.f;
static  CGFloat const kSectionTwoCellHeight = 185.f;

@interface SCRankViewController()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** tableView数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** section数据源 */
@property (nonatomic, strong) NSMutableArray *sectionArr;

@end

@implementation SCRankViewController

#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    
    _dataSource = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", nil];
    _sectionArr = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", nil];

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
    
    if (indexPath.row == 0) {//频道点播
        
        
        return nil;
        
    }else{
        
        
        
        return nil;
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
    
//    return [self addSectionHeaderViewWithTitle:_sectionArr[section] tag:section];
    return nil;
}




@end