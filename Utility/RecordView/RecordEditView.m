//
//  RecordEditView.m
//  AFSoundManager-Demo
//
//  Created by 童小波 on 15/5/29.
//  Copyright (c) 2015年 AlvaroFranco. All rights reserved.
//

#import "RecordEditView.h"
#import "UIViewAdditions.h"
#import "SZTextView.h"
#import "WoWAudioRecord.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import "Public.h"
#import "RecordAudio.h"

@interface RecordEditView()<UITextViewDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) SZTextView *textView;
@property (assign, nonatomic) BOOL isRecord;
@property (assign, nonatomic) NSInteger seconds;
@property (strong, nonatomic) WoWAudioRecord *audioRecord;
@property (strong, nonatomic) UIView *shadeView;
@property (strong, nonatomic) UIView *hintView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIImageView *hintImageView;
@property (strong, nonatomic) UILabel *hintLabel;
@property (assign, nonatomic) BOOL isInside;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImageView *playImageView;
@property (assign, nonatomic) BOOL isPlaying;
@property (assign, nonatomic) BOOL recordButtonVisible;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation RecordEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectAtIndex:0];
        _filePath = [NSString stringWithFormat:@"%@/MySound.caf", cachesDir];
        _audioRecord = [[WoWAudioRecord alloc] initWithFilePath:_filePath];
        
        [self addSubview:self.switchButton];
        [self addSubview:self.recordButton];
        [self addSubview:self.playButton];
        [self addSubview:self.textView];
        self.textView.hidden = YES;
        self.playButton.hidden = YES;
        self.isRecord = YES;
        self.recordButtonVisible = YES;
        self.currentHeight = self.height;
        _editViewModel = RecordEditViewModelNone;
        
    }
    return self;
}

-(void)setRecordButtonAvaliable:(BOOL)avaliable
{
    self.recordButton.userInteractionEnabled = avaliable;
}

- (void)stopPlay
{
    [self setPlayImageViewNormal];
}

#pragma mark - event response
- (void)switchButtonClick:(UIButton *)sender
{
    if (_isRecord) {
        [_switchButton setImage:[UIImage imageNamed:@"mic-button"] forState:UIControlStateNormal];
        _recordButton.hidden = YES;
        _playButton.hidden = YES;
        _textView.hidden = NO;
        [_textView becomeFirstResponder];
        [self setPlayImageViewNormal];
        _editViewModel = RecordEditViewModelText;
    }
    else{
        [_switchButton setImage:[UIImage imageNamed:@"keyboard-button"] forState:UIControlStateNormal];
        _textView.hidden = YES;
        [_textView resignFirstResponder];
        if (_recordButtonVisible) {
            _recordButton.hidden = NO;
            _editViewModel = RecordEditViewModelNone;
        }
        else{
            _playButton.hidden = NO;
            _editViewModel = RecordEditViewModelSound;
        }
    }
    _isRecord = !_isRecord;
    _difHeight = -_difHeight;
    [_delegate editViewSizeDidChanged:self];
}

- (void)recordButtonTouchDown:(UIButton *)sender
{
    [sender setTitle:@"按住说话" forState:UIControlStateNormal];
    _isInside = YES;
    _hintLabel.text = @"手指上滑，取消";
    _hintImageView.image = [UIImage imageNamed:@"RecordingBkg"];
    _recordButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    [self showShadeView];
}

- (void)recordButtonTouchUpInside:(UIButton *)sender
{
    [sender setTitle:@"按住说出面料详情" forState:UIControlStateNormal];
    [self dismissShadeView];
    _recordButton.backgroundColor = [UIColor colorWithRed:230/255.0 green:69/255.0 blue:14/255.0 alpha:1];
}

- (void)recordButtonTouchUpOutside:(UIButton *)sender
{
    [sender setTitle:@"按住说出面料详情" forState:UIControlStateNormal];
    [self dismissShadeView];
    _recordButton.backgroundColor = [UIColor colorWithRed:230/255.0 green:69/255.0 blue:14/255.0 alpha:1];
}

- (void)dragInside:(UIButton *)sender withEvents:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint relativeLocToInitialCell = [touch locationInView:sender];
    [self handleTouchPoint:relativeLocToInitialCell];
}

- (void)dragOutside:(UIButton *)sender withEvents:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint relativeLocToInitialCell = [touch locationInView:sender];
    [self handleTouchPoint:relativeLocToInitialCell];
}

- (void)recordButtonDragExit:(UIButton *)sender
{
    NSLog(@"darg exit");
}

- (void)timeoutHnadle:(NSTimer *)timer
{
    _timeLabel.text = [NSString stringWithFormat:@"%d ''", (int)_seconds--];
    if (_seconds == -1) {
        [self stopTimer];
    }
}

- (void)cancelButtonClick:(UIButton *)sender
{
    _playButton.hidden = YES;
    _recordButton.hidden = NO;
    _recordButtonVisible = YES;
    [self setPlayImageViewNormal];
    _editViewModel = RecordEditViewModelNone;
    if (_netAudio) {
        _netAudio = NO;
    }
}

- (void)playButtonClick:(UIButton *)sender
{
    if (_isPlaying) {
        [self setPlayImageViewNormal];
    }
    else{
        [self setPlayImageViewPlay];
    }
    _isPlaying = !_isPlaying;
}

- (void)keyboardWillShow:(NSNotification*)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    if (_attachScrollView != nil) {
        CGRect rect = [self convertRect:_textView.frame toView:_attachScrollView];
        CGFloat dif = rect.origin.y - _attachScrollView.contentOffset.y;
        UIView *contentView = _attachScrollView.superview;
        CGFloat dif1 = contentView.frame.size.height - dif;
        if (dif1 < keyboardBounds.size.height) {
            CGFloat dif2 = keyboardBounds.size.height - dif1 + self.textView.height;
            CGPoint point = _attachScrollView.contentOffset;
            point.y += dif2;
            _attachScrollView.contentOffset = point;
        }
    }
}

- (void)keyboardWillHide:(NSNotification*)note
{
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
}

#pragma mark - private methods
- (void)showShadeView
{
    if (_shadeView == nil) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        _shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _shadeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.hintView.center = CGPointMake(width / 2.0, height / 2.0 - 100);
        [_shadeView addSubview:self.hintView];
    }
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:_shadeView];
    [self startTimer];
}

- (void)dismissShadeView
{
    [_shadeView removeFromSuperview];
    [self stopTimer];
    if (_isInside && _seconds > 56) {
//        [SVProgressHUD showInfoWithStatus:@"录音时间太短，请重试"];
        [SVProgressHUD showErrorWithStatus:@"录音时间太短，请重试" cover:YES offsetY:kMainScreenHeight / 2.0];
    }
    else if(_isInside && _seconds <= 56){
        _recordButton.hidden = YES;
        _playButton.hidden = NO;
        _recordButtonVisible = NO;
        [_playButton setTitle:[NSString stringWithFormat:@"点击重听  %d ''", 60 - (int)_seconds - 1] forState:UIControlStateNormal];
        _editViewModel = RecordEditViewModelSound;
    }
}

- (void)handleTouchPoint:(CGPoint)point
{
    if (point.x >= 0 && point.x <= _recordButton.width && point.y >= 0 && point.y <= _recordButton.height) {
        if (!_isInside) {
            _isInside = !_isInside;
            _hintLabel.text = @"手指上滑，取消";
            _hintImageView.image = [UIImage imageNamed:@"RecordingBkg"];
            _recordButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        }
    }
    else{
        if (_isInside) {
            _isInside = !_isInside;
            _hintLabel.text = @"手指松开，取消";
            _hintImageView.image = [UIImage imageNamed:@"RecordCancel"];
            _recordButton.backgroundColor = [UIColor colorWithRed:230/255.0 green:69/255.0 blue:14/255.0 alpha:1];
        }
    }
}

- (void)startTimer
{
    _timeLabel.text = @"开始录音";
    _seconds = 59;
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeoutHnadle:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [self.audioRecord start];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
    [self.audioRecord stop];
}

- (void)setPlayImageViewPlay
{
    NSArray *array = @[[UIImage imageNamed:@"ReceiverVoiceNodePlaying001"],
                       [UIImage imageNamed:@"ReceiverVoiceNodePlaying002"],
                       [UIImage imageNamed:@"ReceiverVoiceNodePlaying003"]];
    _playImageView.animationImages = array;
    _playImageView.contentMode = UIViewContentModeScaleAspectFit;
    _playImageView.animationDuration = 1.0;
    _playImageView.animationRepeatCount = 0;
    [_playImageView startAnimating];
    [self playSound];
}

- (void)setPlayImageViewNormal
{
    [_playImageView stopAnimating];
    _playImageView.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
    [self stopPalySound];
}

- (void)playSound
{
    if (_audioPlayer == nil) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    
//    NSError *error;
//    _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:_audioRecord.filePath
//                                                      error:&error];
//    
//    _audioPlayer.volume=1;
//    if (error) {
//        NSLog(@"error:%@",[error description]);
//        return;
//    }
//    //准备播放
//    [_audioPlayer prepareToPlay];
//    //播放
//    [_audioPlayer play];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (_netAudio) {
        if ([_delegate respondsToSelector:@selector(editViewAudioData:audioData:)]) {
            [_delegate editViewAudioData:self audioData:^(NSData *data) {
                _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
                _audioPlayer.volume = 1.0;
                _audioPlayer.delegate = self;
                [_audioPlayer prepareToPlay];
                [_audioPlayer play];
            }];
        }
    }
    else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/MySound.caf", cachesDir]];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _audioPlayer.volume = 1.0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
    }
}

- (void)stopPalySound
{
    [_audioPlayer stop];
    _audioPlayer = nil;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    [textView flashScrollIndicators];   // 闪动滚动条
    static CGFloat maxHeight = 130.0f;
    static CGFloat minHeight = 40.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= maxHeight)
    {
        size.height = maxHeight;
        textView.scrollEnabled = YES;   // 允许滚动
    }
    else
    {
        textView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    if (size.height < minHeight) {
        size.height = minHeight;
    }
    if (self.currentHeight != size.height) {
        self.difHeight = size.height - self.currentHeight;
        self.currentHeight = size.height;
        [_delegate editViewSizeDidChanged:self];
        if (self.currentHeight == minHeight) {
            self.difHeight = 0;
        }
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self setPlayImageViewNormal];
}

#pragma mark - setters and getters
- (UIButton *)switchButton
{
    if (_switchButton == nil) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchButton.frame = CGRectMake(0, 0, 40, 40);
        [_switchButton setImage:[UIImage imageNamed:@"keyboard-button"] forState:UIControlStateNormal];
        _switchButton.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
        _switchButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_switchButton addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UIButton *)recordButton
{
    if (_recordButton == nil) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordButton.frame = CGRectMake(self.switchButton.right + 0, 0, self.width - self.switchButton.right -10, 40);
        [_recordButton setTitle:@"按住说出面料详情" forState:UIControlStateNormal];
        
        [_recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _recordButton.backgroundColor = [UIColor colorWithRed:230/255.0 green:69/255.0 blue:14/255.0 alpha:1];
        _recordButton.layer.cornerRadius = 4.0;
        [_recordButton addTarget:self action:@selector(recordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(recordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(recordButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_recordButton addTarget:self action:@selector(dragOutside:withEvents:) forControlEvents:UIControlEventTouchDragOutside];
        [_recordButton addTarget:self action:@selector(dragInside:withEvents:) forControlEvents:UIControlEventTouchDragInside];
        [_recordButton addTarget:self action:@selector(recordButtonDragExit:) forControlEvents:UIControlEventTouchDragExit];
    }
    return _recordButton;
}

- (UIButton *)playButton
{
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(self.switchButton.right + 0, 0, self.width - self.switchButton.right - 10, 40);
        _playButton.layer.cornerRadius = 4.0;
        _playButton.layer.borderColor = [UIColor colorWithRed:230/255.0 green:69/255.0 blue:14/255.0 alpha:1].CGColor;
        _playButton.layer.borderWidth = 1.0;
        [_playButton setTitle:@"点击重听" forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor colorWithRed:230/255.0 green:69/255.0 blue:14/255.0 alpha:1] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.playImageView.frame = CGRectMake(10, 10, 20, 20);
        [_playButton addSubview:self.playImageView];
        [self setPlayImageViewNormal];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(_playButton.width - 30, 5, 30, 30);
        [cancelButton setImage:[UIImage imageNamed:@"card_delete"] forState:UIControlStateNormal];
        cancelButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchDown];
        [_playButton addSubview:cancelButton];
    }
    return _playButton;
}

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[SZTextView alloc] initWithFrame:CGRectMake(self.switchButton.right + 0, 0, self.width - self.switchButton.right - 10, 40)];
        _textView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:69/255.0 blue:14/255.0 alpha:1].CGColor;
        _textView.layer.borderWidth = 1.0;
        _textView.layer.cornerRadius = 4.0;
        _textView.layer.masksToBounds = YES;
        _textView.font = [UIFont systemFontOfSize:14.0];
        _textView.placeholder = @"请详细描述布料的门幅、材质、使用范围";
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}

- (UIView *)hintView
{
    if (_hintView == nil) {
        _hintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        _hintView.backgroundColor = [UIColor blackColor];
        _hintView.alpha = 0.8;
        _hintView.layer.cornerRadius = 6.0;
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, _hintView.width, 15)];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"开始录音";
        [_hintView addSubview:_timeLabel];
        _hintImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        _hintImageView.center = _hintView.center;
        _hintImageView.contentMode = UIViewContentModeScaleAspectFit;
        _hintImageView.image = [UIImage imageNamed:@"RecordingBkg"];
        [_hintView addSubview:_hintImageView];
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _hintView.height - 15, _hintView.width, 15)];
        _hintLabel.textColor = [UIColor whiteColor];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.font = [UIFont systemFontOfSize:14.0];
        _hintLabel.text = @"手指上滑，取消";
        [_hintView addSubview:_hintLabel];
    }
    return _hintView;
}

- (UIImageView *)playImageView
{
    if (_playImageView == nil) {
        _playImageView = [[UIImageView alloc] init];
    }
    return _playImageView;
}

- (NSString *)text
{
    return _textView.text;
}

- (NSInteger)recordDuration
{
    return 59 - _seconds;
}

- (void)setRecordDuration:(NSInteger)recordDuration
{
    _seconds = 59 - recordDuration;
}

- (void)setNetAudio:(BOOL)netAudio
{
    _netAudio = netAudio;
    _recordButton.hidden = YES;
    _playButton.hidden = NO;
    _recordButtonVisible = NO;
    [_playButton setTitle:[NSString stringWithFormat:@"点击重听  %d ''", 60 - (int)_seconds - 1] forState:UIControlStateNormal];
    _editViewModel = RecordEditViewModelSound;
}

- (void)setText:(NSString *)text
{
    [_switchButton setImage:[UIImage imageNamed:@"mic-button"] forState:UIControlStateNormal];
    _recordButton.hidden = YES;
    _playButton.hidden = YES;
    _textView.hidden = NO;
    _textView.text = text;
    [self setPlayImageViewNormal];
    _editViewModel = RecordEditViewModelText;
    [self textViewDidChange:_textView];
}

- (void)setEditViewModel:(RecordEditViewModel)editViewModel
{
    _editViewModel = editViewModel;
    if (_editViewModel == RecordEditViewModelNone) {
        _isRecord = YES;
        _recordButtonVisible = YES;
        [_switchButton setImage:[UIImage imageNamed:@"keyboard-button"] forState:UIControlStateNormal];
        _textView.hidden = YES;
        _recordButton.hidden = NO;
    }
    else if (_editViewModel == RecordEditViewModelSound){
        _isRecord = YES;
        _recordButtonVisible = NO;
        [_switchButton setImage:[UIImage imageNamed:@"keyboard-button"] forState:UIControlStateNormal];
        _textView.hidden = YES;
        _playButton.hidden = NO;
    }
    else if (_editViewModel == RecordEditViewModelText){
        _isRecord = NO;
        [_switchButton setImage:[UIImage imageNamed:@"mic-button"] forState:UIControlStateNormal];
        _recordButton.hidden = YES;
        _playButton.hidden = YES;
        _textView.hidden = NO;
    }
}

@end
