//
//  VoiceSiriWaveformView.h
//  SampleDemo
//
//  Created by liuhao on 2019/6/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceSiriWaveformView : UIView

/*
 * 告诉波形以给定的水平(归一化值)重新绘制自身
 */
- (void)updateWithLevel:(CGFloat)level;

/*
 * 波的总数
 * Default: 5
 */
@property (nonatomic, assign) NSUInteger numberOfWaves;

/*
 * 在绘制波浪时使用颜色
 * Default: white
 */
@property (nonatomic, strong) IBInspectable UIColor *waveColor;

/*
 * 线宽用于突出的波
 * Default: 3.0f
 */
@property (nonatomic, assign)  IBInspectable CGFloat primaryWaveLineWidth;

/*
 * Line width used for all secondary waves
 * Default: 1.0f
 */
@property (nonatomic, assign) IBInspectable CGFloat secondaryWaveLineWidth;

/*
 * 当传入的振幅接近于零的时候使用的振幅。
 * 设置一个值大于0可以提供更生动的可视化。
 * Default: 0.01
 */
@property (nonatomic, assign) IBInspectable CGFloat idleAmplitude;

/*
 * sinus波的频率。值越高，你的窦波峰就越高。
 * Default: 1.5
 */
@property (nonatomic, assign) IBInspectable CGFloat frequency;

/*
 * 当前的振幅
 */
@property (nonatomic, assign, readonly) IBInspectable CGFloat amplitude;

/*
 * 这些线是逐步加入的，你画得越密集，使用的CPU功率就越大。
 * Default: 5
 */
@property (nonatomic, assign) IBInspectable CGFloat density;

/*
 * 将应用于每个层次设置的相移
 * 更改此更改以修改动画速度或方向
 * Default: -0.15
 */
@property (nonatomic, assign) IBInspectable CGFloat phaseShift;


@end

NS_ASSUME_NONNULL_END
