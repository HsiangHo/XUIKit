//
//  XUIActivityIndicatorView.h
//  XUIKit
//
//  Created by Jovi on 7/5/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XUIView.h"
#import "XUIType.h"

NS_ASSUME_NONNULL_BEGIN

@interface XUIActivityIndicatorView : XUIView

- (instancetype)initWithActivityIndicatorStyle:(XUIActivityIndicatorViewStyle)style;
- (instancetype)initWithFrame:(NSRect)frame;

@property (nonatomic, readonly) XUIActivityIndicatorViewStyle activityIndicatorViewStyle; // default is XUIActivityIndicatorViewStyleCircleLineRotate
@property (nonatomic) BOOL                          hidesWhenStopped;           // default is YES. calls -setHidden when animating gets set to NO
@property (nonatomic) CGFloat                       durationTime;               // default is 1.5 second
@property (nullable, readwrite, nonatomic, strong)  NSColor *color;             // default is Red

- (void)startAnimating;
- (void)stopAnimating;

@property(nonatomic, readonly, getter=isAnimating) BOOL animating;

@end

NS_ASSUME_NONNULL_END
