//
//  SCLovelyBabyUploadVideoVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/23.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCLovelyBabyUploadVideoVC.h"

@interface SCLovelyBabyUploadVideoVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *videoNameTF;
@property (weak, nonatomic) IBOutlet UITextView *videoIntroductionTV;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;


@end

@implementation SCLovelyBabyUploadVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _videoIntroductionTV.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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

@end
