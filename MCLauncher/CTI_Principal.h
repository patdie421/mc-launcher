//
//  CI_Principal.h
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 13/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CTI_Preferences.h"
#import "CTI_Fenetre2.h"
#import "PopupPIN.h"
#import "Progression.h"

#import "DonneesPreferences.h"

#import "File.h"
#import "Consommateur.h"


@interface CTI_Principal : NSObject
{
    CTI_Preferences *CTI_preferences; 
    PopupPIN *popupPIN;
    Progression *progression;

    NSMutableArray *listeFenetres;

    DonneesPreferences *donneesPreferences;

    Consommateur *ordonnanceur;
    File *fileTaches;
}

@property(readwrite, retain) NSRunningApplication *last;

- (void) update;

- (IBAction)menu_preferences:(id)sender;
- (IBAction)menu_terminal:(id)sender;
- (IBAction)startall:(id)sender;

@end
