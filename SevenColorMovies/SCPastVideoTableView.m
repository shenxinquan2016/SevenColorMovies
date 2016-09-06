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

@property (nonatomic, strong) NSMutableArray *dataSource;/** tableView数据数组 */
@property (nonatomic, strong) NSMutableDictionary *channelLogoDictionary;/** channel Logo字典 */

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
// 获取搜索结果+台标
- (void)getSearchResultAndChannelLogoWithFilmName:(NSString *)keyword Page:(NSInteger)pageNumbe CallBack:(CallBack)callBack{
    // 获取台标
    [requestDataManager requestDataWithUrl:GetChannelLogoUrl parameters:nil success:^(id  _Nullable responseObject) {
        
        //        NSLog(@"==========dic:::%@========",responseObject);
        
        self.channelLogoDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        [_channelLogoDictionary removeAllObjects];
        
        NSArray *array1 = responseObject[@"LiveLookback"];
        for (NSDictionary *dic1 in array1) {
            
            NSArray *array2 = dic1[@"ContentSet"][@"Content"];
            for (NSDictionary *dic2 in array2) {
                
                NSString *key = dic2[@"_ChannelName"];
                NSString *value = dic2[@"ImgUrl"];
                [self.channelLogoDictionary setObject:value forKey:key];
            }
        }
        
        // 获取搜索结果
        [self getProgramHavePastSearchResultWithFilmName:keyword Page:1 CallBack:^(id obj) {
            
            callBack(obj);
        }];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    
}

// 获取搜索结果
- (void)getProgramHavePastSearchResultWithFilmName:(NSString *)keyword Page:(NSInteger)pageNumbe CallBack:(CallBack)callBack{
    
    if (self.dataSource) {
        [_dataSource removeAllObjects];
    }else if (!self.dataSource){
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *thisWeek = [now dateByAddingTimeInterval: -7*24*3600];
    NSString *startTime = [formatter stringFromDate:thisWeek];
    NSString *endTime = [formatter stringFromDate:now];
    
    NSLog(@"+++++++%@+++++++++%@+++++",startTime,endTime);
    
    // 时间戳
    NSString *time1 = [now getTimeStamp];
    NSString *time2 = [NSString stringWithFormat:@"%lf", [[NSDate date ] timeIntervalSince1970]-7*24*3600];
    
    NSLog(@"++++++%@++++++++++%@+++++",time1,time2);
    
    NSDictionary *parameters = @{@"keyword" : keyword,
                                 //@"starttime" : startTime,
                                 //@"endtime" : endTime,
                                 @"pg" : [NSString stringWithFormat:@"%zd",pageNumbe]};
    
    [requestDataManager requestDataWithUrl:SearchProgramHavePastUrl parameters:parameters success:^(id  _Nullable responseObject) {
        
        //NSLog(@"==========dic:::%@========",responseObject);
        
        if ([responseObject[@"program"] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = responseObject[@"movieinfo"];
            SCLiveProgramModel *programModel = [SCLiveProgramModel mj_objectWithKeyValues:dic];
            
            [_dataSource addObject:programModel];
            
            
        }else if ([responseObject[@"program"] isKindOfClass:[NSArray class]]){
            
            for (NSDictionary *dic in responseObject[@"program"]) {
                
                SCLiveProgramModel *programModel = [SCLiveProgramModel mj_objectWithKeyValues:dic];
                programModel.channelLogoUrl = [self.channelLogoDictionary objectForKey:programModel.tvchannelen];
                
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
