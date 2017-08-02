//
//  SCCustomerUpGradeVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/8/2.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  用户升级

#import "SCCustomerUpGradeVC.h"

@interface SCCustomerUpGradeVC ()

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;

@end

@implementation SCCustomerUpGradeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBBI.text = @"用户升级";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)submitChanges:(id)sender
{
    
}



@end
