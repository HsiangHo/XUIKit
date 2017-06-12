//
//  XUIView.h
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XUIView;
typedef void(^XUIViewDrawRect)(XUIView *view, NSRect dirtyRect);

@interface XUIView : NSView
/*
Subview control
 */
- (void)insertSubview:(XUIView *)view atIndex:(NSInteger)index;
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
 default is nil.  Setting this with a color with <1.0 alpha will also set opaque=NO
 */
@property (nonatomic,copy) NSColor *backgroundColor;

/*
 default is 0.
 */
@property (nonatomic,assign) CGFloat cornerRadius;

@end
