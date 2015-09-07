//
//  RecordEditView.h
//  AFSoundManager-Demo
//
//  Created by 童小波 on 15/5/29.
//  Copyright (c) 2015年 AlvaroFranco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RecordEditViewModel) {
    RecordEditViewModelNone,
    RecordEditViewModelText,
    RecordEditViewModelSound
};

@protocol RecordEditViewDelegate;

@interface RecordEditView : UIView

@property (assign, nonatomic) id<RecordEditViewDelegate> delegate;
@property (strong, nonatomic) UIScrollView *attachScrollView;
@property (assign, nonatomic) CGFloat difHeight;
@property (assign, nonatomic) CGFloat currentHeight;
@property (strong, nonatomic) NSString *filePath;
@property (assign, nonatomic) RecordEditViewModel editViewModel;
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) NSInteger recordDuration;
@property (assign, nonatomic) BOOL netAudio;

- (void)setRecordButtonAvaliable:(BOOL)avaliable;
- (void)stopPlay;

@end

@protocol RecordEditViewDelegate <NSObject>

- (void)editViewSizeDidChanged:(RecordEditView *)view;
- (void)editViewAudioData:(RecordEditView *)view audioData:(void(^)(NSData *data))audioData;

@end