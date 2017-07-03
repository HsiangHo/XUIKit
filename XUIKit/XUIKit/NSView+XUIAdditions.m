//
//  NSView+XUIAdditions.m
//  XUIKit
//
//  Created by Jovi on 6/14/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "NSView+XUIAdditions.h"
#import "XUIProperty.h"
#import "XUIResponder.h"
#import "XUIMethodsHelper.h"

#define     kUserInteractionEnabled     @"userInteractionEnabled"   //NSNumber *
#define     kTag                        @"tag"                      //NSNumber *
#define     kNeedsLayout                @"needsLayout"              //NSNumber *
#define     kLayoutSubview              @"layoutSubview"            //id
#define     kTrackingArea               @"trackingArea"             //NSTrackingArea *

#define     INIT_METHOD_FAMILY          __attribute__((objc_method_family(init)))

@implementation NSView (XUIAdditions)

+(void)load{
    Class cls = [NSView class];
    XUISwizzleMethod(cls, '-', @selector(xui_addSubview:),@selector(addSubview:));
    XUISwizzleMethod(cls, '-', @selector(xui_removeFromSuperview),@selector(removeFromSuperview));
    XUISwizzleMethod(cls, '-', @selector(xui_initWithFrame:),@selector(initWithFrame:));
    XUISwizzleMethod(cls, '-', @selector(xui_init),@selector(init));
    XUISwizzleMethod(cls, '-', @selector(xui_updateTrackingAreas),@selector(updateTrackingAreas));
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    XUI_SET_PROPERTY([NSNumber numberWithBool:!userInteractionEnabled], kUserInteractionEnabled);
}

-(BOOL)isUserInteractionEnabled{
    return ![(NSNumber *)XUI_GET_PROPERTY(kUserInteractionEnabled) boolValue];
}

-(void)setTag:(NSInteger)tag{
    XUI_SET_PROPERTY([NSNumber numberWithInteger:tag], kTag);
}

-(NSInteger)tag{
    return [(NSNumber *)XUI_GET_PROPERTY(kTag) integerValue];
}

- (void)setNeedsLayout{
    XUI_SET_PROPERTY([NSNumber numberWithBool:YES], kNeedsLayout);
}

- (void)layoutSubviews{
    XUIViewLayoutSubview block = XUI_GET_PROPERTY(kLayoutSubview);
    if (nil != block) {
        block(self);
    }
}

-(void)setLayoutSubviewBlock:(XUIViewLayoutSubview)block{
    XUI_SET_PROPERTY(block, kLayoutSubview);
}
-(XUIViewLayoutSubview)layoutSubviewBlock{
    return [XUI_GET_PROPERTY(kLayoutSubview) copy];
}

- (void)setEverythingNeedsDisplay{
    [self setNeedsDisplay:YES];
    if ([self.superview respondsToSelector:@selector(setEverythingNeedsDisplay)]) {
        [self.superview performSelector:@selector(setEverythingNeedsDisplay)];
    }
}

-(NSRect)frameOnScreen{
    return [self __frameOnScreen];
}

- (BOOL)eventInside:(NSEvent *)event{
    return NSPointInRect([NSEvent mouseLocation], [self __frameOnScreen]);
}

- (BOOL)makeFirstResponder{
    return [self.window makeFirstResponder: [self defaultFirstResponder]];
}

- (void)insertSubview:(NSView *)view atIndex:(NSUInteger)index{
    NSArray *arraySubviews = [self subviews];
    NSUInteger nCount = [arraySubviews count];
    if (0 == nCount){
        [self addSubview:view];
    }else{
        index = (index >= nCount) ? nCount - 1 : index;
        NSView *relativeView = [arraySubviews objectAtIndex:index];
        [self addSubview:view positioned:NSWindowAbove relativeTo:relativeView];
        [self.layer insertSublayer:view.layer atIndex:(unsigned int)index + 1];
    }
}

- (void)insertSubview:(NSView *)view belowSubview:(NSView *)siblingSubview{
    NSUInteger siblingIndex = [self.subviews indexOfObject:siblingSubview];
    if (siblingIndex == NSNotFound)
        return;
    [self addSubview:view positioned:NSWindowBelow relativeTo:siblingSubview];
    [self.layer insertSublayer:view.layer below:siblingSubview.layer];
}

- (void)insertSubview:(NSView *)view aboveSubview:(NSView *)siblingSubview{
    NSUInteger siblingIndex = [self.subviews indexOfObject:siblingSubview];
    if (siblingIndex == NSNotFound)
        return;
    [self addSubview:view positioned:NSWindowAbove relativeTo:siblingSubview];
    [self.layer insertSublayer:view.layer above:siblingSubview.layer];
}

- (void)bringSubviewToFront:(NSView *)view{
    if([self.subviews containsObject:view]) {
        [view removeFromSuperview];
        NSView *top = [self __topSubview];
        if(top)
            [self insertSubview:view aboveSubview:top];
        else
            [self addSubview:view];
    }
}

- (void)sendSubviewToBack:(NSView *)view{
    if([self.subviews containsObject:view]) {
        [view removeFromSuperview];
        NSView *bottom = [self __bottomSubview];
        if(bottom)
            [self insertSubview:view belowSubview:bottom];
        else
            [self addSubview:view];
    }
}

-(void)setBackgroundColor:(NSColor *)backgroundColor{
    [self.layer setBackgroundColor:backgroundColor.CGColor];
    [self setNeedsDisplay:YES];
}

-(NSColor *)backgroundColor{
    return [NSColor colorWithCGColor:self.layer.backgroundColor];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
    [self setNeedsDisplay:YES];
}

-(CGFloat)cornerRadius{
    return [self.layer cornerRadius];
}

- (void)setAlpha:(CGFloat)alpha{
    [[self layer] setOpacity:alpha];
    [self setNeedsDisplay:YES];
}

- (CGFloat)alpha{
    return [[self layer] opacity];
}

#pragma mark - Private Functions

- (void)__initializeNSView_XUIAdditions{
    [self setWantsLayer:YES];
    [self setUserInteractionEnabled:YES];
}

- (NSView *)__topSubview
{
    return [self.subviews lastObject];
}

- (NSView *)__bottomSubview
{
    NSArray *s = self.subviews;
    if([s count] > 0)
        return [self.subviews objectAtIndex:0];
    return nil;
}

-(NSRect)__frameOnScreen{
    NSRect frameRelativeToScreen = [self.window convertRectToScreen:self.frame];
    return frameRelativeToScreen;
}

-(NSTrackingArea *)__trackingArea{
    return XUI_GET_PROPERTY(kTrackingArea);
}

-(void)__setTrackingArea:(NSTrackingArea *)ta{
    XUI_SET_PROPERTY(ta, kTrackingArea);
}

#pragma mark - Swizzle Functions

-(instancetype)xui_init INIT_METHOD_FAMILY{
    if (self = [self xui_init]){
        [self __initializeNSView_XUIAdditions];
    }
    return self;
}

-(instancetype)xui_initWithFrame:(NSRect)frameRect INIT_METHOD_FAMILY{
    if (self = [self xui_initWithFrame:frameRect]){
        [self __initializeNSView_XUIAdditions];
    }
    return self;
}

-(void)xui_addSubview:(NSView *)view{
    [self xui_addSubview:view];
    [self.superview didAddSubview:view];
    [self.layer addSublayer:view.layer];
}

-(void)xui_removeFromSuperview{
    [self.layer removeFromSuperlayer];
    [self.superview willRemoveSubview:self];
    [self xui_removeFromSuperview];
}

- (void)xui_updateTrackingAreas{
    [self xui_updateTrackingAreas];
    NSTrackingArea *ta = [self __trackingArea];
    if(nil != ta) {
        [self removeTrackingArea:ta];
    }
    
    ta = [[NSTrackingArea alloc] initWithRect:[self bounds] options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveAlways owner:self userInfo:nil];
    [self __setTrackingArea:ta];
    [self addTrackingArea:ta];
}

#pragma mark - Redirect function
//Because of the NSControl swizzle, it will redirect mouseUp with the SEL, we can add the SEL to redirect to the right action
- (void)xui_mouseDown:(NSEvent *)event{
    [self mouseDown:event];
}

- (void)xui_mouseUp:(NSEvent *)event{
    [self mouseUp:event];
}

-(void)xui_mouseMoved:(NSEvent *)event{
    [self mouseMoved:event];
}

- (void)xui_mouseEntered:(NSEvent *)event{
    [self mouseEntered:event];
}

- (void)xui_mouseExited:(NSEvent *)event{
    [self mouseExited:event];
}
@end
