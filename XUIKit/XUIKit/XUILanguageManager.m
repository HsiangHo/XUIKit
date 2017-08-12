//
//  XUILanguageManager.m
//  XUIKit
//
//  Created by Jovi on 8/12/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUILanguageManager.h"

#define kXUI_CURRENT_LANGUAGE               @"kCurrentLanguage"

static XUILanguageManager *instance;
@implementation XUILanguageManager{
    NSBundle                *_languageBundle;
    NSMutableArray          *_arrayBlocks;
}

#pragma mark - override methods

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUILanguageManager];
    }
    return self;
}

#pragma mark - private methods

-(void)__initializeXUILanguageManager{
    _arrayBlocks = [[NSMutableArray alloc] init];
    NSString *path = [[NSBundle mainBundle]pathForResource:[self __currentLanguage] ofType:@"lproj"];
    _languageBundle = [NSBundle bundleWithPath:path];
}

-(NSString *)__currentLanguage{
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults]objectForKey:kXUI_CURRENT_LANGUAGE];
    if (nil == currentLanguage){
        currentLanguage = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
        [self __setCurrentLanguage:currentLanguage];
    }
    return currentLanguage;
}

-(void)__setCurrentLanguage:(NSString *)language{
    [[NSUserDefaults standardUserDefaults]setObject:language forKey:kXUI_CURRENT_LANGUAGE];
}

-(void)__invokeBlocks{
    for (actionBlock block in _arrayBlocks) {
        if (nil != block) {
            block();
        }
    }
}

#pragma mark - public methods
+(instancetype)sharedManager{
    @synchronized (self) {
        if (nil == instance) {
            instance = [[XUILanguageManager alloc] init];
        }
        return instance;
    }
}

-(NSString *)currentLanguage{
    return [self __currentLanguage];
}

-(void)setLanguage:(NSString *)lanuage{
    if(nil == lanuage || [[self __currentLanguage] isEqualToString:lanuage]){
        return;
    }
    NSString *path = [[NSBundle mainBundle]pathForResource:lanuage ofType:@"lproj"];
    _languageBundle = [NSBundle bundleWithPath:path];
    if (nil != _languageBundle) {
        [self __setCurrentLanguage:lanuage];
    }
    [self __invokeBlocks];
}

-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table{
    if (nil != _languageBundle){
        return NSLocalizedStringFromTableInBundle(key, table, _languageBundle, @"");
    }
    return NSLocalizedStringFromTable(key, table, @"");
}

-(void)addLanguageChangedBlock:(actionBlock) block{
    if (nil == block) {
        return;
    }
    [_arrayBlocks addObject:block];
}

@end
