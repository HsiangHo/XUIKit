//
//  XUISharingManager.h
//  XUIKit
//
//  Created by Jovi on 9/6/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface XUISharingManager : NSObject
@property (nonatomic,strong)  NSMutableArray                *shareItems;

+(instancetype)sharedManager;

/*
 This is a normal menu.
 */
-(NSMenu *)sharingMenu;

/*
 This action will invoke system share menu view
 */
-(IBAction)shareButton_click:(id)sender;

@end
