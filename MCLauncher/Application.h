//
//  Application.h
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 16/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Application : NSObject
{
    NSString *nom;
    NSString *chemin;
    NSImage *icon;
    BOOL premierPlan;
    unsigned int delaiApresLancement;
}

@property(readwrite) BOOL premierPlan;
@property(readwrite) unsigned int delaiApresLancement;
@property(readwrite, retain) NSString *nom;
@property(readwrite, retain) NSString *chemin;
@property(readwrite, retain) NSImage *icone;

- (NSString *)cheminComplet;
- (void)activer;
- (NSMutableDictionary *)sauveDansDictionnaire;
- (void)chargeDepuisDictionnaire:(NSMutableDictionary *)d;
- (void)masquer;

@end
