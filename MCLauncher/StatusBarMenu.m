//
//  StatusBarMenu.m
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 22/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "StatusBarMenu.h"

@implementation StatusBarMenu

-(void)awakeFromNib
{
	statusBarItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusBarItem setMenu:statusBarMenu];
    [statusBarItem setTitle:@"MCL"];
//	[statusBarItem setImage:[NSImage imageNamed:@"Ukey.png"]];
//	[statusBarItem setAlternateImage:[NSImage imageNamed:@"Ukey.png"]];
	[statusBarItem setHighlightMode:YES];
}

@end
