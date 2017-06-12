//
//  NSView+XUIAdditions.m
//  XUIKit
//
//  Created by Jovi on 6/12/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "NSView+XUIAdditions.h"
#import "XUIProperty.h"

#define     kUserInteractionEnabled     @"userInteractionEnabled"   //NSNumber *
#define     kTag                        @"tag"                      //NSNumber *

@implementation NSView (XUIAdditions)

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    XUI_SET_PROPERTY(self, [NSNumber numberWithBool:userInteractionEnabled], kUserInteractionEnabled);
}

-(BOOL)isUserInteractionEnabled{
    return [(NSNumber *)XUI_GET_PROPERTY(self,kUserInteractionEnabled) boolValue];
}

-(void)setTag:(NSInteger)tag{
    XUI_SET_PROPERTY(self, [NSNumber numberWithInteger:tag], kTag);
}

-(NSInteger)tag{
    return [(NSNumber *)XUI_GET_PROPERTY(self,kTag) integerValue];
}

- (void)setNeedsLayout{
    
}
- (void)layoutSubviews{
    
}

-(XUIViewLayoutSubview)layoutSubview{
    return nil;
}

-(void)setLayoutSubview:(XUIViewLayoutSubview)layoutSubview{
    
}

- (void)setEverythingNeedsDisplay{
    
}

-(void)setFrameOnScreen:(NSRect)frameOnScreen{
    
}

-(NSRect)frameOnScreen{
    return NSMakeRect(0, 0, 100, 100);
}

- (BOOL)eventInside:(NSEvent *)event{
    return NO;
}

- (BOOL)makeFirstResponder{
    return NO;
}

@end
