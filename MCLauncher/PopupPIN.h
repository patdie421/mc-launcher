//
//  PopupPIN.h
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 17/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopupPIN : NSObject
{
    IBOutlet id fenetre;
    IBOutlet id passwd;
    
    NSString *motDePasse;
    BOOL retour;
}

@property(readwrite, retain) NSString *motDePasse;

- (BOOL)afficher;
- (IBAction)bouton_OK:(id)sender;
- (IBAction)bouton_Annuler:(id)sender;

@end
