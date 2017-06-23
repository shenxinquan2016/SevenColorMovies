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
#import "SCMyLovelyBabyVC.h"
#import "SCActivityCenterVC.h"
#import "SCLovelyBabyLoginVC.h"
#import "SCLovelyBabyModel.h"

@interface SCLovelyBabyCenterVC ()<UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

/** 搜索textField */
@property (nonatomic, strong) UITextField *searchTF;
/** 搜索后面的取消按钮 */
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UICollectionView *collctionView;
@property (nonatomic, strong) UIButton *myVideoButton;
@property (nonatomic, strong) UIButton *activityDetailButton;
@property (nonatomic, strong) NSMutableArray *dataArray;

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
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    // 添加collectionView
    [self setupCollectionView];
    
    NSDictionary *parameters = @{@"siteId"      : @"hlj_appjh",
                                 @"memberId"    : @"",
                                 @"searchName"  : @"",
                                 @"searchType"  : @"paike",
                                 @"pageYema"    : @"1",
                                 @"pageSize"    : @"500",
                                 @"token"       : @""
                                 };
    [self getVideoListDataNetRequestWithParmeters:parameters];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 搜索框

// 添加搜索视图
- (void)addSearchBBI
{
    SCSearchBarView *searchView = [[SCSearchBarView alloc] initWithFrame:CGRectMake(0, 0, 190, 29)];
    searchView.searchTF.userInteractionEnabled = NO;
    searchView.searchTF.placeholder = @"请输入要搜索的人名";
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSearchBtn)];
    [searchView addGestureRecognizer:searchTap];
    
    UIButton *btn = (UIButton *)searchView;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];

}

// 点击搜索按钮
- (void)clickSearchBtn
{
    // 1.先将右item置为空
    self.navigationItem.rightBarButtonItems = nil;
    
    // 2.再添加左item
    UIView *searchHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    searchHeaderView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    [self.navigationController.navigationBar addSubview:searchHeaderView];
    
    SCSearchBarView *searchView = [[SCSearchBarView alloc] initWithFrame:CGRectMake(20, 7, kMainScreenWidth-80, 29)];
    searchView.searchTF.placeholder = @"请输入要搜索的人名";
    self.searchTF = searchView.searchTF;
    _searchTF.delegate = self;
    _searchTF.returnKeyType =  UIReturnKeySearch;
    [searchHeaderView addSubview:searchView];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor colorWithHex:@"#6798FC"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickCancelBotton) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn = button;
    [searchHeaderView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.right.equalTo(searchHeaderView).offset(0);
        make.centerY.equalTo(searchHeaderView.mas_centerY);
    }];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchHeaderView];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -14;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
    
    [_searchTF becomeFirstResponder];
    self.view.alpha = 0.5f;
    self.collctionView.userInteractionEnabled = NO;
}

// 点击取消按钮
- (void)clickCancelBotton
{
    // 1.添加右侧item
    [self addSearchBBI];
    // 2.重新添加左侧item
    [self addNavigationBarLeftBarButtonItem];

    self.view.alpha = 1.f;
    self.collctionView.userInteractionEnabled = YES;
    NSDictionary *parameters = @{@"siteId"      : @"hlj_appjh",
                                 @"memberId"    : @"",
                                 @"searchName"  : @"",
                                 @"searchType"  : @"paike",
                                 @"pageYema"    : @"1",
                                 @"pageSize"    : @"500",
                                 @"token"       : @""
                                 };
    [_dataArray removeAllObjects];
    [self getVideoListDataNetRequestWithParmeters:parameters];
}

// 重新添加导航栏左item
- (void)addNavigationBarLeftBarButtonItem
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 32)];
    //    view.backgroundColor = [UIColor redColor];
    // 返回箭头
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Back_Arrow"]];
    [view addSubview:imgView];
    //    imgView.backgroundColor = [UIColor grayColor];
    [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(imgView.image.size);
        
    }];
    // 返回标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 22)];
    //    titleLabel.backgroundColor = [UIColor greenColor];
    titleLabel.text = @"萌娃";
    titleLabel.textColor = [UIColor colorWithHex:@"#878889"];
    titleLabel.font = [UIFont systemFontOfSize: 19.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(imgView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(125, 22));
        
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [view addGestureRecognizer:tap];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -6;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
}

#pragma mark - 我的视频 && 活动详情

- (void)clickMyVideoBtn
{
    if (UserInfoManager.lovelyBabyIsLogin) { // 已登录
        
        SCMyLovelyBabyVC *myVideoVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCMyLovelyBabyVC");
        [self.navigationController pushViewController:myVideoVC animated:YES];
        
    } else { // 未登录
        
        SCLovelyBabyLoginVC *loginVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCLovelyBabyLoginVC");
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

- (void)clickActivityDetailBtn
{
    SCActivityCenterVC *activityVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCActivityCenterVC");
    [self.navigationController pushViewController:activityVC animated:YES];
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
    [self.view addSubview:_collctionView];
    
}


#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCLovelyBabyCell *cell = [SCLovelyBabyCell cellWithCollectionView:collectionView indexPath:indexPath];
    SCLovelyBabyModel *babyModel = _dataArray[indexPath.item];
    cell.babyModel = babyModel;
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
    SCLovelyBabyModel *babyModel = _dataArray[indexPath.item];
    SCBabyVC *babyVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCBabyVC");
    babyVC.babyModel = babyModel;
    [self.navigationController pushViewController:babyVC animated:YES];
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSDictionary *parameters = @{@"siteId"      : @"hlj_appjh",
                                 @"memberId"    : @"",
                                 @"searchName"  : _searchTF.text? _searchTF.text : @"",
                                 @"searchType"  : @"paike",
                                 @"pageYema"    : @"1",
                                 @"pageSize"    : @"500",
                                 @"token"       : @""
                                 };
    [_dataArray removeAllObjects];
    [_searchTF resignFirstResponder];
    [self getVideoListDataNetRequestWithParmeters:parameters];
    
    return YES;
}

#pragma mark - NetRequest

- (void)getVideoListDataNetRequestWithParmeters:(NSDictionary *)parameters
{
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager getRequestJsonDataWithUrl:LovelyBabyVideoList parameters:parameters success:^(id  _Nullable responseObject) {
                DONG_Log(@"responseObject-->%@",responseObject);
        NSString *resultCode = responseObject[@"resultCode"];
        
        if ([resultCode isEqualToString:@"success"]) {
            
            NSArray *array = responseObject[@"data"];
            
            for (NSDictionary *dict in array) {
                SCLovelyBabyModel *model = [SCLovelyBabyModel mj_objectWithKeyValues:dict];
                [_dataArray addObject:model];
            }
            
        } else if ([resultCode isEqualToString:@"tokenInvalid"]) {
            
            UserInfoManager.lovelyBabyIsLogin = NO;
            [UserInfoManager removeUserInfo];
            SCLovelyBabyLoginVC *loginVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCLovelyBabyLoginVC");
            [self.navigationController pushViewController:loginVC animated:YES];
            
        } else {
            
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        }
        [_cancelBtn setTitle:@"完成" forState:UIControlStateNormal];
        _collctionView.userInteractionEnabled = YES;
        self.view.alpha = 1.f;
        [_collctionView reloadData];
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
}


@end
