//
//  XUIProgressView.h
//  XUIKit
//
//  Created by Jovi on 7/4/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XUIView.h"

@interface XUIProgressView : XUIView

@property(nonatomic) float progress;                        // 0.0 .. 1.0, default is 0.0. values outside are pinned.
@property(nonatomic, strong, nullable) NSColor* progressTintColor;
@property(nonatomic, strong, nullable) NSColor* trackTintColor;
@property(nonatomic, strong, nullable) NSImage* progressImage;
@property(nonatomic, strong, nullable) NSImage* trackImage;
@property(nonatomic, assign) NSEdgeInsets progressEdgeInsets;
@property(nonatomic, assign) NSEdgeInsets trackEdgeInsets;
@property(nonatomic, assign) CGFloat progressCornerRadius;
@property(nonatomic, assign) CGFloat trackCornerRadius;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
