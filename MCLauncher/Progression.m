//
//  BarreDeProgression.m
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 19/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "Progression.h"

#import "globales.h"

static NSString *c_Progression=@"Progression";

@implementation Progression

@synthesize cptr, max;

- (id) init
{
    if ((self = [super init]) != nil)
    {
        if (![NSBundle loadNibNamed:c_Progression owner: self])
        {
            [self release];
            self = nil;
        }
        cptr=0;
    }	
    return self;
}


- (id) view
{
	// [barre startAnimation:nil];
    [barre setDoubleValue:0];
    return view;
}


- (void)reception:(NSNotification *)notification
{
    [barre setDoubleValue:(double)(cptr*100.0/max)];
    cptr++;
    NSDictionary *info = [notification userInfo];
    [texte setStringValue:[info objectForKey:@"ACTION"]];
}


- (void)demarrer
{
	NSNotificationCenter *nofifcenter=[NSNotificationCenter defaultCenter];
	[nofifcenter addObserver:self
					selector:@selector(reception:)
						name:D_NOTIF_TACHE
					  object:nil];
}


- (void)arreter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:D_NOTIF_TACHE object:nil];
}


@end
