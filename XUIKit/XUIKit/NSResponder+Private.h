//
//  NSResponder+Private.h
//  XUIKit
//
//  Created by Jovi on 6/23/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSResponder (Private)

-(void)__firstResponderChanged:(NSResponder *)oldFirstResponder withNewResponder:(NSResponder *)newFirstResponder;

@end
