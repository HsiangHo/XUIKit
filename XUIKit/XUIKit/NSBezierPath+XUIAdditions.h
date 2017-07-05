//
//  NSBezierPath+XUIAdditions.h
//  XUIKit
//
//  Created by Jovi on 7/5/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (XUIAdditions)

// The caller should release with CGPathRelease.
- (CGPathRef)quartzPath;

@end
