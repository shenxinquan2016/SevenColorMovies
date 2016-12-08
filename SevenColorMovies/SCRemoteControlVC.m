//
//  SCRemoteControlVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/29.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCRemoteControlVC.h"
#import "SCUDPSocketManager.h"

@interface SCRemoteControlVC ()
// PullScreen TimeShifted VolumeDown_Click VolumeUp_Click
@property (weak, nonatomic) IBOutlet UIButton *volumeDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *pullScreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *volumeUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *VODBtn;
@property (weak, nonatomic) IBOutlet UIButton *OKBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeShiftBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *homePageBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

@end

@implementation SCRemoteControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    //1.标题
    self.leftBBI.text = @"遥控器";
    
    
    
    [UPDScoketManager startConnectSocket];
    
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [_volumeDownBtn setImage:[UIImage imageNamed:@"VolumeDown_Click"] forState:UIControlStateHighlighted];
    [_pullScreenBtn setImage:[UIImage imageNamed:@"PullScreen_Click"] forState:UIControlStateHighlighted];
    [_volumeUpBtn setImage:[UIImage imageNamed:@"VolumeUp_Click"] forState:UIControlStateHighlighted];
    [_VODBtn setImage:[UIImage imageNamed:@"VOD_Click"] forState:UIControlStateHighlighted];
    [_OKBtn setImage:[UIImage imageNamed:@"OK_Click"] forState:UIControlStateHighlighted];
    [_timeShiftBtn setImage:[UIImage imageNamed:@"TimeShifted_Click"] forState:UIControlStateHighlighted];
    [_backBtn setImage:[UIImage imageNamed:@"Back_Click"] forState:UIControlStateHighlighted];
    [_homePageBtn setImage:[UIImage imageNamed:@"HomePage_Click"] forState:UIControlStateHighlighted];
    [_menuBtn setImage:[UIImage imageNamed:@"Menu_Click"] forState:UIControlStateHighlighted];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"🔴%s 第%d行 \n",__func__, __LINE__);
    
}

- (IBAction)doOKAction:(id)sender {
    NSLog(@"确定");
    [UPDScoketManager sendMessage:@"OK"];
}

- (IBAction)doBackAction:(id)sender {
    NSLog(@"返回");
}

- (IBAction)doVolumeDown:(id)sender {
    NSLog(@"音量减");
}

- (IBAction)doVolumeUp:(id)sender {
    NSLog(@"音量加");
}

- (IBAction)toHomePage:(id)sender {
    NSLog(@"主页");
}

- (IBAction)toMenuPage:(id)sender {
    NSLog(@"目录");
}

- (IBAction)doVODAction:(id)sender {
    NSLog(@"点播");
}

- (IBAction)doTimeShiftAction:(id)sender {
    NSLog(@"时移");
}

- (IBAction)doPullScreen:(id)sender {
    NSLog(@"拉屏");
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}


@end
