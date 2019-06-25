//
//  RecorderManager.h
//  SampleDemo
//
//  Created by liuhao on 2019/6/25.
//  Copyright © 2019 liuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecorderManager : NSObject

+ (instancetype)manager;

- (CGFloat)updateMeters;

- (void)recorderPrepareToRecord;

- (void)recorderStartRecord;

- (void)recorderStopRecord;

@end

NS_ASSUME_NONNULL_END
