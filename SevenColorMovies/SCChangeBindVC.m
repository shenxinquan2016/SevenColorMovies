//
//  SCChangeBindVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/8/2.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  修改绑定控制器

#import "SCChangeBindVC.h"

@interface SCChangeBindVC ()

@property (weak, nonatomic) IBOutlet UITextField *caCardNoTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;

@end

@implementation SCChangeBindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBBI.text = @"绑定变更";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)sendVerificationCode:(id)sender
{
    
    
}

- (IBAction)submitChanges:(id)sender
{
    
}

@end
