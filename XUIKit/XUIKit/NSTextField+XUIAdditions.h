//
//  NSTextField+XUIAdditions.h
//  XUIKit
//
//  Created by Jovi on 6/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTextField (XUIAdditions)

@property(nullable, nonatomic,copy)     NSString               *text;
@property(nullable, nonatomic,copy)     NSAttributedString     *attributedText;
@property(nonatomic, assign)            NSLineBreakMode         lineBreakMode;


@end
