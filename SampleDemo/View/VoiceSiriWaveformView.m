//
//  VoiceSiriWaveformView.m
//  SampleDemo
//
//  Created by liuhao on 2019/6/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import "VoiceSiriWaveformView.h"

static const CGFloat kDefaultFrequency          = 1.5f;
static const CGFloat kDefaultAmplitude          = 1.0f;
static const CGFloat kDefaultIdleAmplitude      = 0.01f;
static const CGFloat kDefaultNumberOfWaves      = 5.0f;
static const CGFloat kDefaultPhaseShift         = -0.15f;
static const CGFloat kDefaultDensity            = 5.0f;
static const CGFloat kDefaultPrimaryLineWidth   = 3.0f;
static const CGFloat kDefaultSecondaryLineWidth = 1.0f;

@interface VoiceSiriWaveformView ()

@property (nonatomic, assign) CGFloat phase;

@property (nonatomic, assign) CGFloat amplitude;

@property (nonatomic, strong) NSMutableArray *waveLayerArray;

@end

@implementation VoiceSiriWaveformView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.waveColor = [UIColor whiteColor];
    self.frequency = kDefaultFrequency;
    self.amplitude = kDefaultAmplitude;
    self.idleAmplitude = kDefaultIdleAmplitude;
    self.numberOfWaves = kDefaultNumberOfWaves;
    self.phaseShift = kDefaultPhaseShift;
    self.density = kDefaultDensity;
    self.primaryWaveLineWidth = kDefaultPrimaryLineWidth;
    self.secondaryWaveLineWidth = kDefaultSecondaryLineWidth;
}

- (void)updateWithLevel:(CGFloat)level {
    self.phase += self.phaseShift;
    self.amplitude = fmax(level, self.idleAmplitude);
    //    [self setNeedsDisplay];
    [self animationWitRect:self.frame];
}

/*
 用drawRect方法会产生一个很严重的CPU占用的问题,以上面方法相比较 drawRect占用了50%的CPU 上面的方法占用15%CPU
 */

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextClearRect(context, self.bounds);
//
//    [self.backgroundColor set];
//    CGContextFillRect(context, rect);
//
//    // 可以画出多重的窦波，有相同的相位，但幅度变大，用一个比喻的功能来增加
//    for (int i = 0; i < self.numberOfWaves; i++) {
//        CGFloat strokeLineWidth = (i == 0 ? self.primaryWaveLineWidth : self.secondaryWaveLineWidth);
//        CGContextSetLineWidth(context, strokeLineWidth);
//
//
//        CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2.0f;
//        CGFloat width = CGRectGetWidth(self.bounds);
//        CGFloat mid = width / 2.0f;
//
//        const CGFloat maxAmplitude = halfHeight - (strokeLineWidth * 2);
//
//        CGFloat progress = 1.0f - (CGFloat)i / self.numberOfWaves;
//        CGFloat normedAmplitude = (1.5f * progress - (2.0f / self.numberOfWaves)) * self.amplitude;
//
//        CGFloat multiplier = MIN(1.0, (progress / 3.0f * 2.0f) + (1.0f / 3.0f));
//        [[self.waveColor colorWithAlphaComponent:multiplier * CGColorGetAlpha(self.waveColor.CGColor)] set];
//
//        for (CGFloat x = 0; x < (width + self.density); x += self.density) {
//            //用一个比喻来衡量窦波，它在视野的中间有一个高峰。
//            CGFloat scaling = -pow(1 / mid * (x - mid), 2) + 1;
//
//            CGFloat y = scaling * maxAmplitude * normedAmplitude * sinf(2 * M_PI *(x / width) * self.frequency + self.phase) + halfHeight;
//
//            if (x == 0) {
//                CGContextMoveToPoint(context, x, y);
//            } else {
//                CGContextAddLineToPoint(context, x, y);
//            }
//        }
//        CGContextStrokePath(context);
//    }
//}

- (void)animationWitRect:(CGRect)rect {
    
    // 可以画出多重的窦波，有相同的相位，但幅度变大，用一个比喻的功能来增加
    for (int i = 0; i < self.numberOfWaves; i++) {
        CAShapeLayer *layer = self.waveLayerArray[i];
        CGFloat strokeLineWidth = (i == 0 ? self.primaryWaveLineWidth : self.secondaryWaveLineWidth);
        UIBezierPath *path = [UIBezierPath bezierPath];
        layer.lineWidth = strokeLineWidth;
        
        CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2.0f;
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat mid = width / 2.0f;
        const CGFloat maxAmplitude = halfHeight - (strokeLineWidth * 2);
        CGFloat progress = 1.0f - (CGFloat)i / self.numberOfWaves;
        CGFloat normedAmplitude = (1.5f * progress - (2.0f / self.numberOfWaves)) * self.amplitude;
        
        for (CGFloat x = 0; x < (width + self.density); x += self.density) {
            //用一个比喻来衡量窦波，它在视野的中间有一个高峰。
            CGFloat scaling = -pow(1 / mid * (x - mid), 2) + 1;
            CGFloat y = scaling * maxAmplitude * normedAmplitude * sinf(2 * M_PI *(x / width) * self.frequency + self.phase) + halfHeight;
            if (x == 0) {
                [path moveToPoint:CGPointMake(x, y)];
            } else {
                [path addLineToPoint:CGPointMake(x, y)];
            }
        }
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
    }
}

#pragma mark - lazy load
#pragma mark
- (NSMutableArray *)waveLayerArray {
    if (!_waveLayerArray) {
        _waveLayerArray = [NSMutableArray array];
        for (int i = 0; i < self.numberOfWaves; i++) {
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = self.waveColor.CGColor;//线条颜色
//            layer.backgroundColor = [UIColor colorWithHexString:@"25334e"].CGColor;
            [_waveLayerArray addObject:layer];
        }
    }
    return _waveLayerArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
