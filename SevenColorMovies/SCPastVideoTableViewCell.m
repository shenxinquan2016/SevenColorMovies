//
//  SCPastVideoTableViewCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCPastVideoTableViewCell.h"

@interface SCPastVideoTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *programImageView;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *programNameLabel;

@end

@implementation SCPastVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCPastVideoTableViewCell";
    SCPastVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

- (void)setProgramModel:(SCLiveProgramModel *)programModel{
    
    [self.programImageView sd_setImageWithURL:[NSURL URLWithString:programModel.channelLogoUrl] placeholderImage:[UIImage imageNamed:@"NoImage"]];
    self.programNameLabel.text = programModel.program;
    //NSString -> NSDate
    NSDate *forecastdate = [NSDate dateFromString:programModel.forecastdate format:@"YYYY-MM-dd HH:mm:ss"];
    //NSDate -> NSString
    self.playTimeLabel.text = [NSDate dateStringFromDate:forecastdate withDateFormat:@"MM月dd日 HH:mm"];
    
}

@end
