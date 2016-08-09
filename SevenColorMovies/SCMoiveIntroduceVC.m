//
//  SCMoiveIntroduceVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMoiveIntroduceVC.h"

@interface SCMoiveIntroduceVC ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainCharacter;
@property (weak, nonatomic) IBOutlet UITextView *filmIntroduceTextView;

@end

@implementation SCMoiveIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _dateLabel.text = _model._Year;
    _directorLabel.text = _model.Director;
    _mainCharacter.text = _model.Actor;
    _filmIntroduceTextView.text = _model.Introduction;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
