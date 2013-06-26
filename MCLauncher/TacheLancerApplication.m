//
//  TacheLancerApplication.m
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 15/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "TacheLancerApplication.h"

#import "CTI_Principal.h"

#import "globales.h"

@implementation TacheLancerApplication

@synthesize application;

-(id)init
{
    if (self = [super init])
    {
    }
    return self;
}


-(void)envoyerNotification:(NSString *)notif information:(id)info 
{
    NSNotification *uneNotif;
	
    uneNotif=[NSNotification notificationWithName:notif object:self userInfo:info];
	
    [[NSNotificationQueue defaultQueue]
     enqueueNotification: uneNotif
     postingStyle: NSPostNow
     coalesceMask: NSNotificationNoCoalescing
     forModes: nil];
}


-(void)executerTache:(id)unObjet
{
    if(!application)
        return;
    
    NSMutableDictionary *info;
    
    info=[[NSMutableDictionary alloc] init];
    [info setObject:[NSString stringWithFormat:@"Lancement de %@",[[application nom] stringByDeletingPathExtension]] forKey:@"ACTION"];
    [self envoyerNotification:D_NOTIF_TACHE information:info];
    [info release];
    
    [[NSWorkspace sharedWorkspace] launchApplication:[application cheminComplet] showIcon:NO autolaunch:NO];
    
    sleep(1);
    
    int delai=[application delaiApresLancement];
    for(int i=0;i<delai;i++)
    {
        info=[[NSMutableDictionary alloc] init];
        NSString *format;
        if(([application delaiApresLancement] - i)>1)
            format=@"Temporisation apres %@ : %d secondes restantes";
        else
            format=@"Temporisation apres %@ : %d seconde restante";
        
        [info setObject:[NSString stringWithFormat:format,[[application nom] stringByDeletingPathExtension],[application delaiApresLancement] - i] forKey:@"ACTION"];

        [self envoyerNotification:D_NOTIF_TACHE information:info];
        [info release];
        
        sleep(1);
    }
}

@end
