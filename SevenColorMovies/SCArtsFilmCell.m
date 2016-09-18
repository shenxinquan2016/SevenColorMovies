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
    
    if (model.isOnLive) {
        _filmNameLabel.textColor = [UIColor colorWithHex:@"#78A1FF"];
        _filmInstructionLabel.textColor = [UIColor colorWithHex:@"#78A1FF"];
        
    }else{
        //此处若不设置label的默认颜色，cell复用时label的颜色会混乱
        _filmNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _filmInstructionLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
    
    
    
    
}



@end
