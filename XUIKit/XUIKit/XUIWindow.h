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

@property (nonatomic,strong)    XUIWindowSystemButtonView   *systemButtonView;
@property (nonatomic,strong)    XUIView                     *headerView;
@property (nonatomic,strong)    XUILabel                    *windowTitle;

@end
NS_ASSUME_NONNULL_END
