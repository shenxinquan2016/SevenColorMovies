//
//  SCOptionalVideoTableViewCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCOptionalVideoTableViewCell.h"

@interface SCOptionalVideoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *filmImageView;
@property (weak, nonatomic) IBOutlet UILabel *filmNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UITextView *mainCharacterTextView;
@property (weak, nonatomic) IBOutlet UILabel *filmIntroduceLabel;


@end

@implementation SCOptionalVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainCharacterTextView.textContainerInset = UIEdgeInsetsMake(2.5, 0, 0, 0);
    
}

- (void)viewDidLayoutSubviews{
    
   

}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCOptionalVideoTableViewCell";
    SCOptionalVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
        self.frame = frame;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFilmModel:(SCFilmModel *)filmModel{
    
    [self.filmImageView sd_setImageWithURL:[NSURL URLWithString:filmModel.smallposterurl] placeholderImage:[UIImage imageNamed:@"NoImage"]];
    self.filmNameLabel.text = filmModel.cnname;
    self.scoreLabel.text = [NSString stringWithFormat:@"评分：%@",filmModel.endGrade?filmModel.endGrade:@"-"];
    self.directorLabel.text = filmModel._Year;
    self.mainCharacterTextView.text = filmModel.actor;
    self.filmIntroduceLabel.text = filmModel.storyintro;
}

@end
