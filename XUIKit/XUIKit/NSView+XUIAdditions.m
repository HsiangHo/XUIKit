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

@implementation NSView (XUIAdditions)

+(void)load{
    Class cls = [NSView class];
    XUISwizzleMethod(cls, '-', @selector(xui_addSubview:),@selector(addSubview:));
    XUISwizzleMethod(cls, '-', @selector(xui_removeFromSuperview),@selector(removeFromSuperview));
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    XUI_SET_PROPERTY([NSNumber numberWithBool:userInteractionEnabled], kUserInteractionEnabled);
}

-(BOOL)isUserInteractionEnabled{
    return [(NSNumber *)XUI_GET_PROPERTY(kUserInteractionEnabled) boolValue];
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
    [self setWantsLayer:YES];
    [self.layer setBackgroundColor:backgroundColor.CGColor];
    [self setNeedsDisplay:YES];
}

-(NSColor *)backgroundColor{
    return [NSColor colorWithCGColor:self.layer.backgroundColor];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self setWantsLayer:YES];
    [self.layer setCornerRadius:cornerRadius];
    [self setNeedsDisplay:YES];
}

-(CGFloat)cornerRadius{
    return [self.layer cornerRadius];
}

- (void)setAlpha:(CGFloat)alpha{
    [self setWantsLayer:YES];
    [[self layer] setOpacity:alpha];
    [self setNeedsDisplay:YES];
}

- (CGFloat)alpha{
    return [[self layer] opacity];
}

#pragma mark - Private Functions

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
    NSRect frameRelativeToWindow = [self convertRect:self.frame toView:nil];
    NSRect frameRelativeToScreen = [self.window convertRectToScreen:frameRelativeToWindow];
    return frameRelativeToScreen;
}

#pragma mark - Swizzle Functions

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

@end
