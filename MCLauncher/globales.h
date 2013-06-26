//
//  general.h
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 13/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//
#import <Cocoa/Cocoa.h>

extern NSString *c_defaults;
#define D_DEFAULTS c_defaults

#define D_FONDECRAN @"fond_ecran"
#define D_APPLICATIONS @"applications"
#define D_NOM @"NOM"
#define D_CHEMIN @"CHEMIN"
#define D_DELAI @"DELAI"
#define D_TYPEDEMARRAGE @"TYPEDEMARRAGE"
#define D_LANCERFINDER @"LANCERFINDER"
#define D_PROTECTION @"PROTECTION"
#define D_MOTDEPASSE @"NOTDEPASSE"
#define D_APPLIAACTIVER @"APPLIAACTIVER"

extern NSString *c_notif_tache;
#define D_NOTIF_TACHE c_notif_tache

#define D_DEBUG 1
#ifdef D_DEBUG
#define DEBUGNSLOG(...) NSLog(__VA_ARGS__)
#else
#define DEBUGNSLOG(...)
#endif
