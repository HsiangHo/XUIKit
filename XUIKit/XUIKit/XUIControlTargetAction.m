//
//  XUIControlTargetAction.m
//  XUIKit
//
//  Created by Jovi on 6/15/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIControlTargetAction.h"

@implementation XUIControlTargetAction{
    id __weak target;
    SEL action;
    void (^block)(void);
    XUIControlEvents controlEvents;
}

@end
