//
//  SCFliterOptionCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/9/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilterOptionTabModel.h"

@interface SCFliterOptionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

@property (nonatomic, strong) SCFilterOptionTabModel *optionTabModel;


@end
