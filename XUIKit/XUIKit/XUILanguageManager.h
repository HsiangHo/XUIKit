//
//  XUILanguageManager.h
//  XUIKit
//
//  Created by Jovi on 8/12/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XUILocalizedStringFromTable(key, tbl) [[XUILanguageManager sharedManager] getStringForKey:key withTable:tbl]
#define XUILocalizedString(key) [[XUILanguageManager sharedManager] getStringForKey:key withTable:@"Localizable"]
#define XUILocalizedStringAdapter(key, comment) [[XUILanguageManager sharedManager] getStringForKey:key withTable:@"Localizable"]

typedef void (^actionBlock)(void);

@interface XUILanguageManager : NSObject

+(instancetype)sharedManager;

-(NSString *)currentLanguage;
-(void)setLanguage:(NSString *)lanuage;
-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;
-(void)addLanguageChangedBlock:(actionBlock) block;

@end
