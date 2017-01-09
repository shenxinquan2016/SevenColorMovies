//
//  SCScanQRCodesVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCScanQRCodesVC.h"
#import "SCXMPPManager.h"

@interface SCScanQRCodesVC () <SCXMPPManagerDelegate>

@property (nonatomic, strong) SCXMPPManager *xmppManager;

@end

@implementation SCScanQRCodesVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    // 1.标题
    self.leftBBI.text = @"扫一扫";
   
    // 初始化xmpp
    SCXMPPManager *xmppManager = [SCXMPPManager shareManager];
    [xmppManager initXMPPWithUserName:@"8451204087955261" andPassWord:@"voole"];
    xmppManager.delegate = self;
    _xmppManager = xmppManager;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)xmpp:(id)sender {
}

#pragma mark - SCXMPPManagerDelegate

- (void)didReceiveMessage:(XMPPMessage*)message
{
    NSString *from = message.fromStr;
    NSString *info = message.body;
    DONG_Log(@"接收到%@说：%@",from,info);
}


@end
