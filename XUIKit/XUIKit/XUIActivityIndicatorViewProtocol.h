//
//  XUIActivityIndicatorViewProtocol.h
//  XUIKit
//
//  Created by Jovi on 7/10/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XUIActivityIndicatorViewProtocol <NSObject>

-(void)setColor:(NSColor *)color;
-(NSColor *)color;
-(void)setDurationTime:(CGFloat)durationTime;
-(CGFloat)durationTime;

-(instancetype)initWithLayer:(CALayer *)layer withColor:(nonnull NSColor *)color withDurationTime:(CGFloat)durationTime;

@end

NS_ASSUME_NONNULL_END
