//
//  SCRankTopRowTableViewCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SCDemandChannelCell.h"


@interface AFIndexedCollectionView1 : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

//static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface SCRankTopRowTableViewCell : UITableViewCell

@property (nonatomic, strong) AFIndexedCollectionView1 *collectionView;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
