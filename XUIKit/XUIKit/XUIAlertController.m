//
//  XUIAlertController.m
//  XUIKit
//
//  Created by Jovi on 8/2/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIAlertController.h"
#import "NSColor+XUIAdditions.h"
#import "NSControl+XUIAdditions.h"
#import "XUILabel.h"

@implementation XUIAlertAction{
    XUIAlertActionHandlerBlock      _handler;
    XUIButton                       *_actionButton;
}

+ (instancetype)actionWithTitle:(nullable NSString *)title handler:(XUIAlertActionHandlerBlock)handler{
    return [[XUIAlertAction alloc] initWithTitle:title handler:handler];
}

-(instancetype)initWithTitle:(nullable NSString *)title handler:(XUIAlertActionHandlerBlock)handler{
    if(self = [super init]){
        [self __initializeXUIAlertAction];
        _handler = handler;
        [_actionButton setTitle:title forState:XUIControlStateNormal];
    }
    return self;
}

-(void)__initializeXUIAlertAction{
    _actionButton = [[XUIButton alloc] initWithFrame:NSMakeRect(0, 0, 0, 45)];
    [_actionButton setImageEdgeInsets:NSEdgeInsetsMake(0, 0, 0, 0)];
    [_actionButton setTitleEdgeInsets:NSEdgeInsetsMake(0, 0, 0.2, 0)];
    [_actionButton setTitleColor:[NSColor colorWithHex:@"#0e97ce" alpha:1.0] forState:XUIControlStateNormal];
    [_actionButton setFont:[NSFont fontWithName:@"Helvetica Neue" size:20] forState:XUIControlStateNormal];
    [_actionButton setBackgroundColor:[NSColor clearColor] forState:XUIControlStateNormal];
    [_actionButton addActionForControlEvents:XUIControlEventTouchUpInside block:^{
        if (nil != _handler) {
            _handler(self);
        }
    }];
    [_actionButton addActionForControlEvents:XUIControlEventTouchUpOutside block:^{
        if (nil != _handler) {
            _handler(self);
        }
    }];
}

@end


@interface XUIAlertController ()

@end

@implementation XUIAlertController{
    XUIView                                 *_presentView;
    XUIView                                 *_actionButtonsView;
    XUILabel                                *_lbTitle;
    XUILabel                                *_lbMessage;
    
    NSMutableArray<XUIAlertAction *>        *_actions;
    XUIView                                 *_accessoryView;
}

#pragma mark - Override methods

- (instancetype)initAlertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message{
    if (self = [super init]) {
        [self __initializeXUIAlertController];
        _lbTitle.text = title;
        _lbMessage.text = message;
    }
    return self;
}

#pragma mark - Public methods

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message{
    return [[XUIAlertController alloc] initAlertControllerWithTitle:title message:message];
}

- (void)addAction:(XUIAlertAction *)action{
    if ([action isKindOfClass:[XUIAlertAction class]]) {
        [_actions addObject:action];
        [_presentView setNeedsDisplay:YES];
    }
}

-(NSArray<XUIAlertAction *> *)actions{
    return [_actions copy];
}

-(void)setAccessoryView:(XUIView *)accessoryView{
    _accessoryView = accessoryView;
    [_presentView setNeedsDisplay:YES];
}

-(void)setAlertTitle:(NSString *)alertTitle{
    _lbTitle.text = alertTitle;
}

-(NSString *)alertTitle{
    return _lbTitle.text;
}

-(void)setAlertMessage:(NSString *)alertMessage{
    _lbMessage.text = alertMessage;
}

-(NSString *)alertMessage{
    return _lbMessage.text;
}

-(void)setAlertTitleColor:(NSColor *)alertTitleColor{
    _lbTitle.textColor = alertTitleColor;
}

-(NSColor *)alertTitleColor{
    return _lbTitle.textColor;
}

-(void)setAlertMessageColor:(NSColor *)alertMessageColor{
    _lbMessage.textColor = alertMessageColor;
}

-(NSColor *)alertMessageColor{
    return _lbMessage.textColor;
}

#pragma mark - Private methods

- (void)__initializeXUIAlertController{
    _actions = [[NSMutableArray alloc] init];
    _accessoryView = nil;
    
    _presentView = [[XUIView alloc] initWithFrame:NSMakeRect(0, 0, 0, 175)];
    [_presentView setCornerRadius:8.0f];
    [_presentView setBackgroundColor:[NSColor colorWithHex:@"#33334e" alpha:1.0]];
    [_presentView setDrawRectBlock:^(XUIView *view, NSRect dirtyRect) {
        [self __updateLookup];
    }];
    
    _lbTitle = [[XUILabel alloc] initWithFrame:NSMakeRect(0, 0, 0, 35)];
    [_lbTitle setTextColor:[NSColor whiteColor]];
    [_lbTitle setAlignment:NSCenterTextAlignment];
    [_lbTitle setFont:[NSFont fontWithName:@"Helvetica Neue Medium" size:20]];
    [_presentView addSubview:_lbTitle];
    
    _lbMessage = [[XUILabel alloc] initWithFrame:NSMakeRect(0, 0, 0, 45)];
    [_lbMessage setTextColor:[NSColor whiteColor]];
    [_lbMessage setAlignment:NSCenterTextAlignment];
    [_lbMessage.cell setWraps:YES];
    [_lbMessage.cell setLineBreakMode:NSLineBreakByWordWrapping];
    [_lbMessage setFont:[NSFont fontWithName:@"Helvetica Neue" size:15]];
    [_presentView addSubview:_lbMessage];
    
    _actionButtonsView = [[XUIView alloc] initWithFrame:NSMakeRect(0, 0, 0, 45)];
    [_presentView addSubview:_actionButtonsView];
    
    [self setView:_presentView];
}

- (void)__updateActionButtonsView{
    NSUInteger nCount = [_actions count];
    NSBezierPath *path = [NSBezierPath bezierPath];
    int nHeight = 0;
    if (2 == nCount) {
        int nWidth = NSWidth(self.view.frame) / nCount;
        XUIButton *btn0 = [[_actions objectAtIndex:0] actionButton];
        XUIButton *btn1 = [[_actions objectAtIndex:1] actionButton];
        nHeight = MAX(NSHeight(btn0.frame), NSHeight(btn1.frame));
        [btn0 setFrame:NSMakeRect(0, -1, nWidth - 1, nHeight)];
        [_actionButtonsView addSubview:btn0];
        [btn1 setFrame:NSMakeRect(nWidth , -1, nWidth - 1, nHeight)];
        [_actionButtonsView addSubview:btn1];

        [path moveToPoint:NSMakePoint(0, nHeight - 0.5)];
        [path lineToPoint:NSMakePoint(NSWidth(self.view.frame), nHeight  - 0.5)];
        [path moveToPoint:NSMakePoint(nWidth - 0.5, nHeight)];
        [path lineToPoint:NSMakePoint(nWidth - 0.5, 0)];

    }else{
        int nWidth = NSWidth(self.view.frame);
        for (NSInteger i = nCount - 1; i >= 0 ; --i) {
            XUIAlertAction *action = [_actions objectAtIndex:i];
            XUIButton *button = [action actionButton];
            NSRect rct = [button frame];
            rct.origin.x = 0;
            rct.origin.y = nHeight - 1;
            rct.size.width = nWidth;
            nHeight += rct.size.height;
            [button setFrame:rct];
            [_actionButtonsView addSubview:button];
            
            [path moveToPoint:NSMakePoint(0, nHeight - 0.5)];
            [path lineToPoint:NSMakePoint(NSWidth(self.view.frame), nHeight  - 0.5)];
        }
    }
    
    NSColor *color = [_presentView backgroundColor];
    if ([color isLightColor]) {
        [[color darkenColorByValue:0.2] setStroke];
    }else{
        [[color lightenColorByValue:0.2] setStroke];
    }
    [path stroke];
    
    NSRect rctActionButtonsView = NSMakeRect(0, 0, NSWidth(self.view.frame), nHeight);
    [_actionButtonsView setFrame:rctActionButtonsView];
}

- (void)__updateLookup{
    [self __updateActionButtonsView];
    if (nil == _accessoryView) {
        [_lbTitle setHidden:NO];
        [_lbMessage setHidden:NO];
        
        NSRect rctView = _presentView.frame;
        NSRect rctActionButtonsView = _actionButtonsView.frame;
        NSRect rctTitle = _lbTitle.frame;
        NSRect rctMsg = _lbMessage.frame;
        
        rctTitle.size.width = NSWidth(rctView);
        rctTitle.origin.x = 0;
        rctTitle.origin.y = NSHeight(rctView) - NSHeight(rctTitle) - 20;
        [_lbTitle setFrame:rctTitle];
        
        rctMsg.size.width = NSWidth(rctView) * 0.9;
        rctMsg.size.height = NSMinY(rctTitle) - NSMaxY(rctActionButtonsView);
        rctMsg.origin.x = NSWidth(rctView) * 0.05;
        rctMsg.origin.y = NSMaxY(rctActionButtonsView);
        [_lbMessage setFrame:rctMsg];
    }else{
        [_lbTitle setHidden:YES];
        [_lbMessage setHidden:YES];
        
        [_presentView addSubview:_accessoryView];
        NSRect rctAccessoryView = _accessoryView.frame;
        NSRect rctView = _presentView.frame;
        
        rctAccessoryView.origin.x = 0;
        rctAccessoryView.origin.y = NSHeight(_actionButtonsView.frame);
        rctAccessoryView.size.width = NSWidth(self.view.frame);
        [_accessoryView setFrame:rctAccessoryView];
        
        rctView.size.height = NSHeight(rctAccessoryView) + NSHeight(_actionButtonsView.frame);
        [_presentView setFrame:rctView];
    }
}

@end
