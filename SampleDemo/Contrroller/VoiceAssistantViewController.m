//
//  VoiceAssistantViewController.m
//  SampleDemo
//
//  Created by liuhao on 2019/6/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

//#import "UIViewController+LHActive.h"
//#import <AVFoundation/AVFoundation.h>
#import "VoiceButtonAnimationView.h"
#import "VoiceSiriWaveformView.h"
#import "VoiceAssistantViewController.h"
#import "RecorderManager.h"

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

@property (nonatomic, strong) CADisplayLink *displaylink;

@end

@implementation VoiceAssistantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self layoutSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[RecorderManager manager] recorderPrepareToRecord];
}

- (void)setUpUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"7d6342"];
    [self.view addSubview:self.buttonAnimationView];
    [self.view addSubview:self.voiceBtn];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.waveformView];
    [self.view addSubview:self.tipTitleLabel];
    [self.view addSubview:self.tipMessageLabel];
}

- (void)layoutSubViews {
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(Scale(-5));
        make.size.mas_equalTo(CGSizeMake(Scale(78), Scale(78)));
    }];
    
    [self.buttonAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.voiceBtn);
        make.size.mas_equalTo(CGSizeMake(Scale(250), Scale(250)));
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(Scale(15));
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(Scale(-15));
        make.size.mas_equalTo(CGSizeMake(Scale(50), Scale(50)));
    }];
    
    [self.tipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(Scale(94));
    }];
    
    [self.tipMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.tipTitleLabel.mas_bottom);
        make.height.equalTo(@150);
    }];
    
    [self.waveformView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.height.equalTo(@Scale(150));
        make.width.equalTo(@(ScreenWidth));
    }];
}


#pragma mark - Method
#pragma mark

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.buttonAnimationView.layer.frame,point) ) {
        return;
    }
    if (self.voiceBtn.state == UIControlStateHighlighted) {
        return;
    }
}

- (void)voiceBtnTouchDown {
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.buttonAnimationView addLayerAnimations];
    [UIView animateWithDuration:1.0 animations:^{
        self.waveformView.alpha = 1.0;
    }];
    [[RecorderManager manager] recorderStartRecord];
}

- (void)voiceBtnTouchUp {
    [[[RecorderManager alloc] init] recorderStopRecord];
    [self.buttonAnimationView removeLayerAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        self.waveformView.alpha = 0.0;
    }];
    [self.displaylink invalidate];
    self.displaylink = nil;
}
////根据声音刷新波浪纹
- (void)updateMeters {
    [self.waveformView updateWithLevel:[[RecorderManager manager] updateMeters]];
}
- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy load
#pragma mark

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc]init];
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
        _tipTitleLabel = [[UILabel alloc]init];
        _tipTitleLabel.text = @"您可以这么说:";
        _tipTitleLabel.textAlignment = NSTextAlignmentCenter;
        _tipTitleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _tipTitleLabel.font = [UIFont systemFontOfSize:20];
    }
    return _tipTitleLabel;
}

- (UILabel *)tipMessageLabel {
    if (!_tipMessageLabel) {
        _tipMessageLabel = [[UILabel alloc]init];
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
        _buttonAnimationView = [[VoiceButtonAnimationView alloc]init];
        _buttonAnimationView.voiceBtnWH = Scale(78);
        _buttonAnimationView.userInteractionEnabled = NO;

    }
    return _buttonAnimationView;
}

- (VoiceSiriWaveformView *)waveformView {
    if (!_waveformView) {
        _waveformView = [[VoiceSiriWaveformView alloc]init];
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
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        _closeBtn.backgroundColor = [UIColor clearColor];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
