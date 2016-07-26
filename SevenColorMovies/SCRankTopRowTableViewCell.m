//
//  SCRankTopRowTableViewCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCRankTopRowTableViewCell.h"
#import "SCRankTopRowCollectionViewCell.h"

@implementation AFIndexedCollectionView1

@end


@implementation SCRankTopRowTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    SCRankTopRowTableViewCell *cell = (SCRankTopRowTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[SCRankTopRowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    
    //1.创建FlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

        layout.itemSize = (CGSize){(kMainScreenWidth-10-15)/3,180};  //设置item的大小
        layout.minimumInteritemSpacing = 5.f;  //设置collection竖着的间距
    layout.minimumLineSpacing = 5.f; //设置collection横向间距
    
    //2.创建collectionView
    self.collectionView = [[AFIndexedCollectionView1 alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    //3.注册cell
        [self.collectionView registerNib:[UINib nibWithNibName:@"SCRankTopRowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SCRankTopRowCollectionViewCell"];
  
    self.collectionView.scrollEnabled = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置整体的外边距
    
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
