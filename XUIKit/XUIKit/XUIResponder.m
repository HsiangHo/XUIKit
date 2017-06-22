//
//  XUIResponder.m
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIResponder.h"
#import "NSResponder+Private.h"

static __weak id currentFirstResponder;
@implementation NSResponder (XUIAdditions)

+(void)load{
    Class cls = [NSResponder class];
    XUISwizzleMethod(cls, '-', @selector(xui_becomeFirstResponder),@selector(becomeFirstResponder));
}

+(NSResponder *)currentFirstResponder {
    return currentFirstResponder;
}

-(XUIResponder *)defaultFirstResponder{
    return self;
}

-(BOOL)acceptsFirstMouse:(NSEvent *)event{
    return YES;
}

#pragma mark - Swizzle Functions

-(BOOL)xui_becomeFirstResponder{
    BOOL bRtn = [self xui_becomeFirstResponder];
    if(self != currentFirstResponder){
        [self __firstResponderChanged:currentFirstResponder withNewResponder:self];
        currentFirstResponder = self;
    }
    return bRtn;
}

@end
