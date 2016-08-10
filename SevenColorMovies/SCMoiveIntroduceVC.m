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
    
    NSString *dataStr;
    if (_model._Year) {
        dataStr = _model._Year;
    }else if (_model.Mshowtime){
        dataStr = _model.Mshowtime;
    }else{
        dataStr = @"-";
    }
    
    _dateLabel.text = dataStr;
    _directorLabel.text = _model.Director;
    _mainCharacter.text = _model.Actor;
    _filmIntroduceTextView.text = _model.Introduction;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
