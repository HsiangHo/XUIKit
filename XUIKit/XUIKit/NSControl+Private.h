//
//  NSControl+Private.h
//  XUIKit
//
//  Created by Jovi on 6/13/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSControl (Private)

- (void)__stateWillChange;
- (void)__stateDidChange;

@end
