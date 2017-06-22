//
//  SCBabyVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/21.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  萌娃个人页

#import "SCBabyVC.h"
#import "SCHuikanPlayerViewController.h"

@interface SCBabyVC ()

@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalVoteLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;
/** 视频播放地址 */
@property (copy, nonatomic) NSString *playUrlString;
/** 视频名称 */
@property (copy, nonatomic) NSString *videoName;


@end

@implementation SCBabyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBBI.text = @"萌娃";
    
    [self getVideoDetailInfoNetRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - NetRequest

- (void)getVideoDetailInfoNetRequest
{
    NSString *number;
    if (UserInfoManager.lovelyBabyIsLogin) {
        number = UserInfoManager.lovelyBabyMemberId;
    } else {
        number = [HLJUUID getUUID];
    }
    
    NSDictionary *parameters = @{@"siteId"      : @"hlj_appjh",
                                 @"number"      : number,
                                 @"searchType"  : @"paike",
                                 @"assetId"     : _babyModel.id? _babyModel.id : @""
                                 };
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager getRequestJsonDataWithUrl:LovelyBabyVideoDetailInfo parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@",responseObject);
        NSString *resultCode = responseObject[@"resultCode"];
        
        if ([resultCode isEqualToString:@"success"]) {
            
            NSArray  *dataArray = responseObject[@"data"];
            NSDictionary *dict = dataArray.firstObject;
            if (![dict[@"isVote"] isEqualToString:@"true"]) {
                _voteBtn.enabled = NO;
            }
            [_coverIV sd_setImageWithURL:[NSURL URLWithString:dict[@"showUrl"]] placeholderImage:[UIImage imageNamed:@"Image-4"]];
            _nameLabel.text = dict[@"mzName"];
            _personalNoLabel.text = dict[@"serialNumber"];
            _totalVoteLabel.text = dict[@"voteNum"];
            _descriptionTV.text = dict[@"mzDesc"];
            _playUrlString = dict[@"bfUrl"];
            _videoName = dict[@"mzName"];
            
        }  else {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        }
      
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
}

#pragma mark - 播放视频

- (IBAction)playVideo:(id)sender
{
    SCHuikanPlayerViewController *playerVC = [SCHuikanPlayerViewController initPlayerWithUrlString:_playUrlString videoName:_videoName];
    [self.navigationController pushViewController:playerVC animated:YES];
}

@end
