//
//  ViewController.m
//  SampleDemo
//
//  Created by liuhao on 2019/6/24.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "UIColor+Hex.h"
#import "ViewController.h"
#import "VoiceAssistantViewController.h"
#import "TestingAnimationViewController.h"

@interface ViewController ()
//语音按钮
@property (nonatomic, strong) UIButton *voiceVCBtn;
//检测按钮
@property (nonatomic, strong) UIButton *testingVCBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

#pragma mark - Method
#pragma mark

- (void)setUpUI {
    [self.view addSubview:self.voiceVCBtn];
    [self.view addSubview:self.testingVCBtn];
}

- (void)voiceVCBtnClick {
    VoiceAssistantViewController *voiceVC = [[VoiceAssistantViewController alloc] init];
    [self presentViewController:voiceVC animated:YES completion:nil];
}

-(void)testingVCBtnClick {
    TestingAnimationViewController *testingVC = [[TestingAnimationViewController alloc] init];
    [self presentViewController:testingVC animated:YES completion:nil];
}

#pragma mark - lazy load
#pragma mark

- (UIButton *)voiceVCBtn {
    if (!_voiceVCBtn) {
        _voiceVCBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x - 100, self.view.center.y - 200, 200, 50)];
        _voiceVCBtn.backgroundColor = [UIColor colorWithHexString:@"2e4324"];
        [_voiceVCBtn setTitle:@"语音指令" forState:UIControlStateNormal];
        [_voiceVCBtn addTarget:self action:@selector(voiceVCBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceVCBtn;
}

- (UIButton *)testingVCBtn {
    if (!_testingVCBtn) {
        _testingVCBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x - 100, self.view.center.y + 200, 200, 50)];
        _testingVCBtn.backgroundColor = [UIColor colorWithHexString:@"2e9994"];
        [_testingVCBtn setTitle:@"检测动画" forState:UIControlStateNormal];
        [_testingVCBtn addTarget:self action:@selector(testingVCBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testingVCBtn;
}

@end
