//
//  XUIActivityIndicatorViewProtocol.h
//  XUIKit
//
//  Created by Jovi on 7/10/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol XUIActivityIndicatorViewProtocol <NSObject>

@property (nonatomic, readwrite) CGFloat    durationTime;
@property (nonnull, readwrite, nonatomic, strong)  NSColor *color;

-(instancetype)initWithLayer:(CALayer *)layer withColor:(nonnull NSColor *)color withDurationTime:(CGFloat)durationTime;

@end
