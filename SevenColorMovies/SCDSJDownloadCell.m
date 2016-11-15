//
//  SCDSJDownloadCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDSJDownloadCell.h"

@interface SCDSJDownloadCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentIndexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downloadImageView;

@end


@implementation SCDSJDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
}

@end
