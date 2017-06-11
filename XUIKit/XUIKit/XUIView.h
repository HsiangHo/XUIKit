//
//  XUIView.h
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NSView XUIView;
typedef void(^XUIViewDrawRect)(XUIView *view, NSRect dirtyRect);
typedef void(^XUIViewLayoutSubview)(XUIView *view);

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
Subview control
 */
- (void)removeFromSuperview;
- (void)insertSubview:(XUIView *)view atIndex:(NSInteger)index;

- (void)addSubview:(XUIView *)view;
- (void)insertSubview:(XUIView *)view belowSubview:(XUIView *)siblingSubview;
- (void)insertSubview:(XUIView *)view aboveSubview:(XUIView *)siblingSubview;

- (void)bringSubviewToFront:(XUIView *)view;
- (void)sendSubviewToBack:(XUIView *)view;

- (void)didAddSubview:(XUIView *)subview;
- (void)willRemoveSubview:(XUIView *)subview;

/*
 Supply a block as an alternative to overriding -(void)drawRect
 */
@property (nonatomic, copy) XUIViewDrawRect drawRect;

/*
 Layout Subviews
 */
- (void)setNeedsLayout;
- (void)layoutSubviews;

/*
 Supply a block as an alternative to overriding -layoutSubviews
 */
@property (nonatomic, copy) XUIViewLayoutSubview layoutSubview;

/*
 Recursive -setNeedsDisplay
 */
- (void)setEverythingNeedsDisplay;

/*
 default is nil.  Setting this with a color with <1.0 alpha will also set opaque=NO
 */
@property (nonatomic,copy) NSColor *backgroundColor;

/*
 default is 0.
 */
@property (nonatomic,assign) CGFloat cornerRadius;

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

@end
