//
//  VoiceButtonAnimationView.m
//  SampleDemo
//
//  Created by liuhao on 2019/6/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "VoiceButtonAnimationView.h"

#define lineWidth Scale(25)
#define animationDuration 0.5

@interface VoiceButtonAnimationView ()

@property (nonatomic, strong) NSMutableArray *groupAnnimationArray;

@property (nonatomic, strong) NSMutableArray *startTimeArray;

@end

@implementation VoiceButtonAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        self.layerArray = [NSMutableArray array];
        self.groupAnnimationArray = [NSMutableArray array];
        self.startTimeArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Method
#pragma mark

- (void)setUpUI {
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    CAShapeLayer *border = [CAShapeLayer layer];
    //    border.strokeColor = [UIColor colorWithHexString:@"ffffff" alpha:0.1].CGColor;
    //    border.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width/2].CGPath;
    //    border.fillColor = [UIColor clearColor].CGColor;
    //    border.frame = self.bounds;
    //    border.lineWidth = 1;
    //    border.lineCap = @"square";
    //    [self.layer addSublayer:border];
    //循环创建动画效果
    for (int i = 4; i>= 1; i --) {
        CAShapeLayer *border = [CAShapeLayer layer];
        //        border.fillColor = NLClear.CGColor;
        border.speed = 0.0;
        border.timeOffset = 0.0;
        border.contentsScale = [UIScreen mainScreen].scale;
        border.backgroundColor = [UIColor colorWithHexString:@"2a2016"].CGColor;
        border.opacity = 1.0 - (i * 0.2);
        border.cornerRadius = (self.voiceBtnWH + (2 * i - 2) * lineWidth)/2;
        border.frame = CGRectMake(self.bounds.size.width/2 - (self.voiceBtnWH + (2 * i - 2) * lineWidth)/2, self.bounds.size.width/2 - (self.voiceBtnWH + (2 * i - 2) * lineWidth)/2, self.voiceBtnWH + (2 * i - 2) * lineWidth, self.voiceBtnWH + (2 * i - 2) * lineWidth);
        [self.layer addSublayer:border];
        [self.layerArray addObject:border];
        //b波纹k扩散形变
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:(border.bounds.size.width + lineWidth * 2)/border.bounds.size.width];
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.repeatCount = MAXFLOAT;
        scaleAnimation.duration = animationDuration;
        //波纹扩散透明度渐变
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = [NSNumber numberWithFloat:border.opacity];
        opacityAnimation.toValue = [NSNumber numberWithFloat:border.opacity - 0.2];
        opacityAnimation.fillMode = kCAFillModeForwards;
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.repeatCount = MAXFLOAT;
        opacityAnimation.duration = animationDuration;
        //组合形变和透明度
        CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
        groupAnnimation.duration = animationDuration;
        groupAnnimation.animations = @[scaleAnimation, opacityAnimation];
        groupAnnimation.repeatCount = MAXFLOAT;
        [self.groupAnnimationArray addObject:groupAnnimation];
        [border addAnimation:groupAnnimation forKey:@"groupAnnimation"];
    }
}

- (void)addLayerAnimations {
    if (self.layerArray.count == 0) {
        return;
    }
    for (int i = 0; i < 4; i++) {
        CAShapeLayer *border = self.layerArray[i];
        CFTimeInterval pausedTime = [border timeOffset];
        border.speed = 1.0;
        border.timeOffset = 0.0;
        border.beginTime = 0.0;
        CFTimeInterval timeSincePause = [border convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        border.beginTime = timeSincePause;
    }
}

- (void)removeLayerAnimations {
    for (int i = 0; i < 4; i++) {
        CAShapeLayer *border = self.layerArray[i];
        CFTimeInterval pausedTime = [border convertTime:CACurrentMediaTime() fromLayer:nil];
        border.speed = 0;
        border.timeOffset = pausedTime ;
    }
}

@end
