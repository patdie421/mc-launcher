//
//  Application.m
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 16/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "Application.h"

@implementation Application

@synthesize nom, chemin, premierPlan, delaiApresLancement, icone;

- (id)init
{
	if (self = [super init])
	{
	}
	return self;
}


- (void)dealloc
{
    [nom release];
    [chemin release];
    
	[super dealloc];
}


- (NSString *)cheminComplet
{
    NSString *fullPath;
    
    fullPath=[[NSString alloc] initWithFormat:@"%@/%@", chemin, nom];
    [fullPath autorelease];
    
    return fullPath;
}


- (void)activer
{
    NSWorkspace *sharedWorkspace =[NSWorkspace sharedWorkspace];
    
    NSString *appPath =[sharedWorkspace fullPathForApplication: [self cheminComplet]];
    NSString *identifier =[[NSBundle bundleWithPath:appPath] bundleIdentifier];
    NSArray *selectedApps = [NSRunningApplication runningApplicationsWithBundleIdentifier:identifier];
    
    for(NSRunningApplication * app in selectedApps)
    {
        [app activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    }
}


- (void)masquer
{
    NSWorkspace *sharedWorkspace =[NSWorkspace sharedWorkspace];
    
    NSString *appPath =[sharedWorkspace fullPathForApplication: [self cheminComplet]];
    NSString *identifier =[[NSBundle bundleWithPath:appPath] bundleIdentifier];
    NSArray *selectedApps = [NSRunningApplication runningApplicationsWithBundleIdentifier:identifier];
    
    for(NSRunningApplication * app in selectedApps)
    {
        [app hide];
    }
}


- (NSMutableDictionary *)sauveDansDictionnaire
{
    NSMutableDictionary *d=[[NSMutableDictionary alloc] init];
    
    [d setObject:nom forKey:@"NOM"];
    [d setObject:chemin forKey:@"CHEMIN"];
    [d setObject:[NSNumber numberWithInt:delaiApresLancement] forKey:@"DELAI"];
    
    [d autorelease];
    
    return d;
}


- (void)chargeDepuisDictionnaire:(NSMutableDictionary *)d
{
    [nom release];
    nom=[[NSString alloc] initWithString:[d objectForKey:@"NOM"]];
    [chemin release];
    chemin=[[NSString alloc] initWithString:[d objectForKey:@"CHEMIN"]];
    delaiApresLancement=[[d objectForKey:@"DELAI"] intValue];
}

@end
