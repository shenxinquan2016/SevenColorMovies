//
//  SCLovelyBabyUploadVideoVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/23.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  视频编辑上传

#import "SCLovelyBabyUploadVideoVC.h"
#import "SCHuikanPlayerViewController.h"
#import "UIImage+IMB.h"
#import "SCMyLovelyBabyVC.h"

@interface SCLovelyBabyUploadVideoVC ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView; // 视频封面
@property (weak, nonatomic) IBOutlet UITextField *videoNameTF; // 标题
@property (weak, nonatomic) IBOutlet UITextView *videoIntroductionTV; // 简介
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel; // 简介textView placeHolder
@property (weak, nonatomic) IBOutlet UILabel *amountLabel; // 字数

@property (weak, nonatomic) IBOutlet UIButton *imagePickerButton; // 照片选择器按钮

@property (nonatomic, strong) UIImagePickerController *imagePicker; // 照片选择器
@property (nonatomic, strong) UIImage *pickedImage; // 所选取相册照片

@property (nonatomic, strong) NSString *taskId; // 任务ID

@end

@implementation SCLovelyBabyUploadVideoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBBI];
    self.title = [NSString stringWithFormat:@"%02ld:%02ld", _videoLength/60, _videoLength%60];
    _videoIntroductionTV.delegate = self;
    // 设置视频第一帧图片
    [_coverImageView setImage:_videoCoverImage];
    // 获取任务id
    [self getVideoTaskData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置导航栏的主题(效果只作用当前页面）
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.edgesForExtendedLayout = 0;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)addBBI
{
    // 左边
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 32)];
    //    view.backgroundColor = [UIColor redColor];
    // 返回箭头
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Back_Arrow_White"]];
    [view addSubview:imgView];
    //    imgView.backgroundColor = [UIColor grayColor];
    [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(10, 17));
        
    }];
    // 返回标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 22)];
    //    titleLabel.backgroundColor = [UIColor greenColor];
    
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

// 选择封面照片
- (IBAction)pickCoverPhoto:(id)sender
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
}

// 视频上传
- (IBAction)uploadVideo:(id)sender
{
    [self uploadVideoDataRequest];
}

- (IBAction)playVideo:(id)sender
{
    SCHuikanPlayerViewController *player = [SCHuikanPlayerViewController initPlayerWithFilePath:_videoFilePath];
    [self.navigationController pushViewController:player animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    // 等比压缩图片
    UIImage *clipImage = [image imageCompressForSize:image targetSize:CGSizeMake(284, 160)];
    _pickedImage = clipImage;
    [_imagePickerButton setBackgroundImage:clipImage forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger res = 60 -  textView.text.length;
    self.amountLabel.text = [NSString stringWithFormat:@"%ld/60", (long)res];
    if (textView.text.length > 60) {
        [MBProgressHUD showError:@"最多输入60个字"];
        textView.text = [textView.text substringToIndex:60];
        self.amountLabel.text = [NSString stringWithFormat:@"%d/60", 0];
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //    if ([text isEqualToString:@"\n"]) { // 检测到“完成”
    //        [textView resignFirstResponder]; // 释放键盘
    //        return NO;
    //    }
    //    if (textView.text.length == 0){ // textview长度为0
    //        if ([text isEqualToString:@""]) { // 判断是否为删除键
    //            _placeHolderLabel.hidden = NO; // 隐藏文字
    //        } else {
    //            _placeHolderLabel.hidden = YES;
    //        }
    //    } else { // textview长度不为0
    //        if (textView.text.length == 1){ // textview长度为1时候
    //            if ([text isEqualToString:@""]) { // 判断是否为删除键
    //                _placeHolderLabel.hidden=NO;
    //            } else { // 不是删除
    //                _placeHolderLabel.hidden = YES;
    //            }
    //        } else { // 长度不为1时候
    //            _placeHolderLabel.hidden = YES;
    //        }
    //    }
    
    if (![text isEqualToString:@""]) {
        _placeHolderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _placeHolderLabel.hidden = NO;
    }
    
    //    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    //    NSInteger res = 60 - [new length];
    //
    //    _amountLabel.text = [NSString stringWithFormat:@"%ld/60", (long)res];
    //
    //    if (res < 0) {
    //        _amountLabel.text = @"0/60";
    //    }
    //
    //    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    //    if (temp.length > 60) {
    //        textView.text = [temp substringToIndex:60];
    //        [MBProgressHUD showError:@"最多输入60个字"];
    //        return NO;
    //    }
    
    return YES;
}

#pragma mark - Network Request

// 上传数据
- (void)uploadVideoDataRequest
{
    // 封面图片文件
    NSData *coverImageData = UIImagePNGRepresentation(_pickedImage);
    // 视频文件
    NSData *videoData = [NSData dataWithContentsOfFile:_videoFilePath];
    
    if (videoData.length <= 0) {
        [MBProgressHUD showError:@"视频保存失败，请重新拍摄"];
        return;
    }
    
    if (coverImageData.length <= 0) {
        [MBProgressHUD showError:@"请选择封面图片"];
        return;
    }
    
    if (_videoNameTF.text.length <= 0) {
        [MBProgressHUD showError:@"请填写视频标题"];
        return;
    }
    
    if (_taskId.length <= 0) {
        [MBProgressHUD showError:@"数据错误，请稍后再试"];
        return;
    }
    
    NSDictionary *parameters = @{@"title"       : _videoNameTF.text? _videoNameTF.text : @"", // 标题
                                 @"siteCode"    : @"hlj_appjh",
                                 @"memberCode"  : UserInfoManager.lovelyBabyMemberId,
                                 @"remark"      : _videoIntroductionTV.text? _videoIntroductionTV.text : @"", // 视频描述
                                 @"taskName"    : @"萌娃", // 任务名称
                                 @"taskId"      : _taskId? _taskId : @"", // 任务id
                                 @"token"       : UserInfoManager.lovelyBabyToken
                                 };
    
    [CommonFunc showLoadingWithTips:@"数据上传中..."];
    
    [requestDataManager postUploadDataWithUrl:LovelyBabyVideoUpload video:videoData imgData:coverImageData parameters:parameters success:^(id  _Nullable responseObject) {
        
        DONG_Log(@"responseObject--%@", responseObject);
        
        DONG_MAIN_AFTER(1,
                        [CommonFunc dismiss];
                        [MBProgressHUD showSuccess:responseObject[@"msg"]];
                        SCMyLovelyBabyVC *myVideoVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCMyLovelyBabyVC");
                        [self.navigationController pushViewController:myVideoVC animated:YES];
                        );
        
    } fail:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
        
    }];
    
}

// 获取任务列表
- (void)getVideoTaskData
{
    NSDictionary *parameters = @{@"siteId"      : @"hlj_appjh",
                                 @"ljwl"        : @"",
                                 @"pageYema"    : @"1",
                                 @"pageSize"    : @"1000"
                                 };
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager getRequestJsonDataWithUrl:LovelyBabyVideoTask parameters:parameters success:^(id  _Nullable responseObject) {
        
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSString *resultCode = responseObject[@"resultCode"];
        if ([resultCode isEqualToString:@"success"]) {
            
            NSArray *taskArray = responseObject[@"data"];
            _taskId = taskArray.firstObject[@"id"];
            
        } else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    
}


// 禁止旋转屏幕
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}

@end
