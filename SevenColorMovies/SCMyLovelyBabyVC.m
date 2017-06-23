//
//  SCMyLovelyBabyVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/21.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  我的视频

#import "SCMyLovelyBabyVC.h"
#import "SCLovelyBabyLoginVC.h"

@interface SCMyLovelyBabyVC ()

@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalLabel0;
@property (weak, nonatomic) IBOutlet UILabel *personalNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalVoteLabel0;
@property (weak, nonatomic) IBOutlet UILabel *totoalVoteLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic, assign) NSInteger statusCode;

@end

@implementation SCMyLovelyBabyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBBI.text = @"我的视频";
    
    [self getMyVideoDataRequest];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)playVideo:(id)sender
{
    
    
}
- (IBAction)clickLeftBtn:(id)sender
{
    
}


- (IBAction)clickRightBtn:(id)sender
{
    
    
}

// 录制视频
- (void)recordVideo
{
    DONG_Log(@"录制视频");
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - NetworkRequest

- (void)getMyVideoDataRequest
{
    NSDictionary *parameters = @{@"siteId"      : @"hlj_appjh",
                                 @"memberId"    : UserInfoManager.lovelyBabyMemberId,
                                 @"searchName"  : @"",
                                 @"searchType"  : @"paike",
                                 @"pageYema"    : @"1",
                                 @"pageSize"    : @"500",
                                 @"token"       : UserInfoManager.lovelyBabyToken
                                 };
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager getRequestJsonDataWithUrl:LovelyBabyVideoList parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@",responseObject);
        NSString *resultCode = responseObject[@"resultCode"];
        
        if ([resultCode isEqualToString:@"success"]) {
            
            NSArray *dataArray = responseObject[@"data"];
            NSDictionary *dict = dataArray.firstObject;
            
            if (dataArray.count == 0) {
                // 1.未上传
                [_coverIV setImage:[UIImage imageNamed:@"UnUploadViedo"]];
                _nameLabel.hidden = YES;
                _personalLabel0.hidden = YES;
                _personalNoLabel.hidden = YES;
                _totalVoteLabel0.hidden = YES;
                _totoalVoteLabel.hidden = YES;
                _playBtn.hidden = YES;
                _leftBtn.hidden = YES;
                [_rightBtn setTitle:@"未上传" forState:UIControlStateNormal];
                [_rightBtn setBackgroundImage:[UIImage imageNamed:@"UnUploadBtnBG"] forState:UIControlStateNormal];
                _rightBtn.userInteractionEnabled = NO;
                
                _coverIV.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordVideo)];
                [_coverIV addGestureRecognizer:tap];
                
            } else {
                
                _nameLabel.text = dict[@"mzName"];
                _personalNoLabel.text = dict[@"serialNumber"];
                _totoalVoteLabel.text = [NSString stringWithFormat:@"%@票", dict[@"voteNum"]];
                _statusCode = [dict[@"status"] integerValue];
                
                switch (_statusCode) {
                    case 0: // 删除
                        
                        break;
                        
                    case 1: // 2.待审核
                        _personalLabel0.hidden = YES;
                        _personalNoLabel.hidden = YES;
                        _totalVoteLabel0.hidden = YES;
                        _totoalVoteLabel.hidden = YES;
                        _leftBtn.hidden = YES;
                        [_rightBtn setTitle:@"审核中" forState:UIControlStateNormal];
                        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"UnderReviewBtnBG"] forState:UIControlStateNormal];
                        _rightBtn.userInteractionEnabled = NO;
                        [_coverIV sd_setImageWithURL:[NSURL URLWithString:dict[@"showUrl"]] placeholderImage:[UIImage imageNamed:@"Image-4"]];

                        break;
                        
                    case 2:
                        
                        break;
                        
                    case 3: // 3.驳回
                        _personalLabel0.hidden = YES;
                        _personalNoLabel.hidden = YES;
                        _totalVoteLabel0.hidden = YES;
                        _totoalVoteLabel.hidden = YES;
                        
                        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"RefusedBtnBG"] forState:UIControlStateNormal];
                        _rightBtn.userInteractionEnabled = NO;
                        [_coverIV sd_setImageWithURL:[NSURL URLWithString:dict[@"showUrl"]] placeholderImage:[UIImage imageNamed:@"Image-4"]];
                        
                        break;
                        
                    case 4: // 等待注入
                        
                        break;
                        
                    case 5: // 注入中
                        
                        break;
                        
                    case 6: // 4.上线
                        _leftBtn.hidden = YES;
                        [_rightBtn setTitle:@"审核通过" forState:UIControlStateNormal];
                        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"ShareBtnBG"] forState:UIControlStateNormal];
                        _rightBtn.userInteractionEnabled = NO;
                        [_coverIV sd_setImageWithURL:[NSURL URLWithString:dict[@"showUrl"]] placeholderImage:[UIImage imageNamed:@"Image-4"]];
                        
                        break;
                        
                    case 7: // 下线
                        
                        break;
                        
                    default:
                        break;
                }
                
            }
            
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


@end
