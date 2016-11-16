//
//  SCDSJDownloadCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDSJDownloadCell.h"
#import "SCFilmSetModel.h"

@interface SCDSJDownloadCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentIndexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downloadImageView;

@end


@implementation SCDSJDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
}

- (void)setFilmSetModle:(SCFilmSetModel *)filmSetModle {
    _contentIndexLabel.text = filmSetModle._ContentIndex;
    if (filmSetModle.isDownLoaded) {
        _downloadImageView.hidden = NO;
    } else {
       _downloadImageView.hidden = YES;
    }
}

@end
