//
//  XUIPasswordView.m
//  XUIKit
//
//  Created by Jovi on 7/20/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIPasswordView.h"
#import "XUIButton.h"
#import "XUITextField.h"
#import "XUISecureTextField.h"
#import "NSImage+XUIAdditions.h"

@implementation XUIPasswordView{
    XUITextField                            *_tfPassword;
    XUISecureTextField                      *_tfSecurePassword;
    XUIButton                               *_btnEye;
    NSView                                  *_leftView;
    NSString                                *_passwordStringValue;
    BOOL                                    _passwordHidden;
    __weak NSObject                         *_delegate;
}

#pragma mark - Override methods

-(instancetype)init{
    if(self = [super init]){
        [self __initializeXUIPasswordView];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self __initializeXUIPasswordView];
    }
    return self;
}

-(void)drawRect:(NSRect)dirtyRect{
    [super drawRect:dirtyRect];
    
    [_tfPassword setFrame:self.bounds];
    [_tfSecurePassword setFrame:self.bounds];
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *tf = [notification object];
    _passwordStringValue = [tf stringValue];
    if(nil != _delegate && [_delegate respondsToSelector:@selector(controlTextDidChange:)]){
        [_delegate controlTextDidChange:notification];
    }
}

- (void)controlTextDidBeginEditing:(NSNotification *)obj{
    if(nil != _delegate && [_delegate respondsToSelector:@selector(controlTextDidBeginEditing:)]){
        [_delegate controlTextDidBeginEditing:obj];
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj{
    if(nil != _delegate && [_delegate respondsToSelector:@selector(controlTextDidEndEditing:)]){
        [_delegate controlTextDidEndEditing:obj];
    }
}

#pragma mark - Private methods

-(void)__initializeXUIPasswordView{
    _tfPassword = [[XUITextField alloc] init];
    _tfSecurePassword = [[XUISecureTextField alloc] init];
    _btnEye = [[XUIButton alloc] initWithFrame:NSMakeRect(0, 0, 28, 18)];
    [_btnEye setTarget:self];
    [_btnEye setAction:@selector(eyeButton_click:)];
    [_tfPassword setClearButtonMode:XUITextFieldViewModeWhileEditing];
    [_tfSecurePassword setClearButtonMode:XUITextFieldViewModeWhileEditing];
    [_tfPassword setRightViewMode:XUITextFieldViewModeAlways];
    [_tfSecurePassword setRightViewMode:XUITextFieldViewModeAlways];
    [_tfPassword setDelegate:(id<NSTextFieldDelegate>)self];
    [_tfSecurePassword setDelegate:(id<NSTextFieldDelegate>)self];
    [_tfPassword.cell setWraps:NO];
    [_tfPassword.cell setUsesSingleLineMode:YES];
    [_tfSecurePassword.cell setWraps:NO];
    [_tfSecurePassword.cell setUsesSingleLineMode:YES];
    [_tfPassword setHidden:YES];
    [_tfSecurePassword setHidden:YES];
    [self addSubview:_tfPassword];
    [self addSubview:_tfSecurePassword];
    [self __setupSecureTextField];
}

-(void)__setupSecureTextField{
    [_tfSecurePassword setStringValue:_tfPassword.stringValue];
    [_btnEye setBackgroundImage:[NSImage XUI_showSecureTextImage] forState:XUIControlStateNormal];
    [_tfSecurePassword setRightView:_btnEye];
    [_tfSecurePassword setHidden:NO];
    [_tfPassword setHidden:YES];
}

-(void)__setupTextField{
    [_tfPassword setStringValue:_tfSecurePassword.stringValue];
    [_btnEye setBackgroundImage:[NSImage XUI_hideSecureTextImage] forState:XUIControlStateNormal];
    [_tfPassword setRightView:_btnEye];
    [_tfSecurePassword setHidden:YES];
    [_tfPassword setHidden:NO];
}

#pragma mark - Actions

-(IBAction)eyeButton_click:(id)sender{
    if (!_passwordHidden) {
        [self __setupSecureTextField];
    }else{
        [self __setupTextField];
    }
    _passwordHidden = !_passwordHidden;
}

#pragma mark - Public methods

-(void)setPasswordStringValue:(NSString *)passwordStringValue{
    _passwordStringValue = passwordStringValue;
    [_tfPassword setStringValue:passwordStringValue];
    [_tfSecurePassword setStringValue:passwordStringValue];
}

-(void)setPasswordHidden:(BOOL)passwordHidden{
    _passwordHidden = passwordHidden;
    if(_passwordHidden){
        [self __setupSecureTextField];
    }else{
        [self __setupTextField];
    }
}

-(void)setLeftView:(NSView *)leftView{
    _leftView = leftView;
}

-(NSView *)leftView{
    return _leftView;
}

-(void)setLeftViewMode:(XUITextFieldViewMode)leftViewMode{
    [_tfPassword setLeftViewMode:leftViewMode];
    [_tfSecurePassword setLeftViewMode:leftViewMode];
}

@end
