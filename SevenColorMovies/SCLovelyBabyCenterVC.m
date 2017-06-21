//
//  SCLovelyBabyCenterVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/15.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  萌娃首页

#import "SCLovelyBabyCenterVC.h"
#import "SCSearchBarView.h"
#import "SCLovelyBabyCell.h"
#import "SCBabyVC.h"

@interface SCLovelyBabyCenterVC ()<UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *searchHeaderView;
/** 搜索textField */
@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, strong) UICollectionView *collctionView;
@property (nonatomic, strong) UIButton *myVideoButton;
@property (nonatomic, strong) UIButton *activityDetailButton;

@end

@implementation SCLovelyBabyCenterVC

static NSString *const cellId = @"SCLovelyBabyCell";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBBI.text = @"萌娃";
    // 添加搜索框
    [self addSearchBBI];
    // 添加collectionView
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _searchHeaderView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 搜索框

- (void)addSearchBBI
{
    SCSearchBarView *searchView = [[SCSearchBarView alloc] initWithFrame:CGRectMake(0, 0, 190, 29)];
    searchView.searchTF.userInteractionEnabled = NO;
    searchView.searchTF.placeholder = @"请输入要搜索的人名";
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSearchBtn)];
    [searchView addGestureRecognizer:searchTap];
    
    UIButton *btn = (UIButton *)searchView;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];

    _searchHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    _searchHeaderView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    [self.navigationController.navigationBar addSubview:_searchHeaderView];
    
    SCSearchBarView *searchView2 = [[SCSearchBarView alloc] initWithFrame:CGRectMake(20, 7, kMainScreenWidth-80, 29)];
    searchView2.searchTF.placeholder = @"请输入要搜索的人名";
    self.searchTF = searchView2.searchTF;
    _searchTF.delegate = self;
    _searchTF.returnKeyType =  UIReturnKeySearch;
    [_searchHeaderView addSubview:searchView2];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor colorWithHex:@"#6798FC"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickCancelBotton) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [_searchHeaderView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.right.equalTo(_searchHeaderView).offset(0);
        make.centerY.equalTo(_searchHeaderView.mas_centerY);
    }];
    
    _searchHeaderView.hidden = YES;
}

- (void)clickSearchBtn
{
    [self.navigationController.navigationBar bringSubviewToFront:_searchHeaderView];
    [_searchTF becomeFirstResponder];
    _searchHeaderView.hidden = NO;
    self.view.alpha = 0.5f;
}

- (void)clickCancelBotton
{
    [_searchTF resignFirstResponder];
    _searchHeaderView.hidden = YES;
    self.view.alpha = 1.f;
}

#pragma mark - UICollectionView

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collctionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collctionView.backgroundColor = [UIColor colorWithHex:@"#dddddd"];
    _collctionView.alwaysBounceVertical = YES; // 设置当item较少时仍可以滑动
    _collctionView.dataSource = self;
    _collctionView.delegate = self;

    // 综艺栏目cell
    [_collctionView registerNib:[UINib nibWithNibName:@"SCLovelyBabyCell" bundle:nil] forCellWithReuseIdentifier:@"SCLovelyBabyCell"];
    
    [self.view addSubview:_collctionView];
    
    _collctionView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0); // 留白添加按钮
    UIButton *myVideoBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, -40, (kMainScreenWidth-60)/2, 40)];
    [myVideoBtn setBackgroundImage:[UIImage imageNamed:@"BlueBtnBG"] forState:UIControlStateNormal];
    [myVideoBtn setTitle:@"我的视频" forState:UIControlStateNormal];
    [myVideoBtn addTarget:self action:@selector(clickMyVideoBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *activityDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(40+(kMainScreenWidth-60)/2, -40, (kMainScreenWidth-60)/2, 40)];
    [activityDetailBtn setBackgroundImage:[UIImage imageNamed:@"OriginBtnBG"] forState:UIControlStateNormal];
    [activityDetailBtn setTitle:@"活动详情" forState:UIControlStateNormal];
    [activityDetailBtn addTarget:self action:@selector(clickActivityDetailBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_collctionView addSubview:myVideoBtn];
    [_collctionView addSubview:activityDetailBtn];
    
}

- (void)clickMyVideoBtn
{
    
}
- (void)clickActivityDetailBtn
{
    
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCLovelyBabyCell *cell = [SCLovelyBabyCell cellWithCollectionView:collectionView indexPath:indexPath];
    
    return cell;
}

/** 段头段尾设置 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {

    }
    
    return nil;
}


#pragma mark ---- UICollectionViewDelegateFlowLayout

/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(kMainScreenWidth-45)/2, (kMainScreenWidth-45)/2};
}

/** Section EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 15, 20, 15);
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}

/** item垂直间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}

/** section Header 尺寸 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){kMainScreenWidth,0};
}

/** section Footer 尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){kMainScreenWidth,0};
}

#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCBabyVC *babyVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCBabyVC");
    [self.navigationController pushViewController:babyVC animated:YES];

}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
