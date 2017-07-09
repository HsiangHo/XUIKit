//
//  XUIType.h
//  XUIKit
//
//  Created by Jovi on 6/15/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#ifndef XUIType_h
#define XUIType_h

#define XUI_UNAVAILABLE __attribute__((unavailable("unavailable for XUIKit")))

enum {
    XUIControlEventTouchDown            = 1 <<  0,
    XUIControlEventTouchDownRepeat      = 1 <<  1,
    XUIControlEventTouchUpInside        = 1 <<  2,
    XUIControlEventTouchUpOutside       = 1 <<  3,
    XUIControlEventAllEvents            = 0xFFFFFFFF
};
typedef NSUInteger XUIControlEvents;

enum {
    XUIControlStateNormal       = 0,
    XUIControlStateHovered      = 1 << 0,
    XUIControlStateDown         = 1 << 1,
    XUIControlStateUp           = 1 << 2,
    XUIControlStateDisabled     = 1 << 3,
    XUIControlStateFocused      = 1 << 4
};
typedef NSUInteger XUIControlState;

typedef NS_ENUM(NSInteger, XUITextFieldViewMode) {
    XUITextFieldViewModeNever,
    XUITextFieldViewModeWhileEditing,
    XUITextFieldViewModeUnlessEditing,
    XUITextFieldViewModeAlways
};

typedef NS_ENUM(NSInteger, XUIProgressViewStyle) {
    XUIProgressViewStyleBar,     // normal progress bar
    XUIProgressViewStyleCircle   // circle progress bar
};

typedef NS_ENUM(NSInteger, XUIActivityIndicatorViewStyle) {
    XUIActivityIndicatorViewStyleCircleLineRotate,
    XUIActivityIndicatorViewStyleBallRotateChase,
    XUIActivityIndicatorViewStyleLineSpinFade,
    XUIActivityIndicatorViewStyleBallSpinFade,
    XUIActivityIndicatorViewStyleBallPulse,
    XUIActivityIndicatorViewStyleLineScale
};

#endif /* XUIType_h */
