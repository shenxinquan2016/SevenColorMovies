//
//  SCFliterOptionCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/9/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCFliterOptionCell.h"

@interface SCFliterOptionCell ()

@property (weak, nonatomic) IBOutlet UILabel *optionLabel;


@end

@implementation SCFliterOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setOptionTabModel:(SCFilterOptionTabModel *)optionTabModel{
    
    self.optionLabel.text = optionTabModel.tabText;
    
    // 设定选中及取消选中时的字体颜色
    if (optionTabModel.isSelected) {
        
        self.optionLabel.textColor = [UIColor colorWithHex:@"#78A1FF"];
        
    }else{
        
        self.optionLabel.textColor = [UIColor colorWithHex:@"#666666"];
    }
}

@end
