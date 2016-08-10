//
//  SCArtsFilmCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/10.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCArtsFilmCell.h"

@interface SCArtsFilmCell ()

@property (weak, nonatomic) IBOutlet UILabel *filmNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *filmInstructionLabel;

@end

@implementation SCArtsFilmCell

- (void)setModel:(SCFilmModel *)model{
    
    _filmNameLabel.text = model.FilmName;
    _filmInstructionLabel.text = model.Subject;
}



@end
