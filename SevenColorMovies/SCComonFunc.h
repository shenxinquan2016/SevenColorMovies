//
//  SCComonFunc.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

typedef void(^ReloadBlk)();


#define CommonFunc [SCComonFunc shareManager]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCComonFunc : NSObject

@property (nonatomic, copy) ReloadBlk _Nullable reloadBlk;


+ (nullable instancetype)shareManager;

#pragma mark - 集成上下拉刷新
/**
 *  集成上下拉刷新
 *
 *  @param view 集成刷新控件的视图
 *  @param withSelf self
 *  @param headerFunc 头部刷新(下拉刷新) 方法不存在刷新控件不添加
 *  @param headerFuncFirst 头部刷新第一次自动是否刷新
 *  @param footerFunc 底部视图(上拉刷新) 方法不存在刷新控件不添加
 */
- (void)setupRefreshWithView:(nullable id)view withSelf:(nullable id)addSelf headerFunc:(nullable SEL)headerFunc headerFuncFirst:(BOOL)first footerFunc:(nullable SEL)footerFunc;

/**
 *  带banner的collectionView集成上下拉刷新
 *
 *  @param view 集成刷新控件的视图
 *  @param withSelf self
 *  @param headerFunc 头部刷新(下拉刷新) 方法不存在刷新控件不添加
 *  @param headerFuncFirst 头部刷新第一次自动是否刷新
 *  @param footerFunc 底部视图(上拉刷新) 方法不存在刷新控件不添加
 */

- (void)setupRefreshWithCollectionViewWithBanner:(nullable id)view withSelf:(nullable id)addSelf headerFunc:(nullable SEL)headerFunc headerFuncFirst:(BOOL)first footerFunc:(nullable SEL)footerFunc;
/**
 *  上拉刷新无数据提示到底了或者数据不足一页隐藏footerView
 *
 *  @param tableView        tableView
 *  @param dataArray        数据数组
 *  @param pageMaxNumber    一页的最大数量
 *  @param responseObject   获取的当前页面的数据
 */
- (void)mj_FooterViewHidden:(nullable UITableView *)tableView dataArray:(nullable NSMutableArray *)dataArray pageMaxNumber:(NSInteger)pageMaxNumber responseObject:(nullable id)responseObject;

#pragma mark - 网络无图片提示
/**
 *  设置无数据或者无网络时候的提示
 *
 *  @param tipsStr 提示语
 *  @param view 要加的主视图
 */
- (void)noDataOrNoNetTipsString:(nullable NSString *)tipsStr addView:(nullable UIView *)view;

/**
 *  隐藏无网络的提示
 *
 *  @param view 父视图
 */
- (void)hideTipsViews:(nullable UIView *)view;

/**
 *  显示加载gif动画
 *
 *  @param title 提示语
 */
- (void)showLoadingWithTips:(nullable NSString *)tipsString;

- (void)showLoadingWithTips:(nullable NSString *)tipsString inView:(nullable UIView *)view;
/**
 *  隐藏加载gif动画
 */
- (void)dismiss;

//获取ip地址
- (nullable NSString *)getIPAddress;


+ (void)animateTextField:(nullable UITextField *)textField vc:(nullable UIViewController *)vc;

+ (void)animateUp:(BOOL)up vc:(nullable UIViewController *)vc hight:(CGFloat)hight;

+ (void)animateTextFieldEditEnd:(nullable UIViewController *)vc;

/**
 *  根据字符串返回字符串的size
 */
+ (CGSize)commonFuncSizeWithText:(nullable NSString *)text font:(nullable UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  设置navigationBar的背景色
 */
- (void)setNavigationBarBackgroundColor:(nullable UIView *)superView;

- (void)setTextFieldSetLeftView:(nullable UITextField *)textField;

/**
 *  隐藏tabelView多余的cell
 */
+ (void)commonFuncHiddenExtraCells:(nullable UITableView *)tableView;


@end
