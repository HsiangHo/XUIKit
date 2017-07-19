//
//  XUISecureTextField+Private.h
//  XUIKit
//
//  Created by Jovi on 7/19/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <XUIKit/XUIKit.h>

@interface XUISecureTextField (Private)

-(NSRect)__rectLeftView;
-(NSRect)__rectRightView;
-(NSRect)__rectClearButton;
-(void)__updateLookup;

@end
