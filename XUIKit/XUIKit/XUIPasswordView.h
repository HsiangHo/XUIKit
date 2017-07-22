//
//  XUIPasswordView.h
//  XUIKit
//
//  Created by Jovi on 7/20/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIView.h"
#import "XUIType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XUIPasswordViewDelegate <NSObject>

@optional
- (void)controlTextDidChange:(NSNotification *)notification;
- (void)controlTextDidBeginEditing:(NSNotification *)obj;
- (void)controlTextDidEndEditing:(NSNotification *)obj;

@end

@interface XUIPasswordView : XUIView

@property (nonnull,nonatomic,strong)                        NSString    *passwordStringValue;
@property (nonatomic,assign,getter=isPasswordHidden)        BOOL        passwordHidden;
@property (nullable,nonatomic,weak)     id<XUIPasswordViewDelegate>     delegate;
@property (nullable, nonatomic,strong)                      NSView      *leftView;
@property (nonatomic)        XUITextFieldViewMode           leftViewMode;

@end

NS_ASSUME_NONNULL_END
