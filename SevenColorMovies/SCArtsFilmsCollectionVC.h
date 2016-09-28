//
//  SCArtsFilmsCollectionVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/10.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCFilmModel;

typedef void(^ClickToPlayBlock)(NSString *urlStr,SCFilmModel *filmModel);//点击切换节目block

@interface SCArtsFilmsCollectionVC : UICollectionViewController

@property (nonatomic, strong) NSArray *dataArray;/** sets数据 */
@property (nonatomic, copy) ClickToPlayBlock clickToPlayBlock;/** 点击切换节目block */

@end
