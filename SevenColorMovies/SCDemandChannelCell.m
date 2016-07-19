//
//  SCVideoOnDemandCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/19.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDemandChannelCell.h"

@implementation AFIndexedCollectionView

@end

@implementation SCDemandChannelCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}






+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    SCDemandChannelCell *cell = (SCDemandChannelCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[SCDemandChannelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    
    //1.创建FlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    
    if (ThreePointFiveInch  || FourInch) {
        layout.itemSize = CGSizeMake((182 - 51) / 2, (182 - 51) / 2 + 5);  //设置item的大小
        layout.minimumInteritemSpacing = (kMainScreenWidth - ((182 - 51) / 2) * 4 - 20) / 3 ;  //设置collection竖着的间距
        layout.minimumLineSpacing = 182 - ((182 - 45) / 2) * 2 - 34;  //设置collection横向间距
        
    }else if (FourPointSevenInch || FivePointFiveSevenInch) {
        layout.itemSize = CGSizeMake(80, 70);  //设置item的大小
        layout.minimumInteritemSpacing = (kMainScreenWidth - 80 * 4 - 20) / 3 ;  //设置collection竖着的间距
        layout.minimumLineSpacing = 182 - ((182 - 45) / 2) * 2 - 34 ;  //设置collection横向间距
    }
    
    
    self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    
    
    if (ThreePointFiveInch  || FourInch) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"SuperManCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SuperManCollectionViewCell"];
    }else if (FourPointSevenInch || FivePointFiveSevenInch) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"SuperManCollectionViewBigCell" bundle:nil] forCellWithReuseIdentifier:@"SuperManCollectionViewBigCell"];
        
    }
    self.collectionView.scrollEnabled = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(17, 10, 17, 10);//设置整体的外边距
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.contentView.bounds;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    [self.collectionView reloadData];
}
@end
