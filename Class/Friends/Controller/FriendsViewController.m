//
//  FriendsViewController.m
//  kuaibu_3.0
//
//  Created by zxy on 15/8/18.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()<AVAudioRecorderDelegate>

@end

@implementation FriendsViewController









//录音后 他会在你的项目目录的temp文件夹里面 创建一个wangshuo.caf 文件  重复录制  他会覆盖上一个，如需多个录音 文件名称可以设置不同名称！


-(void)luyin{
    AVAudioSession * audioSession = [AVAudioSession sharedInstance]; if (!recording) {
        recording = YES;
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        [audioSession setActive:YES error:nil];
        [LuBut setTitle:@"停止" forState:UIControlStateNormal];
        
        NSDictionary *setting = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat: 44100.0],AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatAppleLossless],AVFormatIDKey, [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey, [NSNumber numberWithInt: 1], AVNumberOfChannelsKey, [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey, [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,[NSNumber numberWithInt: AVAudioQualityMax],AVEncoderAudioQualityKey,nil]; //然后直接把文件保存成.wav就好了
        tmpFile = [NSURL fileURLWithPath:
                   [NSTemporaryDirectory() stringByAppendingPathComponent:
                    [NSString stringWithFormat: @"%@.%@",
                     @"wangshuo",
                     @"caf"]]];
        recorder = [[AVAudioRecorder alloc] initWithURL:tmpFile settings:setting error:nil];
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        [recorder record];
    } else {
        recording = NO;
        [audioSession setActive:NO error:nil];
        [recorder stop];
        [LuBut setTitle:@"录音" forState:UIControlStateNormal];
    }

    
}
//播放音频
-(void)bofang{
    NSError *error;
    audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:tmpFile
                                                      error:&error];
    
    audioPlayer.volume=1;
    if (error) {
        NSLog(@"error:%@",[error description]);
        return;
    }
    //准备播放
    [audioPlayer prepareToPlay];
    //播放
    [audioPlayer play];
}



















- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self settitleLabel:@"朋友"];
    
    LuBut=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [LuBut setTitle:@"录音" forState:UIControlStateNormal];
    [self.view addSubview:LuBut];
    [LuBut addTarget:self action:@selector(luyin) forControlEvents:UIControlEventTouchUpInside];
    LuBut.frame=CGRectMake(30, 290, 60, 20);
    
    UIButton*BOBut=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [BOBut setFrame:CGRectMake(190, 290, 60 , 20)];
    [BOBut setTitle:@"播放"  forState:UIControlStateNormal];
    [BOBut addTarget:self action:@selector(bofang) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BOBut];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
