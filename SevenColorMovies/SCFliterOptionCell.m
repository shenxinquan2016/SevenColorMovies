//
//  SCFliterOptionCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/9/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCFliterOptionCell.h"

@interface SCFliterOptionCell ()


@end

@implementation SCFliterOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setOptionTabModel:(SCFilterOptionTabModel *)optionTabModel{
    
    self.optionLabel.text = optionTabModel.tabText;
    
    if (optionTabModel.isSelected) {
        
        self.optionLabel.textColor = [UIColor colorWithHex:@"#78A1FF"];
        
    }else{
        
        self.optionLabel.textColor = [UIColor colorWithHex:@"#666666"];
    }
}
@end
