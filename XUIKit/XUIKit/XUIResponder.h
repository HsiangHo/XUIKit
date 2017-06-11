//
//  XUIResponder.h
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NSResponder XUIResponder;

@interface NSResponder (XUIAdditions)

@property (strong, nonatomic, readonly) XUIResponder *defaultFirstResponder;

- (BOOL)acceptsFirstMouse:(NSEvent *)event;

@end
