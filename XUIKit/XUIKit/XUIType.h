//
//  XUIType.h
//  XUIKit
//
//  Created by Jovi on 6/15/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#ifndef XUIType_h
#define XUIType_h

enum {
    XUIControlEventTouchDown            = 1 <<  0,
    XUIControlEventTouchDownRepeat      = 1 <<  1,
    XUIControlEventTouchUpInside        = 1 <<  2,
    XUIControlEventTouchUpOutside       = 1 <<  3,
    XUIControlEventAllEvents            = 1 <<  11,
};
typedef NSUInteger XUIControlEvents;

enum {
    XUIControlStateNormal       = 0,
    XUIControlStateHovered      = 1 << 0,
    XUIControlStateDown         = 1 << 1,
    XUIControlStateUp           = 1 << 2,
    XUIControlStateDisabled     = 1 << 3,
    XUIControlStateFocused      = 1 << 4,
    XUIControlStateNotKey       = 1 << 11,
};
typedef NSUInteger XUIControlState;

#endif /* XUIType_h */
