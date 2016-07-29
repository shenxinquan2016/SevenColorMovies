//
//  SCRemoteControlVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/29.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCRemoteControlVC.h"

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
    
    
    

    
    
    
    
    
    
}

- (void)awakeFromNib{
    
   [_volumeUpBtn setImage:[UIImage imageNamed:@"VolumeDown_Click"] forState:UIControlStateNormal];
    
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
