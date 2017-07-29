//
//  XUIWindow.h
//  XUIKit
//
//  Created by Jovi on 7/23/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XUIWindowSystemButtonView;
@class XUIView;
@class XUILabel;

NS_ASSUME_NONNULL_BEGIN
@interface XUIWindow : NSWindow

@property (nonatomic,strong,readonly)       XUIWindowSystemButtonView   *systemButtonView;
@property (nonatomic,strong,readonly)       XUIView                     *headerView;

@property (nonatomic,assign)                NSSize                      minimumSize;
@property (nonatomic,assign)                NSSize                       maximumSize;

//Title is a subview of the header view.
@property (nonatomic,assign)                NSRect                      titleFrame;
@property (nonatomic,copy)                  NSColor                     *titleColor;
@property (nonatomic,copy)                  NSFont                      *titleFont;

@end
NS_ASSUME_NONNULL_END
