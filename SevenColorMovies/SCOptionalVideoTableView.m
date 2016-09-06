//
//  SCSearchTableViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCOptionalVideoTableView.h"
#import "SCOptionalVideoTableViewCell.h"



@interface SCOptionalVideoTableView ()

//@property (nonatomic, copy) NSString *identifier;
@property (nonatomic,assign) NSInteger page;/**< 分页标签 */

@end

@implementation SCOptionalVideoTableView

NSString *identifier;
+ (instancetype)initTableViewWithIdentifier:(NSString *)tag{
    SCOptionalVideoTableView *tableView = [[SCOptionalVideoTableView alloc] init];
    identifier = tag;
    return tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    //集成上拉加载更多
    [self setTableViewRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 集成刷新
- (void)setTableViewRefresh {
    [CommonFunc setupRefreshWithView:self.tableView withSelf:self headerFunc:nil headerFuncFirst:YES footerFunc:@selector(footerRefresh)];
}

- (void)headerRefresh {
    
}

- (void)footerRefresh {
    //    _page++;
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCOptionalVideoTableViewCell *cell = [SCOptionalVideoTableViewCell cellWithTableView:tableView];
    cell.filmModel = self.dataSource[indexPath.row];
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 164;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"======indexPath.section:%ld",indexPath.section);
}


#pragma mark- 网络请求
- (void)getVODSearchResultDataWithFilmName:(NSString *)keyword Page:(NSInteger)pageNumber CallBack:(CallBack)callBack{
    
    if (self.dataSource) {
        [_dataSource removeAllObjects];
    }else if (!self.dataSource){
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    
    [CommonFunc showLoadingWithTips:@""];
    
    NSDictionary *parameters = @{@"keyword" : keyword,
                                 @"pg" : [NSString stringWithFormat:@"%zd",pageNumber]};
    
    [requestDataManager requestDataWithUrl:SearchVODUrl parameters:parameters success:^(id  _Nullable responseObject) {
        
        NSLog(@"==========dic:::%@========",responseObject);
        
        if ([responseObject[@"movieinfo"] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = responseObject[@"movieinfo"];
            SCFilmModel *filmModel = [SCFilmModel mj_objectWithKeyValues:dic];
            if (filmModel) {
                [_dataSource addObject:filmModel];
            }
            
        }else if ([responseObject[@"movieinfo"] isKindOfClass:[NSArray class]]){
            
            for (NSDictionary *dic in responseObject[@"movieinfo"]) {
                
                SCFilmModel *filmModel = [SCFilmModel mj_objectWithKeyValues:dic];
                if (filmModel) {
                    [_dataSource addObject:filmModel];
                }
            }
        }
        
        //总的搜索条数
        NSString *VODTotalCount = responseObject[@"_dbtotal"];
        callBack(VODTotalCount);
        
        [self.tableView reloadData];
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    
    
}

    
    
    
    
    
    




@end
