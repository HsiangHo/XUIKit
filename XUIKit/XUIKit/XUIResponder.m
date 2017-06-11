//
//  XUIResponder.m
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIResponder.h"

@implementation NSResponder (XUIAdditions)

-(XUIResponder *)defaultFirstResponder{
    return self;
}

-(BOOL)acceptsFirstMouse:(NSEvent *)event{
    return YES;
}

@end
