//
//  SCMyDownLoadManagerCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载cell

#import "SCMyDownLoadManagerCell.h"
#import "Dong_DownloadModel.h"


@interface SCMyDownLoadManagerCell ()

@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (weak, nonatomic) IBOutlet UILabel *fimlNameLabel;/** 影片名称 */
@property (weak, nonatomic) IBOutlet UILabel *filmEpisodeLabel;/** 第几集 */
@property (weak, nonatomic) IBOutlet UILabel *downLoadProgressLabel;/** 数字进度 */
@property (weak, nonatomic) IBOutlet UILabel *downLoadStateLabel;/** 下载状态 */
@property (weak, nonatomic) IBOutlet UIProgressView *downLoadProgressView;/** 进度条 */


@end

@implementation SCMyDownLoadManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deleteBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCMyDownLoadManagerCell";
    SCMyDownLoadManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHex:@"f3f3f3"];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
        self.frame = frame;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setFilmModel:(SCFilmModel *)filmModel {
    _fimlNameLabel.text = filmModel.FilmName;
    
    if (filmModel.isShowDeleteBtn) {
        _deleteBtn.hidden = NO;
        _downLoadBtn.hidden = YES;
        if (filmModel.isSelecting) {
            [_deleteBtn setImage:[UIImage imageNamed:@"Select"]];
        }else{
            [_deleteBtn setImage:[UIImage imageNamed:@"Unselected"]];
            
        }
        
    }else{
        _deleteBtn.hidden = YES;
        _downLoadBtn.hidden = NO;
        
        if (filmModel.isDownLoading) {
            [_downLoadBtn setImage:[UIImage imageNamed:@"PauseDownload"] forState:UIControlStateNormal];
        }else{
            [_downLoadBtn setImage:[UIImage imageNamed:@"DownLoadIMG"] forState:UIControlStateNormal];
            
        }
        
    }
}

- (void)setDownloadModel:(Dong_DownloadModel *)downloadModel {
    if (_downloadModel != downloadModel) {
        _downloadModel = downloadModel;
    }
    
    self.fimlNameLabel.text = downloadModel.filmName;
    self.downLoadProgressLabel.text = downloadModel.progressText;
    [self.downLoadProgressView setProgress:downloadModel.progress];
    self.downLoadStateLabel.text = downloadModel.statusText;
    
    if (downloadModel.isShowDeleteBtn) {
        _deleteBtn.hidden = NO;
        _downLoadBtn.hidden = YES;
        if (downloadModel.isSelecting) {
            [_deleteBtn setImage:[UIImage imageNamed:@"Select"]];
        }else{
            [_deleteBtn setImage:[UIImage imageNamed:@"Unselected"]];
            
        }
        
    } else {
        
        _deleteBtn.hidden = YES;
        _downLoadBtn.hidden = NO;
        
        if (downloadModel.isDownLoading) {
            [_downLoadBtn setImage:[UIImage imageNamed:@"PauseDownload"] forState:UIControlStateNormal];
        }else{
            [_downLoadBtn setImage:[UIImage imageNamed:@"DownLoadIMG"] forState:UIControlStateNormal];
            
        }
        
    }
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    
    _fileInfo = fileInfo;
    
    if (fileInfo.isShowDeleteBtn) {
        _deleteBtn.hidden = NO;
        _downLoadBtn.hidden = YES;
        if (fileInfo.isSelecting) {
            [_deleteBtn setImage:[UIImage imageNamed:@"Select"]];
        }else{
            [_deleteBtn setImage:[UIImage imageNamed:@"Unselected"]];
            
        }
        
    } else {
        
        _deleteBtn.hidden = YES;
        _downLoadBtn.hidden = NO;
        
        if (fileInfo.downloadState == ZFDownloading) {
            [_downLoadBtn setImage:[UIImage imageNamed:@"PauseDownload"] forState:UIControlStateNormal];
        }else{
            [_downLoadBtn setImage:[UIImage imageNamed:@"DownLoadIMG"] forState:UIControlStateNormal];
            
        }
        
    }

    
    self.fimlNameLabel.text = fileInfo.fileName;
    // 服务器可能响应的慢，拿不到视频总长度 && 不是下载状态
    if ([fileInfo.fileSize longLongValue] == 0 && !(fileInfo.downloadState == ZFDownloading)) {
        self.downLoadProgressLabel.text = @"--";
        if (fileInfo.downloadState == ZFStopDownload) {
            self.downLoadStateLabel.text = @"已暂停";
        } else if (fileInfo.downloadState == ZFWillDownload) {
            self.downLoadBtn.selected = YES;
            self.downLoadStateLabel.text = @"等待下载";
        }
        self.downLoadProgressView.progress = 0.0;
        return;
    }
    NSString *currentSize = [ZFCommonHelper getFileSizeString:fileInfo.fileReceivedSize];
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    
    self.downLoadProgressLabel.text = [NSString stringWithFormat:@"%@ / %@ (%.2f%%)",currentSize, totalSize, progress*100];
    
    DONG_Log(@"进度：%@",self.downLoadProgressLabel.text);
    
    self.downLoadProgressView.progress = progress;
    
    NSString *spped = [NSString stringWithFormat:@"%@/S",[ZFCommonHelper getFileSizeString:[NSString stringWithFormat:@"%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]]]];
    self.downLoadStateLabel.text = spped;
    
    if (fileInfo.downloadState == ZFDownloading) { //文件正在下载
        self.downLoadBtn.selected = NO;
    } else if (fileInfo.downloadState == ZFStopDownload&&!fileInfo.error) {
        self.downLoadBtn.selected = YES;
        self.downLoadStateLabel.text = @"已暂停";
    } else if (fileInfo.downloadState == ZFWillDownload&&!fileInfo.error) {
        self.downLoadBtn.selected = YES;
        self.downLoadStateLabel.text = @"等待下载";
    } else if (fileInfo.error) {
        self.downLoadBtn.selected = YES;
        self.downLoadStateLabel.text = @"错误";
    }
}

// 开始下载或暂停下载
- (IBAction)startOrPauseDownLoad:(UIButton *)sender {
   
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    ZFFileModel *downFile = self.fileInfo;
    ZFDownloadManager *filedownmanage = [ZFDownloadManager sharedDownloadManager];
    if(downFile.downloadState == ZFDownloading) { //文件正在下载，点击之后暂停下载 有可能进入等待状态
        self.downLoadBtn.selected = YES;
        [self.downLoadBtn setImage:[UIImage imageNamed:@"PauseDownload"] forState:UIControlStateNormal];
        [filedownmanage stopRequest:self.request];
    } else {
        self.downLoadBtn.selected = NO;
        [self.downLoadBtn setImage:[UIImage imageNamed:@"DownLoadIMG"] forState:UIControlStateNormal];
        [filedownmanage resumeRequest:self.request];
    }
    
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.downloadBlock) {
        self.downloadBlock();
    }
    sender.userInteractionEnabled = YES;
}


@end
