//
//  SCBabyVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/21.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  萌娃个人页

#import "SCBabyVC.h"
#import "SCHuikanPlayerViewController.h"
#import "SCLovelyBabyLoginVC.h"
#import <UShareUI/UShareUI.h>

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
    
    // 数据请求
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

// 视频详情
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
            _totalVoteLabel.text = [NSString stringWithFormat:@"%@票", dict[@"voteNum"]];
            _descriptionTV.text = dict[@"mzDesc"];
            _playUrlString = dict[@"bfUrl"];
            _videoName = dict[@"mzName"];
            
        } else if ([resultCode isEqualToString:@"tokenInvalid"]) {
            
            UserInfoManager.lovelyBabyIsLogin = NO;
            [UserInfoManager removeUserInfo];
            SCLovelyBabyLoginVC *loginVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCLovelyBabyLoginVC");
            [self.navigationController pushViewController:loginVC animated:YES];
            
        } else {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        }
      
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
}

// 投票
- (void)voteNetworkRequest
{
    NSString *number;
    if (UserInfoManager.lovelyBabyIsLogin) {
        number = UserInfoManager.lovelyBabyMemberId;
    } else {
        number = [HLJUUID getUUID];
    }
    
    NSDictionary *parameters = @{@"voteType"      : @"iPhone",
                                 @"number"      : number,
                                 @"assetId"     : _babyModel.id? _babyModel.id : @""
                                 };
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager getRequestJsonDataWithUrl:LovelyBabyVote parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@",responseObject);
        NSString *resultCode = responseObject[@"resultCode"];
        
        if ([resultCode isEqualToString:@"true"]) {
            _voteBtn.enabled = NO;
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            
        } else if ([resultCode isEqualToString:@"tokenInvalid"]) {
            
            UserInfoManager.lovelyBabyIsLogin = NO;
            [UserInfoManager removeUserInfo];
            SCLovelyBabyLoginVC *loginVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCLovelyBabyLoginVC");
            [self.navigationController pushViewController:loginVC animated:YES];
            
        } else {
            
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

#pragma mark - 投票

- (IBAction)goToVote:(id)sender
{
    [self voteNetworkRequest];
}

#pragma mark - 分享

- (IBAction)shareVideo:(id)sender
{
    // 显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];

    }];
}

// 分享网页
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString *descrStr = @"七彩云(手机版)是龙江网络打造的一款聚合型手机电视客户端，作为龙江网络智能机顶盒七彩云产品的延伸，用户可以在手机端同步收看直播、点播、回看、时移等各类精彩内容，并畅享电影、电视剧、少儿、综艺、潮生活、最精彩等各类热门资源。";
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"七彩云(手机版)" descr:descrStr thumImage:[UIImage imageNamed:@"Icon"]];
    //设置网页地址
    shareObject.webpageUrl =@"https://itunes.apple.com/cn/app/七彩云-手机版/id1215488821?l=en&mt=8";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        } else {
            NSLog(@"response data is %@",data);
        }
    }];
}

@end
