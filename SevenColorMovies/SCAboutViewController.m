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

@end

@implementation SCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.leftBBI.text = @"关于";
    self.versionNumberLabel.text = [NSString stringWithFormat:@"版本号：%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
    
    
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
