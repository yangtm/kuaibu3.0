//
//  FriendsViewController.h
//  kuaibu_3.0
//
//  Created by zxy on 15/8/18.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FriendsViewController : BaseViewController
{
    
    NSURL *tmpFile;
    AVAudioRecorder *recorder;
    BOOL recording;
    AVAudioPlayer *audioPlayer;
    UIButton*LuBut;
    
}
-(void)setlable:(id)inder;
-(void)jian;
-(void)biaoqing;
@end
