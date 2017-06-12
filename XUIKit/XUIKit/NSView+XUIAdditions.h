//
//  NSView+XUIAdditions.h
//  XUIKit
//
//  Created by Jovi on 6/12/17.
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
 Supply a block as an alternative to overriding -layoutSubviews
 */
@property (nonatomic, copy) XUIViewLayoutSubview layoutSubview;

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

@end
