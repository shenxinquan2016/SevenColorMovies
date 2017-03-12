//
//  SCDiscoveryCollectionViewCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/3/12.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCDiscoveryCollectionViewCell.h"

@interface SCDiscoveryCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *channelImg;

@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;

@end

@implementation SCDiscoveryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath
{
    if (model && [model isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)model;
        NSString *keyStr = [dict.allKeys objectAtIndex:0];
        
        _channelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",keyStr]];
        _channelNameLabel.text =  [dict.allValues objectAtIndex:0];

    }
}

@end
