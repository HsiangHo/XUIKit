//
//  NSView+XUIAdditions.h
//  XUIKit
//
//  Created by Jovi on 6/14/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^XUIViewLayoutSubview)(NSView *view);

@interface NSView (XUIAdditions)

/*
 Default is YES. if set to NO, user events (touch, keys) are ignored and removed from the event queue.
 */
@property (nonatomic,getter=isUserInteractionEnabled) BOOL userInteractionEnabled;

/*
 Default is 0
 */
@property (nonatomic) NSInteger tag;

/*
 Layout Subviews
 */
- (void)setNeedsLayout;
- (void)layoutSubviews;

/*
 Recursive -setNeedsDisplay
 */
- (void)setEverythingNeedsDisplay;

/*
 return the frame on screen.
 */
@property (nonatomic, readonly) NSRect frameOnScreen;

/*
 @returns whether mouse event occured within the bounds of reciever
 */
- (BOOL)eventInside:(NSEvent *)event;

/**
 Make this view the first responder. Returns NO if it fails.
 */
- (BOOL)makeFirstResponder;

/*
 Subview control
 */
- (void)insertSubview:(NSView *)view atIndex:(NSUInteger)index;
- (void)insertSubview:(NSView *)view belowSubview:(NSView *)siblingSubview;
- (void)insertSubview:(NSView *)view aboveSubview:(NSView *)siblingSubview;
- (void)bringSubviewToFront:(NSView *)view;
- (void)sendSubviewToBack:(NSView *)view;

/*
 default is nil.
 */
-(void)setBackgroundColor:(NSColor *)backgroundColor;
-(NSColor *)backgroundColor;

/*
 default is nil.
 */
-(void)setBorderColor:(NSColor *)borderColor;
-(NSColor *)borderColor;

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

/*
 default is nil.
 */
-(void)setLayoutSubviewBlock:(XUIViewLayoutSubview)block;
-(XUIViewLayoutSubview)layoutSubviewBlock;

@end
