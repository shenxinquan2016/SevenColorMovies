//
//  SCArtsDownloadCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCArtsDownloadCell.h"
#import "SCFilmModel.h"

@interface SCArtsDownloadCell ()

@property (weak, nonatomic) IBOutlet UILabel *filmNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *filmInstructionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downloadedImageView;

@end

@implementation SCArtsDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
}

- (void)setFilmModel:(SCFilmModel *)filmModel {
    _filmNameLabel.text = filmModel.FilmName;
    _filmInstructionLabel.text = filmModel.Subject;
    
    if (filmModel.isDownLoaded) {
        _downloadedImageView.hidden = NO;
    } else {
        _downloadedImageView.hidden = YES;
    }
}

@end
