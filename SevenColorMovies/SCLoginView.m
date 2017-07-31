//
//  SCLoginView.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/7/31.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCLoginView.h"


@interface SCLoginView ()

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation SCLoginView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
    _deleteButton.enlargedEdge = 10.f;
    _mobileTF.keyboardType = UIKeyboardTypePhonePad;
    _passwordTF.keyboardType = UIKeyboardTypeEmailAddress;
}

@end
