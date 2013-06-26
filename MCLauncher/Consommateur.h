//
//  Consommateur.h
//  mesTest
//
//  Created by Patrice Dietsch on 17/09/07.
//

#import <Cocoa/Cocoa.h>
#import "File.h"

@interface Consommateur : NSObject
{
	NSString *nom;
    
	File *fileDEntree;
    
    BOOL estEnCoursDExecution;
    BOOL doitSArreter;
    
    NSLock *verrouSurTacheEnCoursDExecution;
    NSMutableDictionary *tachesEnCoursDExecution;
    
    NSConditionLock *synchroFinDeTache;
    
    id infosComplementaires;
}

@property(readonly) NSString *nom;
@property(readwrite, retain) File *fileDEntree;
@property(readwrite) BOOL estEnCoursDExecution;
@property(readwrite) BOOL doitSArreter;
@property(readwrite, retain) NSLock *verrouSurTacheEnCoursDExecution;
@property(readwrite, retain) NSMutableDictionary *tachesEnCoursDExecution;
@property(readwrite, retain) NSConditionLock *synchroFinDeTache;
@property(readwrite, retain) id infosComplementaires;

+ (void)consommateur:(id)instanceDeConsommateur;

- (id)initWithFile:(id)uneFile nom:unNom;

- (void)run;
- (void)arreter;

@end