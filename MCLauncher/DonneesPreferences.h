#import <Foundation/Foundation.h>

#import "globales.h"

@interface DonneesPreferences : NSObject
{
    NSString *fondEcran;
    NSMutableArray *listeApplications;
    NSInteger numAppliAActiver;
    NSInteger typeDemarrage;    
    BOOL lancerFInder;
    BOOL protection;
    NSString *motDePasse;
}

@property(readwrite, retain) NSString *fondEcran;
@property(readwrite, retain) NSMutableArray *listeApplications;
@property(readwrite) NSInteger numAppliAActiver;
@property(readwrite) NSInteger typeDemarrage;
@property(readwrite) BOOL lancerFInder;
@property(readwrite) BOOL protection;
@property(readwrite, retain) NSString *motDePasse;

- (void)charger;
- (void)sauver;

@end
