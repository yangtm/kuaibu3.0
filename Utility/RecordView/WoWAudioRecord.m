//
//  WoWAudioRecord.m
//  AFSoundManager-Demo
//
//  Created by 童小波 on 15/5/30.
//  Copyright (c) 2015年 AlvaroFranco. All rights reserved.
//

#import "WoWAudioRecord.h"
#import <AVFoundation/AVFoundation.h>

@interface WoWAudioRecord()

@property (strong, nonatomic) AVAudioRecorder *recorder;

@end

@implementation WoWAudioRecord

- (instancetype) initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        _filePath = filePath;
    }
    return self;
}

- (BOOL)start
{
    BOOL ret = YES;
    if (![self setAudioSession]) {
        return NO;
    }
    if ([[NSFileManager defaultManager] isExecutableFileAtPath:self.filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
    }
    ret = [self.recorder prepareToRecord];
    ret = [self.recorder record];
    return ret;
}

- (void)stop
{
    [self.recorder stop];
}

- (void)cancel
{
    [self stop];
}

- (BOOL)setAudioSession
{
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        return NO;
    }
    [audioSession setActive:YES error:&error];
    if (error) {
        return NO;
    }
    return YES;
}

- (AVAudioRecorder *)recorder
{
    if (_recorder == nil) {
//        NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
//        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
//        [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
//        [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        
        NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                       //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                       [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                       [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                       //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                       [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                       [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                       nil];
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_filePath] settings:recordSetting error:nil];
    }
    return _recorder;
}

@end
