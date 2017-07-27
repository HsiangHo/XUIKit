//
//  XUIWindowSystemButtonView.h
//  XUIKit
//
//  Created by Jovi on 7/27/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XUIView.h"

NS_ASSUME_NONNULL_BEGIN
@interface XUIWindowSystemButtonView : XUIView

@property (nonatomic,weak,readonly)      NSButton           *closeButton;
@property (nonatomic,weak,readonly)      NSButton           *maxButton;
@property (nonatomic,weak,readonly)      NSButton           *minButton;

@property (nonatomic,readwrite)      NSPoint                pointOfCloseButton;
@property (nonatomic,readwrite)      NSPoint                pointOfMaxButton;
@property (nonatomic,readwrite)      NSPoint                pointOfMinButton;

@end
NS_ASSUME_NONNULL_END
