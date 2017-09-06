//
//  XUISharingManager.m
//  XUIKit
//
//  Created by Jovi on 9/6/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUISharingManager.h"

static XUISharingManager *instance;
@implementation XUISharingManager{
    NSSharingServicePicker      *_sharingServicePicker;
    NSMutableArray              *_shareItems;
    NSArray                     *_currentServices;
}

#pragma mark - public methods

+(instancetype)sharedManager{
    @synchronized (self) {
        if (nil == instance) {
            instance = [[XUISharingManager alloc] init];
        }
        return instance;
    }
}

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUISharingManager];
    }
    return self;
}

-(NSMenu *)sharingMenu{
    _currentServices = [NSSharingService sharingServicesForItems:_shareItems];
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"sharingMenu"];
    for (NSSharingService *currentService in _currentServices){
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:currentService.title action:@selector(__menuItemSelector:) keyEquivalent:@""];
        item.image = currentService.image;
        item.target = self;
        item.representedObject = currentService;
        [menu addItem:item];
    }
    return menu;
}

-(IBAction)shareButton_click:(id)sender{
    _sharingServicePicker = [[NSSharingServicePicker alloc] initWithItems:_shareItems];
    [_sharingServicePicker showRelativeToRect:[(NSView *)sender bounds] ofView:(NSView *)sender preferredEdge:NSMaxYEdge];
}

#pragma mark - private methods

-(void)__initializeXUISharingManager{
    
}

-(IBAction)__menuItemSelector:(NSMenuItem *)item{
    NSSharingService *currentService = item.representedObject;
    [currentService performWithItems:_shareItems];
}

@end
