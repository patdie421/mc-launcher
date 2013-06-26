//
//  ValeursParDefaut.m
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 16/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "DonneesPreferences.h"

#import "globales.h"

#import "Application.h"

@implementation DonneesPreferences

@synthesize fondEcran, listeApplications, typeDemarrage, lancerFInder, protection, motDePasse, numAppliAActiver;


- (id)init
{
	if (self = [super init])
	{
	}
	return self;
}


- (void)dealloc
{
    [fondEcran release];
    [listeApplications release];
    
	[super dealloc];
}

/*
 * chargement des préférences
 */
-(void)charger
{
    NSUserDefaults *prefs;
    id valeursParDefaut;

    prefs = [NSUserDefaults standardUserDefaults];
    [prefs retain];
    
    valeursParDefaut=[prefs dictionaryForKey:D_DEFAULTS];
    if(!valeursParDefaut)
    {
        valeursParDefaut=[[NSMutableDictionary alloc] init];
    
        /* création des valeurs par défaut */
        [valeursParDefaut setObject:@"" forKey:D_FONDECRAN];
        [valeursParDefaut setObject:[NSNumber numberWithInteger:0] forKey:D_TYPEDEMARRAGE];
        [valeursParDefaut setObject:[NSNumber numberWithBool:NO] forKey:D_LANCERFINDER];
        [valeursParDefaut setObject:[NSNumber numberWithBool:NO] forKey:D_PROTECTION];
        [valeursParDefaut setObject:@"" forKey:D_MOTDEPASSE];
        [valeursParDefaut setObject:[NSNumber numberWithInteger:0] forKey:D_APPLIAACTIVER];
        
        [prefs setObject:valeursParDefaut forKey:D_DEFAULTS];
        [prefs synchronize];
    }
    else
        [valeursParDefaut retain];

    /*
     * Chargement des préférences
     */
    if([[valeursParDefaut objectForKey:D_FONDECRAN] isEqual:@""])
        fondEcran=[[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"fond-xbmc.png"]];
    else
        fondEcran=[[NSString alloc] initWithString:[valeursParDefaut objectForKey:D_FONDECRAN]];
    
    listeApplications=[[NSMutableArray alloc] init];
    for(NSMutableDictionary *i in [valeursParDefaut objectForKey:D_APPLICATIONS])
    {
        Application *application=[[Application alloc] init];
        [application setNom:[i objectForKey:D_NOM]];
        [application setChemin:[i objectForKey:D_CHEMIN]];
        [application setDelaiApresLancement:[[i objectForKey:D_DELAI] intValue]];
        NSImage *icone=[[NSWorkspace sharedWorkspace] iconForFile:[application cheminComplet]];
        [application setIcone:icone];

        [listeApplications addObject:application];
        [application release];
    }
    numAppliAActiver=[[valeursParDefaut objectForKey:D_APPLIAACTIVER] integerValue];
    typeDemarrage=[[valeursParDefaut objectForKey:D_TYPEDEMARRAGE] integerValue];  
    lancerFInder=[[valeursParDefaut objectForKey:D_LANCERFINDER] boolValue];
    protection=[[valeursParDefaut objectForKey:D_PROTECTION] boolValue];
    motDePasse=[valeursParDefaut objectForKey:D_MOTDEPASSE];

    
    [valeursParDefaut release];
    [prefs release];
}


-(void)sauver
{
    NSUserDefaults *prefs;
    NSMutableDictionary *valeursParDefaut;
    
    prefs = [NSUserDefaults standardUserDefaults];
    [prefs retain];
    valeursParDefaut=[[NSMutableDictionary alloc] initWithDictionary:[prefs dictionaryForKey:D_DEFAULTS]];
    
    [valeursParDefaut setObject:fondEcran forKey:D_FONDECRAN];
    
    NSMutableArray *liste=[[NSMutableArray alloc] init];
    for(Application *application in listeApplications)
    {
        NSMutableDictionary *donneesApplication=[application sauveDansDictionnaire];
        [donneesApplication retain];
        [liste addObject:donneesApplication];
        [donneesApplication release];
    }
    [valeursParDefaut setObject:liste forKey:D_APPLICATIONS];    
    [liste release];

    [valeursParDefaut setObject:[NSNumber numberWithInteger:numAppliAActiver] forKey:D_APPLIAACTIVER];
    [valeursParDefaut setObject:[NSNumber numberWithInteger:typeDemarrage] forKey:D_TYPEDEMARRAGE];
    [valeursParDefaut setObject:[NSNumber numberWithBool:lancerFInder] forKey:D_LANCERFINDER];
    [valeursParDefaut setObject:[NSNumber numberWithBool:protection] forKey:D_PROTECTION];
    [valeursParDefaut setObject:motDePasse forKey:D_MOTDEPASSE];
    
    [prefs setObject:valeursParDefaut forKey:D_DEFAULTS];
    [prefs synchronize];
    
    [valeursParDefaut release];
    [prefs release];
}
@end
