//
//  SCCollectionViewPageVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/2.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCollectionViewPageVC : UICollectionViewController


/** url端口 */
@property(nonatomic,copy) NSString *urlString;

@property (nonatomic,assign) NSInteger index;

@end
