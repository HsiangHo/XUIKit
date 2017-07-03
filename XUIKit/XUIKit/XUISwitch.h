//
//  XUISwitch.h
//  XUIKit
//
//  Created by Jovi on 7/2/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XUISwitch : NSControl

@property(nonnull, nonatomic, strong)           NSColor     *onTintColor;
@property(nonnull, nonatomic, strong)           NSColor     *tintColor;
@property(nullable, nonatomic, strong)          NSColor     *onBorderColor;
@property(nullable, nonatomic, strong)          NSColor     *borderColor;
@property(nonnull, nonatomic, strong)           NSColor     *thumbTintColor;
@property(nonatomic,getter=isOn)                BOOL        on;

- (void)setOn:(BOOL)on animated:(BOOL)animated; // does not send action

@end
