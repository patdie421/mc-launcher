//
//  PopupPIN.m
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 17/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "PopupPIN.h"

#import "globales.h"

static NSString *c_popupPIN=@"PopupPIN";

@implementation PopupPIN

@synthesize motDePasse;

- (void)dealloc
{
	[super dealloc];
}


- (id) init
{
    if ((self = [super init]) != nil)
    {
        fenetre=nil;
    }
    return self;
}


- (void)awakeFromNib
{
}


- (void)windowWillClose:(NSNotification *)notification
{
	fenetre=nil;
}


- (IBAction)bouton_OK:(id)sender
{
    [motDePasse release];
    motDePasse=[[NSString alloc] initWithString:[passwd stringValue]];
    retour=YES;
    [NSApp stopModal];
    [fenetre close];
}


- (IBAction)bouton_Annuler:(id)sender
{
    [motDePasse release];
    motDePasse=[[NSString alloc] initWithString:@""];
    retour=NO;
    [NSApp stopModal];
    [fenetre close];
}


- (BOOL)afficher
{
	if(!fenetre)
	{
		if (![NSBundle loadNibNamed:c_popupPIN owner:self])
		{
			DEBUGNSLOG(@"Can't load Nib file %@",c_popupPIN);
			return NO;
		}
		else
		{
            // finalisation du parametrage de la fenetre
			[fenetre setReleasedWhenClosed:YES];
			[fenetre setDelegate:self];
            
        }
	}
    retour=NO;
    [fenetre center];
    [NSApp runModalForWindow:fenetre];
    return retour;
}

@end
