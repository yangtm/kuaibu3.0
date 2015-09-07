//
//  WoWAudioPlayer.m
//  YHB_Prj
//
//  Created by 童小波 on 15/6/7.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "WoWAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
//#import "NetManager.h"

@interface WoWAudioPlayer()<AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation WoWAudioPlayer

- (void)playWithUrl:(NSString *)url
{
    _audioPlayer = nil;
    
//    [NetManager downloadFileWithUrl:url parameters:nil progressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        
//    } succ:^(NSData *data) {
//
//        _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
//        
//    } failure:^(NSDictionary *failDict, NSError *error) {
//        
//    }];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

@end
