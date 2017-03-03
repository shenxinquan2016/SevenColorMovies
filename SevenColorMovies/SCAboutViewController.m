//
//  SCAboutViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/2/25.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCAboutViewController.h"

@interface SCAboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel1;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel2;

@end

@implementation SCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.leftBBI.text = @"关于";
    self.versionNumberLabel.text = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
