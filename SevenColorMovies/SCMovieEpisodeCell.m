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
    // Initialization code
}

- (void)setModel:(SCFilmSetModel *)model {

    _contentIndexLabel.text = model._ContentIndex;
    
    
}

@end
