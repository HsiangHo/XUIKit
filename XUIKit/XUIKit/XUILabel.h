//
//  XUILabel.h
//  XUIKit
//
//  Created by Jovi on 6/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSTextField+XUIAdditions.h"
#import "XUIType.h"

@interface XUILabel : NSTextField

-(void)setStringValue:(NSString *)stringValue XUI_UNAVAILABLE;
-(NSString *)stringValue XUI_UNAVAILABLE;
-(void)setAttributedStringValue:(NSAttributedString *)attributedStringValue XUI_UNAVAILABLE;
-(NSAttributedString *)attributedStringValue XUI_UNAVAILABLE;

@property (nonatomic,assign,getter=isUnderLined)    BOOL                underlined;
@property (nonatomic,assign)                        CGFloat             movingSpeed;
-(void)startMoving;
-(void)stopMoving;

@end
