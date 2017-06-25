//
//  XUILabel.h
//  XUIKit
//
//  Created by Jovi on 6/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XUIType.h"

@interface XUILabel : NSTextField

-(void)setStringValue:(NSString *)stringValue XUI_UNAVAILABLE;
-(NSString *)stringValue XUI_UNAVAILABLE;

@property (nonatomic,copy)                          NSString            *text;
@property (nonatomic,assign,getter=isUnderLined)    BOOL                underlined;
@property (nonatomic,assign)                        NSLineBreakMode     lineBreakMode;

@end
