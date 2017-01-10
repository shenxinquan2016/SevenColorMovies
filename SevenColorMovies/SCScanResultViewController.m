//
//  SCScanResultViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/10.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCScanResultViewController.h"

@interface SCScanResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *codeTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView *codeContentTextView;

@end

@implementation SCScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBBI.text = @"扫码结果";
    self.codeTypeLabel.text = _strCodeType;
    self.codeContentTextView.text = _strScan;
    self.codeContentTextView.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
