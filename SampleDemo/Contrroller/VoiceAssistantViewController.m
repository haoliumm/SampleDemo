//
//  VoiceAssistantViewController.m
//  SampleDemo
//
//  Created by liuhao on 2019/6/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "UIViewController+LHActive.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceButtonAnimationView.h"
#import "VoiceSiriWaveformView.h"
#import "VoiceAssistantViewController.h"

@interface VoiceAssistantViewController ()
//语音按钮
@property (nonatomic, strong) UIButton *voiceBtn;
//标题
@property (nonatomic, strong) UILabel *tipTitleLabel;
//提示
@property (nonatomic, strong) UILabel *tipMessageLabel;

@property (nonatomic,strong) UIButton *closeBtn;
//按钮背景动画
@property (nonatomic, strong) VoiceButtonAnimationView *buttonAnimationView;
//波浪线动画
@property (nonatomic, strong) VoiceSiriWaveformView *waveformView;

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) CADisplayLink *displaylink;
//弹窗标识
@property (nonatomic, assign) BOOL alerting;

@end

@implementation VoiceAssistantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.alerting = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.recorder prepareToRecord];
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

- (void)setUpUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"7d6342"];
//    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.buttonAnimationView];
    [self.view addSubview:self.voiceBtn];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.waveformView];
    [self.view addSubview:self.tipTitleLabel];
    [self.view addSubview:self.tipMessageLabel];
}

#pragma mark - Method
#pragma mark

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.buttonAnimationView.layer.frame,point) ) {
        return;
    }
    if (self.voiceBtn.state == UIControlStateHighlighted) {
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)voiceBtnTouchDown {
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.buttonAnimationView addLayerAnimations];
    [UIView animateWithDuration:1.0 animations:^{
        self.waveformView.alpha = 1.0;
    }];
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder record];
}

- (void)voiceBtnTouchUp {
    [self.recorder stop];
    [self.buttonAnimationView removeLayerAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        self.waveformView.alpha = 0.0;
    }];
    
    [self.displaylink invalidate];
    self.displaylink = nil;
}
//根据声音刷新波浪纹
- (void)updateMeters {
    CGFloat normalizedValue;
    [self.recorder updateMeters];
    normalizedValue = [self _normalizedPowerLevelFromDecibels:[self.recorder averagePowerForChannel:1]];
    //    NSLog(@"0 >>%lf  1 >>%lf",[self.recorder averagePowerForChannel:0],[self.recorder averagePowerForChannel:1]);
    [self.waveformView updateWithLevel:normalizedValue];
}

- (CGFloat)_normalizedPowerLevelFromDecibels:(CGFloat)decibels {
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy load
#pragma mark

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x - 40, self.view.frame.size.height - 100, 80, 80)];
        _voiceBtn.backgroundColor = [UIColor redColor];
        _voiceBtn.backgroundColor = [UIColor colorWithHexString:@"9a7950"];
        _voiceBtn.layer.cornerRadius = 39;
        _voiceBtn.layer.borderColor = [UIColor colorWithHexString:@"ccb89e"].CGColor;
        _voiceBtn.layer.borderWidth = 3;
        _voiceBtn.clipsToBounds = YES;
        [_voiceBtn setImage:[UIImage imageNamed:@"voice_actived"] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(voiceBtnTouchDown) forControlEvents:UIControlEventTouchDown];
        [_voiceBtn addTarget:self action:@selector(voiceBtnTouchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _voiceBtn;
}

- (UILabel *)tipTitleLabel {
    if (!_tipTitleLabel) {
        _tipTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 200, 100, 400, 50)];
        _tipTitleLabel.text = @"您可以这么说:";
        _tipTitleLabel.textAlignment = NSTextAlignmentCenter;
        _tipTitleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _tipTitleLabel.font = [UIFont systemFontOfSize:20];
    }
    return _tipTitleLabel;
}

- (UILabel *)tipMessageLabel {
    if (!_tipMessageLabel) {
        _tipMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.tipTitleLabel.center.x - 65, 170, 400, 500)];
        _tipMessageLabel.text = @"开启<智能消音器>\n关闭<客厅插座>\n打开<玄关开关>\n......";
        _tipMessageLabel.numberOfLines = 0;
        _tipMessageLabel.textAlignment = NSTextAlignmentCenter;
        _tipMessageLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _tipMessageLabel.font = [UIFont systemFontOfSize:16];
        //行距设置
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_tipMessageLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        //行距的大小
        [paragraphStyle setLineSpacing:10];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _tipMessageLabel.text.length)];
        _tipMessageLabel.attributedText = attributedString;
        [_tipMessageLabel sizeToFit];
    }
    return _tipMessageLabel;
}

- (VoiceButtonAnimationView *)buttonAnimationView {
    if (!_buttonAnimationView) {
        _buttonAnimationView = [[VoiceButtonAnimationView alloc]initWithFrame:CGRectMake(self.view.center.x -  200, self.view.frame.size.height - 260, 400, 400)];
        _buttonAnimationView.voiceBtnWH = Scale(78);
        _buttonAnimationView.userInteractionEnabled = NO;

    }
    return _buttonAnimationView;
}

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

- (VoiceSiriWaveformView *)waveformView {
    if (!_waveformView) {
        _waveformView = [[VoiceSiriWaveformView alloc]initWithFrame:CGRectMake(0, self.view.center.y - 200, self.view.bounds.size.width, 400)];
        _waveformView.backgroundColor = [UIColor clearColor];
        _waveformView.alpha = 0;
        [_waveformView setWaveColor:[UIColor colorWithHexString:@"ffffff" alpha:0.1]];
        [_waveformView setPrimaryWaveLineWidth:3.0f];
        [_waveformView setSecondaryWaveLineWidth:1.0];
    }
    return _waveformView;
}

- (CADisplayLink *)displaylink {
    if (!_displaylink) {
        _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    }
    return _displaylink;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, 20, 80, 80)];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
