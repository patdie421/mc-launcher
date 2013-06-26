//
//  CI_Preferences.h
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 13/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DonneesPreferences.h"

@interface CTI_Preferences : NSObject
{
    id pere;
    
    IBOutlet id fenetre;
    
    IBOutlet id onglet;
    
    IBOutlet id image;
    IBOutlet id table;
    
    IBOutlet id radio_typeDemarrage;
    IBOutlet id check_pasLancerFinder;

    IBOutlet id check_proctection;
    IBOutlet id label_mdp1;
    IBOutlet id label_mdp2;
    IBOutlet id champ_mdp1;
    IBOutlet id champ_mdp2;
    
    IBOutlet id appliAActiver;
    
    DonneesPreferences *donneesPreferences;
    
    NSMutableArray *copieListeApplications;
    NSString *copieFondEcran;
}

@property(readwrite, retain) id pere;
@property(readwrite, retain) DonneesPreferences *donneesPreferences;

- (IBAction)anim_boutons:(id)sender;
- (IBAction)bouton_annuler:(id)sender;
- (IBAction)bouton_ok:(id)sender;
- (IBAction)bouton_plus:(id)sender;
- (IBAction)bouton_moins:(id)sender;

- (void)afficher;

@end
