//
//  SCComonFunc.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCComonFunc.h"
#import "SCLoadingView.h"

static int textFieldMoveHight = 0;

@interface SCComonFunc () <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIImageView *tipImageView;/**<  */
@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,strong) SCLoadingView *loadingView;
@end


@implementation SCComonFunc

// shareManager
+(instancetype)shareManager {
    static SCComonFunc *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SCComonFunc alloc] init];
    });
    return manager;
}

#pragma mark - 集成刷新控件
/**
 *  集成上下拉刷新
 *
 *  @param view 集成刷新控件的视图
 *  @param withSelf self
 *  @param headerFunc 头部刷新(下拉刷新) 方法不存在刷新控件不添加
 *  @param headerFuncFirst 头部刷新第一次自动是否刷新
 *  @param footerFunc 底部视图(上拉刷新) 方法不存在刷新控件不添加
 */

- (void)setupRefreshWithView:(id)view withSelf:(id)addSelf headerFunc:(SEL)headerFunc headerFuncFirst:(BOOL)first footerFunc:(SEL)footerFunc {
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)view;
        //下拉方法存在添加下拉刷新
        if (headerFunc) {
            DONG_RefreshGifHeader *header = [DONG_RefreshGifHeader headerWithRefreshingTarget:addSelf refreshingAction:headerFunc];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            header.ignoredScrollViewContentInsetTop = -5;
            // 隐藏状态
            header.stateLabel.hidden = NO;
            tableView.mj_header = header;
            //自动刷新(一进入程序就下拉刷新)
            if (first) {
                [CommonFunc showLoadingWithTips:@""];
                MJRefreshMsgSend(MJRefreshMsgTarget(addSelf), headerFunc, view);
                //[tableView.mj_header beginRefreshing];
            }
        }
        //上拉刷新的方法存在添加上拉刷新的方法
        if (footerFunc) {
            // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
            //tableView.mj_footer = [GCX_RefreshGifFooter footerWithRefreshingTarget:addSelf refreshingAction:footerFunc];
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:addSelf refreshingAction:footerFunc];
            footer.refreshingTitleHidden = YES;//隐藏刷新时的文字显示
            //footer.ignoredScrollViewContentInsetBottom = 40;
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            [footer setTitle:@"" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"到底了~" forState:MJRefreshStateNoMoreData];
            tableView.mj_footer = footer;
        }
    } else {
        UICollectionView *collectionView = (UICollectionView *)view;
        //下拉方法存在添加下拉刷新
        if (headerFunc) {
            DONG_RefreshGifHeader *header = [DONG_RefreshGifHeader headerWithRefreshingTarget:addSelf refreshingAction:headerFunc];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = NO;
            
            header.ignoredScrollViewContentInsetTop = 0;
            // 隐藏状态
            header.stateLabel.hidden = NO;
            collectionView.mj_header = header;
            //自动刷新(一进入程序就下拉刷新)
            if (first) {
                [CommonFunc showLoadingWithTips:@""];
                [collectionView.mj_header beginRefreshing];
            }
        }
        //上拉刷新的方法存在添加上拉刷新的方法
        if (footerFunc) {
            // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
            //collectionView.mj_footer = [GCX_RefreshGifFooter footerWithRefreshingTarget:addSelf refreshingAction:footerFunc];
            //tableView.mj_footer = [GCX_RefreshGifFooter footerWithRefreshingTarget:addSelf refreshingAction:footerFunc];
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:addSelf refreshingAction:footerFunc];
            footer.refreshingTitleHidden = YES;//隐藏刷新时的文字显示
            //footer.ignoredScrollViewContentInsetBottom = 40;
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            [footer setTitle:@"" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"没有更多数据了..." forState:MJRefreshStateNoMoreData];
            collectionView.mj_footer = footer;
        }
    }
}

/**
 *  带banner的collectionView集成上下拉刷新
 *
 *  @param view 集成刷新控件的视图
 *  @param withSelf self
 *  @param headerFunc 头部刷新(下拉刷新) 方法不存在刷新控件不添加
 *  @param headerFuncFirst 头部刷新第一次自动是否刷新
 *  @param footerFunc 底部视图(上拉刷新) 方法不存在刷新控件不添加
 */

- (void)setupRefreshWithCollectionViewWithBanner:(id)view withSelf:(id)addSelf headerFunc:(SEL)headerFunc headerFuncFirst:(BOOL)first footerFunc:(SEL)footerFunc {
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)view;
        //下拉方法存在添加下拉刷新
        if (headerFunc) {
            DONG_RefreshGifHeader *header = [DONG_RefreshGifHeader headerWithRefreshingTarget:addSelf refreshingAction:headerFunc];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            header.ignoredScrollViewContentInsetTop = -5;
            // 隐藏状态
            header.stateLabel.hidden = NO;
            tableView.mj_header = header;
            //自动刷新(一进入程序就下拉刷新)
            if (first) {
                [CommonFunc showLoadingWithTips:@""];
                MJRefreshMsgSend(MJRefreshMsgTarget(addSelf), headerFunc, view);
                //[tableView.mj_header beginRefreshing];
            }
        }
        //上拉刷新的方法存在添加上拉刷新的方法
        if (footerFunc) {
            // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
            //tableView.mj_footer = [GCX_RefreshGifFooter footerWithRefreshingTarget:addSelf refreshingAction:footerFunc];
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:addSelf refreshingAction:footerFunc];
            footer.refreshingTitleHidden = YES;//隐藏刷新时的文字显示
            //footer.ignoredScrollViewContentInsetBottom = 40;
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            [footer setTitle:@"" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"到底了~" forState:MJRefreshStateNoMoreData];
            tableView.mj_footer = footer;
        }
    } else {
        UICollectionView *collectionView = (UICollectionView *)view;
        //下拉方法存在添加下拉刷新
        if (headerFunc) {
            DONG_RefreshGifHeader *header = [DONG_RefreshGifHeader headerWithRefreshingTarget:addSelf refreshingAction:headerFunc];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = NO;
            
            // 忽略多少scrollView的contentInset的top
            header.ignoredScrollViewContentInsetTop = 165;
            // 隐藏状态
            header.stateLabel.hidden = NO;
            collectionView.mj_header = header;
            //自动刷新(一进入程序就下拉刷新)
            if (first) {
                [CommonFunc showLoadingWithTips:@""];
                [collectionView.mj_header beginRefreshing];
            }
        }
        //上拉刷新的方法存在添加上拉刷新的方法
        if (footerFunc) {
            // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
            //collectionView.mj_footer = [GCX_RefreshGifFooter footerWithRefreshingTarget:addSelf refreshingAction:footerFunc];
            //tableView.mj_footer = [GCX_RefreshGifFooter footerWithRefreshingTarget:addSelf refreshingAction:footerFunc];
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:addSelf refreshingAction:footerFunc];
            footer.refreshingTitleHidden = YES;//隐藏刷新时的文字显示
            //footer.ignoredScrollViewContentInsetBottom = 40;
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            [footer setTitle:@"" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"没有更多数据了..." forState:MJRefreshStateNoMoreData];
            collectionView.mj_footer = footer;
        }
    }
}


/**
 *  上拉刷新无数据提示到底了或者数据不足一页隐藏footerView
 *
 *  @param tableView        tableView
 *  @param dataArray        数据数组
 *  @param pageMaxNumber    一页的最大数量
 *  @param responseObject   获取的当前页面的数据
 */
- (void)mj_FooterViewHidden:(UITableView *)tableView dataArray:(NSMutableArray *)dataArray pageMaxNumber:(NSInteger)pageMaxNumber responseObject:(nullable id)responseObject {
    NSArray *arr = responseObject;
    NSLog(@">>>>>>>>>>dataArray.count:%lu",arr.count);
    if (dataArray.count < pageMaxNumber) {
        tableView.mj_footer.hidden = YES;
    }
    if (arr.count == 0) {
        [tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - 无网络或者无数据提示

/**
 *  设置无数据或者无网络时候的提示图片
 *
 *  @param imgName 图片名称
 *  @param tipsStr 提示语
 *  @param view 要加的主视图
 */
- (void)noDataOrNoNetTipsString:(nullable NSString *)tipsStr addView:(nullable UIView *)view {
    
    
    UIImageView *tipImageView = [[UIImageView alloc]init];
    tipImageView.image = [UIImage imageNamed:@"NoData"];
    CGRect rect = tipImageView.frame;
    rect.origin = CGPointMake((kMainScreenWidth-tipImageView.image.size.width)/2, (ViewHeight(view)-tipImageView.image.size.height)/2-60);
    rect.size = CGSizeMake(tipImageView.image.size.width, tipImageView.image.size.height);
    tipImageView.frame = rect;
    tipImageView.tag = 1001010010;
    [view addSubview:tipImageView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, tipImageView.frame.origin.y+tipImageView.image.size.height+5, kMainScreenWidth-40, 35)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 2;
    tipLabel.font = [UIFont systemFontOfSize:17.0];
    tipLabel.textColor = RGB(175, 175, 175);
    tipLabel.text = tipsStr;
    tipLabel.tag = 1001010011;
    
    [view addSubview:tipLabel];
}

/**
 *  隐藏无网络的提示
 *
 *  @param view 父视图
 */
- (void)hideTipsViews:(UIView *)view {
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == 1001010010) {
            [obj removeFromSuperview];
            obj = nil;
        }
        if (obj.tag == 1001010011) {
            [obj removeFromSuperview];
            obj = nil;
        }
    }];
}

#pragma mark - 网络加载gif
- (void)showLoadingWithTips:(NSString *)tipsString {
    if (tipsString.length == 0 || tipsString == nil) {
        tipsString = @"正在加载中...";
    }
    _loadingView = [SCLoadingView shareManager];
    [_loadingView showLoadingTitle:tipsString];
}

- (void)dismiss {
    [_loadingView dismiss];
}

- (void)showLoadingWithTips:(nullable NSString *)tipsString inView:(nullable UIView *)view
{
    if (tipsString.length == 0 || tipsString == nil) {
        tipsString = @"正在加载中~";
    }
    
    _loadingView = [SCLoadingView shareManager];
    [_loadingView showLoadingTitle:tipsString inView:view];
    
}
#pragma mark -

// 当textField被弹出的键盘视图挡住时把整个视图上移（适用于4寸屏幕）
+ (void)animateTextField:(UITextField *)textField vc:(UIViewController *)vc {
    
    //        if (ThreePointFiveInch || FourInch) {
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [textField convertRect:textField.bounds toView:window];
    
    if (rect.origin.y > 160) {
        textFieldMoveHight = rect.origin.y - 200 + 60;
        [self animateUp:YES vc:vc hight:textFieldMoveHight];
    }
    //    }
}

//视图上移的方法
+ (void)animateUp:(BOOL)up vc:(UIViewController *)vc hight:(CGFloat)hight
{
    //三目运算，判定是否需要上移视图或者不变
    CGFloat movement = (up ? -hight : hight);
    //设置动画的名字
    [UIView beginAnimations:@"Animation"context:nil];
    //设置动画的开始移动位置
    [UIView setAnimationBeginsFromCurrentState:YES];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.20];
    //设置视图移动的位移
    vc.view.frame = CGRectOffset(vc.view.frame, 0, movement);
    //设置动画结束
    [UIView commitAnimations];
}

// 与上面配套使用，在textFiled编辑完成后，键盘消失时调用
+ (void)animateTextFieldEditEnd:(UIViewController *)vc {
    //    if (ThreePointFiveInch || FourInch) {
    if (textFieldMoveHight) {
        [SCComonFunc animateUp:NO vc:vc hight:textFieldMoveHight];
    }
    //    }
    
    textFieldMoveHight = 0;
}

//根据字符串返回字符串的size
+ (CGSize)commonFuncSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize

{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}

- (void)setTextFieldSetLeftView:(UITextField *)textField {
    
}

/**
 *  设置navigationBar的背景色
 */
- (void)setNavigationBarBackgroundColor:(UIView *)superView {
    if ([superView isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
    {
        //        //移除分割线
        //        for (UIView *view in superView.subviews)
        //        {
        //            if ([view isKindOfClass:[UIImageView class]])
        //            {
        //                [view removeFromSuperview];
        //            }
        //        }
        
        //设置背景色
        superView.backgroundColor = [UIColor whiteColor]; //[RDCommonFunc returnBackgroundColor];
    }
    else if ([superView isKindOfClass:NSClassFromString(@"_UIBackdropView")])
    {
        //_UIBackdropEffectView是_UIBackdropView的子视图，这是只需隐藏父视图即可
        superView.hidden = YES;
    }
    for (UIView *view in superView.subviews)
    {
        [self setNavigationBarBackgroundColor:view];
    }
}

//*******************************************************************************************


- (NSString *)getIPAddress {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"a" forKey:@"content"];
    NSURL *ipURL = [NSURL URLWithString:@"http://www.ip138.com/ip2city.asp"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
    NSArray *ipArr = [ip componentsSeparatedByString:@"center"];
    if (ipArr == nil) {
        return @"127.0.0.1";
    }
    
    ip = [ipArr objectAtIndex:1];
    NSRange range = NSMakeRange(10, [ip length]-14);
    [parameters setObject:[ip substringWithRange:range] forKey:@"clientip"];
    
    if ([parameters valueForKey:@"clientip"]) {
        return [parameters valueForKey:@"clientip"];
    } else {
        return @"127.0.0.1";
    }
}


//隐藏tabelView多余的cell
+(void)commonFuncHiddenExtraCells: (UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


@end
