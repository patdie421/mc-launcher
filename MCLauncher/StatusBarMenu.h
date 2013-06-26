//
//  StatusBarMenu.h
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 22/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface StatusBarMenu : NSObject
{
    IBOutlet NSMenu *statusBarMenu;
    
    NSStatusItem * statusBarItem;
}
@end
