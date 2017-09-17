//
//  AppDelegate.m
//  XUIKitExample
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "AppDelegate.h"
#import <XUIKit/XUIKit.h>

#define BUTTON_TITLE_COLOR          [NSColor colorWithHex:@"#5f5f5f" alpha:0.98]
#define TIP_COLOR                   [NSColor colorWithHex:@"#666666" alpha:0.98]

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate{
    XUIWindow                   *_wnd1;
    XUIHudWindow                *_wnd2;
    
    XUIActivityIndicatorView    *_activityIndicatorView1;
    XUIActivityIndicatorView    *_activityIndicatorView2;
    XUIView                     *_buttonView;
    XUIButton                   *_button;
    XUILabel                    *_lbTip;
    BOOL                        _flag;
    NSColor                     *_normalColor;
    NSColor                     *_runningColor;
    XUIComboBox                 *_language;
    NSArray                     *_arrayLanguages;
    NSArray                     *_arrayLanguagesCode;
    XUICheckbox                 *_checkbox;
    XUISwitch                   *_switch;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self createXUIWindow];
    [self createXUIHudWindow];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)createXUIWindow{
    _arrayLanguages = @[@"English",@"简体中文"];
    _arrayLanguagesCode = @[@"en",@"zh-Hans"];
    _flag = NO;
    _normalColor = [NSColor colorWithHex:@"#888888" alpha:0.9];
    _runningColor = [NSColor colorWithHex:@"#009d76" alpha:0.9];
    
    _wnd1 = [[XUIWindow alloc]initWithContentRect:CGRectMake(100,
                                                             100, 300, 300) styleMask:NSWindowStyleMaskTitled|NSWindowStyleMaskTexturedBackground|NSWindowStyleMaskResizable|NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskClosable backing:NSBackingStoreRetained defer:NO];
    _wnd1.backgroundColor = [NSColor whiteColor];
    _wnd1.titleColor = [NSColor blueColor];
    [_wnd1 center];
    [_wnd1 makeKeyAndOrderFront:nil];
    [_wnd1 setMinimizable:NO];
    
    _buttonView = [[XUIView alloc] initWithFrame:NSMakeRect(0, 0, 200, 200)];
    [_wnd1.mainView addSubview:_buttonView];
    
    _activityIndicatorView1 = [[XUIActivityIndicatorView alloc] initWithActivityIndicatorStyle:XUIActivityIndicatorViewStyleBallScaleRipple];
    [_activityIndicatorView1 setFrame:_buttonView.frame];
    [_activityIndicatorView1 setColor:[NSColor blackColor]];
    [_activityIndicatorView2 stopAnimating];
    [_buttonView addSubview:_activityIndicatorView1];
    
    _activityIndicatorView2 = [[XUIActivityIndicatorView alloc] initWithActivityIndicatorStyle:XUIActivityIndicatorViewStyleCircleLineRotate];
    [_activityIndicatorView2 setFrame:_buttonView.frame];
    [_activityIndicatorView2 setColor:_normalColor];
    [_activityIndicatorView2 stopAnimating];
    [_buttonView addSubview:_activityIndicatorView2];
    
    _button = [[XUIButton alloc] initWithFrame:NSMakeRect(40, 40, 120, 120)];
    [_button.layer setBorderColor:[NSColor colorWithHex:@"#fdfdfd" alpha:0.98].CGColor];
    [_button.layer setBorderWidth:1.5f];
    [_button addTarget:self action:@selector(action_click:) forControlEvents:XUIControlStateUp];
    NSUInteger nRadius = 60;
    [_button setEffectiveAreaPath:[NSBezierPath bezierPathWithOvalInRect:_button.bounds]];
    [_button setTitleEdgeInsets:NSEdgeInsetsMake(0.38, 0.05, 0.38, 0.05)];
    [_button setBackgroundColor:[NSColor colorWithHex:@"#fdfdfd" alpha:0.98] forState:XUIControlStateNormal];
    [_button setTitleColor:BUTTON_TITLE_COLOR forState:XUIControlStateNormal];
    [_button setFont:[NSFont fontWithName:@"Helvetica Neue" size:21] forState:XUIControlStateNormal];
    [_button setCornerRadius:nRadius forState:XUIControlStateNormal];
    [_button setCornerRadius:nRadius forState:XUIControlStateHovered];
    [_button setCornerRadius:nRadius forState:XUIControlStateDown];
    [_button setCornerRadius:nRadius forState:XUIControlStateUp];
    [_button setCornerRadius:nRadius forState:XUIControlStateFocused];
    [_button setCursor:[NSCursor pointingHandCursor] forState:XUIControlStateHovered];
    [_button setCursor:[NSCursor pointingHandCursor] forState:XUIControlStateDown];
    [_button setCursor:[NSCursor pointingHandCursor] forState:XUIControlStateUp];
    [_button setCursor:[NSCursor pointingHandCursor] forState:XUIControlStateFocused];
    [_buttonView addSubview:_button];
    
    _lbTip = [[XUILabel alloc] initWithFrame:NSMakeRect(0, 200, 200, 20)];
    [_lbTip setAlignment:NSCenterTextAlignment];
    [_lbTip setFont:[NSFont fontWithName:@"Helvetica Neue" size:15]];
    [_lbTip setTextColor:TIP_COLOR];
    [_wnd1.mainView addSubview:_lbTip];
    
    _language = [[XUIComboBox alloc] initWithFrame:NSMakeRect(0, 220, 200, 26)];
    [_wnd1.mainView addSubview:_language];
    [_language setTextColor:[NSColor colorWithHex:@"#333333" alpha:1.0]];
    for(NSString *language in _arrayLanguages){
        [_language addItemWithObjectValue:language];
    }
    NSString *currentLanguage = [[XUILanguageManager sharedManager] currentLanguage];
    NSUInteger indexLanguage = [_arrayLanguagesCode indexOfObject:currentLanguage];
    [_language selectItemAtIndex:indexLanguage];
    [_language setDelegate:(id<NSComboBoxDelegate>)self];

    _checkbox = [[XUICheckbox alloc] initWithFrame:NSMakeRect(0, 250, 100, 30)];
    [_checkbox setTitleColor:[NSColor colorWithHex:@"#98d12a" alpha:1.0]];
    [_checkbox setFont:[NSFont fontWithName:@"Helvetica Neue" size:15]];
    [_checkbox setDetaY:3];
    [_wnd1.mainView addSubview:_checkbox];
    
    _switch = [[XUISwitch alloc] initWithFrame:NSMakeRect(100, 250, 40, 25)];
    [_switch setOn:YES];
    [_wnd1.mainView addSubview:_switch];
    
    [[XUILanguageManager sharedManager] addLanguageChangedBlock:^{
        [self __localizeString];
    }];
    [self __localizeString];
}

-(void)createXUIHudWindow{
    _wnd2 = [[XUIHudWindow alloc]initWithContentRect:CGRectMake(200,
                                                                200, 64, 64) styleMask:0 /*NSWindowStyleMaskClosable*/ backing:NSBackingStoreRetained defer:NO];
    [_wnd2 makeKeyAndOrderFront:nil];
    XUIImageView *_ivAppleAlert = [[XUIImageView alloc] initWithFrame:NSMakeRect(0, 0, 64, 64)];
    [_ivAppleAlert setImage:[NSImage imageNamed:@"apple"]];
    [_wnd2.contentView setFrameSize:NSMakeSize(64, 64)];
    [_wnd2.contentView addSubview:_ivAppleAlert];
}


-(void)__localizeString{
    [self __updateUI];
}

-(void)__updateUI{
    if (!_flag) {
        [_button setTitle:XUILocalizedString(@"start") forState:XUIControlStateNormal];
        [_button setTitle:XUILocalizedString(@"start") forState:XUIControlStateHovered];
        [_activityIndicatorView2 setColor:_normalColor];
        [_button.layer setBorderColor:_normalColor.CGColor];
        [_button setTitleColor:BUTTON_TITLE_COLOR forState:XUIControlStateNormal];
        [_lbTip setText:XUILocalizedString(@"waiting_to_start")];
        [_lbTip setTextColor:TIP_COLOR];
    }else{
        [_button setTitle:XUILocalizedString(@"running") forState:XUIControlStateNormal];
        [_button setTitle:XUILocalizedString(@"stop") forState:XUIControlStateHovered];
        [_activityIndicatorView2 setColor:_runningColor];
        [_button.layer setBorderColor:_runningColor.CGColor];
        [_button setTitleColor:_runningColor forState:XUIControlStateNormal];
        [_lbTip setText:XUILocalizedString(@"progressing")];
        [_lbTip setTextColor:_runningColor];
    }
}

#pragma mark - Actions
-(IBAction)action_click:(id)sender{
    _flag = !_flag;
    if(_flag){
        [_activityIndicatorView1 stopAnimating];
        [_activityIndicatorView2 startAnimating];
    }else{
        [_activityIndicatorView1 startAnimating];
        [_activityIndicatorView2 stopAnimating];
    }
    [self __updateUI];
}

#pragma mark - Delegate
- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSString *languageCode = [_arrayLanguagesCode objectAtIndex: [_language indexOfSelectedItem]];
    [[XUILanguageManager sharedManager] setLanguage:languageCode];
}

@end
