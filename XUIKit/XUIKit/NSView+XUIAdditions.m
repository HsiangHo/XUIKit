//
//  NSView+XUIAdditions.m
//  XUIKit
//
//  Created by Jovi on 6/12/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "NSView+XUIAdditions.h"
#import "XUIProperty.h"
#import "XUIResponder.h"

#define     kUserInteractionEnabled     @"userInteractionEnabled"   //NSNumber *
#define     kTag                        @"tag"                      //NSNumber *
#define     kNeedsLayout                @"needsLayout"              //NSNumber *
#define     kLayoutSubview              @"layoutSubview"            //id

@implementation NSView (XUIAdditions)

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

#pragma mark - private functions

-(NSRect)__frameOnScreen{
    NSRect frameRelativeToWindow = [self convertRect:self.frame toView:nil];
    NSRect frameRelativeToScreen = [self.window convertRectToScreen:frameRelativeToWindow];
    return frameRelativeToScreen;
}

@end
