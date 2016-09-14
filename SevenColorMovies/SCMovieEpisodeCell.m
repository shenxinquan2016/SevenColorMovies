//
//  SCMovieEpisodeCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMovieEpisodeCell.h"

@interface SCMovieEpisodeCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentIndexLabel;
@end

@implementation SCMovieEpisodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setFilmSetModel:(SCFilmSetModel *)filmSetModel{

    _contentIndexLabel.text = filmSetModel._ContentIndex;
    
    if (filmSetModel.isOnLive) {
        _contentIndexLabel.textColor = [UIColor colorWithHex:@"#78A1FF"];
        
    }else{
        //此处若不设置label的默认颜色，cell复用时label的颜色会混乱
        _contentIndexLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
}

@end
