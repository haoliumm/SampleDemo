//
//  RecorderManager.m
//  SampleDemo
//
//  Created by liuhao on 2019/6/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "RecorderManager.h"
#import "UIViewController+LHActive.h"
#import <AVFoundation/AVFoundation.h>

@interface RecorderManager ()

@property (nonatomic, strong) AVAudioRecorder *recorder;
//弹窗标识
@property (nonatomic, assign) BOOL alerting;

@end

@implementation RecorderManager

+ (instancetype)manager {
    
    static RecorderManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] _init];
    });
    return _manager;
}

- (instancetype)_init {
    if (self = [super init]) {
        [self.recorder prepareToRecord];
    }
    return self;
}

#pragma mark -- Method
#pragma mark

- (void)recorderPrepareToRecord {
    self.alerting = NO;
//    [self.recorder prepareToRecord];
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                // 麦克风可用
            }
            else {
                //麦克风不可用
                [self leadUserAuthorization];
            }
        }];
    }
}
//开始录音
- (void)recorderStartRecord {
//    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder record];
}

- (void)recorderStopRecord {
    [self.recorder stop];
}

- (void)leadUserAuthorization {
    if (self.alerting) {
        return;
    }
    self.alerting = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开麦克风失败" message:@"打开语音权限\n 使用语音发送指令" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        self.alerting = NO;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.alerting = NO;
    }]];
    UIViewController *active = [UIViewController activeViewController];
    [active presentViewController:alert animated:YES completion:nil];
}

//根据声音刷新波浪纹
- (CGFloat)updateMeters {
    CGFloat normalizedValue;
    [self.recorder updateMeters];
    normalizedValue = [self normalizedPowerLevelFromDecibels:[self.recorder averagePowerForChannel:1]];
    return normalizedValue;
}

- (CGFloat)normalizedPowerLevelFromDecibels:(CGFloat)decibels {
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}


#pragma mark -- lazy load
#pragma mark

- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        NSDictionary *settings = @{AVSampleRateKey:          [NSNumber numberWithFloat: 44100.0],
                                   AVFormatIDKey:            [NSNumber numberWithInt: kAudioFormatAppleLossless],
                                   AVNumberOfChannelsKey:    [NSNumber numberWithInt: 2],
                                   AVEncoderAudioQualityKey: [NSNumber numberWithInt: AVAudioQualityMin]};
        NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    return _recorder;
}

@end
