//
//  XUIControlTargetAction.h
//  XUIKit
//
//  Created by Jovi on 6/15/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XUIType.h"

@interface XUIControlTargetAction : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) void(^block)(void);
@property (nonatomic, assign) XUIControlEvents controlEvents;

@end
