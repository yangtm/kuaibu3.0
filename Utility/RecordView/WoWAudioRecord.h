//
//  WoWAudioRecord.h
//  AFSoundManager-Demo
//
//  Created by 童小波 on 15/5/30.
//  Copyright (c) 2015年 AlvaroFranco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WoWAudioRecord : NSObject

@property (strong, nonatomic) NSString *filePath;

- (instancetype) initWithFilePath:(NSString *)filePath;

- (BOOL)start;
- (void)stop;
- (void)cancel;

@end
