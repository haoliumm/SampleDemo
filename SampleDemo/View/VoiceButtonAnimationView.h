//
//  VoiceButtonAnimationView.h
//  SampleDemo
//
//  Created by liuhao on 2019/6/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceButtonAnimationView : UIView

@property (nonatomic, assign) NSInteger voiceBtnWH;

@property (nonatomic, strong) NSMutableArray *layerArray;

- (void)addLayerAnimations;

- (void)removeLayerAnimations;

@end

NS_ASSUME_NONNULL_END
