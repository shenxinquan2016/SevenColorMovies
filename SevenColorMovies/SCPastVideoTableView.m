//
//  SCPastVideoTableView.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCPastVideoTableView.h"
#import "SCPastVideoTableViewCell.h"
#import "SCLiveProgramModel.h"

@interface SCPastVideoTableView ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SCPastVideoTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCPastVideoTableViewCell *cell = [SCPastVideoTableViewCell cellWithTableView:tableView];
    cell.programModel = _dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 94;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"======indexPath.section:%ld",indexPath.section);
}

#pragma mark- 网络请求
- (void)getProgramHavePastSearchResultWithFilmName:(NSString *)keyword StartTime:(NSString *)startTime EndTime:(NSString *)endTime Page:(NSInteger)pageNumbe CallBack:(CallBack)callBack{
    
    if (self.dataSource) {
        [_dataSource removeAllObjects];
    }else if (!self.dataSource){
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }

    
    NSDictionary *parameters = @{@"keyword" : keyword,
                                 //@"starttime" : startTime,
                                 //@"endtime" : endTime,
                                 @"pg" : [NSString stringWithFormat:@"%zd",pageNumbe]};
    
    [requestDataManager requestDataWithUrl:SearchProgramHavePastUrl parameters:parameters success:^(id  _Nullable responseObject) {
        
        NSLog(@"==========dic:::%@========",responseObject);
        
        if ([responseObject[@"program"] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = responseObject[@"movieinfo"];
            SCLiveProgramModel *programModel = [SCLiveProgramModel mj_objectWithKeyValues:dic];
            
                [_dataSource addObject:programModel];
            
            
        }else if ([responseObject[@"program"] isKindOfClass:[NSArray class]]){
            
            for (NSDictionary *dic in responseObject[@"program"]) {
                
                SCLiveProgramModel *programModel = [SCLiveProgramModel mj_objectWithKeyValues:dic];
                
                    [_dataSource addObject:programModel];
                
            }
        }
        
        //总的搜索条数
        NSString *lookBackVideoTotalCount ;
        if (responseObject[@"_dbtotal"]) {
            lookBackVideoTotalCount = responseObject[@"_dbtotal"];
        }else{
            lookBackVideoTotalCount = @"0";
        }
        callBack(lookBackVideoTotalCount);
        
        [self.tableView reloadData];
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    

    
    
    
}



@end
