//
//  XUIView.h
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSView+XUIAdditions.h"

@class XUIView;
typedef void(^XUIViewDrawRect)(XUIView *view, NSRect dirtyRect);

@interface XUIView : NSView
/*
Subview control
 */
- (void)addSubview:(NSView *)view;
- (void)insertSubview:(NSView *)view atIndex:(NSUInteger)index;
- (void)insertSubview:(NSView *)view belowSubview:(NSView *)siblingSubview;
- (void)insertSubview:(NSView *)view aboveSubview:(NSView *)siblingSubview;
- (void)bringSubviewToFront:(NSView *)view;
- (void)sendSubviewToBack:(NSView *)view;
- (void)removeFromSuperview;

- (void)didAddSubview:(NSView *)subview;
- (void)willRemoveSubview:(NSView *)subview;

/*
 Supply a block as an alternative to overriding -(void)drawRect
 */
- (void)setDrawRect:(XUIViewDrawRect)drawRect;
- (XUIViewDrawRect)drawRect;

/*
 default is nil.
 */
-(void)setBackgroundColor:(NSColor *)backgroundColor;
-(NSColor *)backgroundColor;

/*
 default is 0.
 */
-(void)setCornerRadius:(CGFloat)cornerRadius;
-(CGFloat)cornerRadius;

/*
 default is 1.
 */
- (void)setAlpha:(CGFloat)alpha;
- (CGFloat)alpha;

@end
