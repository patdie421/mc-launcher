//
//  Consommateur.m
//  mesTest
//
//  Created by Patrice Dietsch on 17/09/07.
//

#import "Consommateur.h"
#import "File.h"

#import "Tache.h"

#define PD_DEBUG 1

/**************************************************/
/* Classe definissant un objet utilisé pour       */
/* arrêter le thread                              */
/**************************************************/
@interface Consommateur_demandeDArret : NSObject
{
}
- (void)arreter;
@end

@implementation Consommateur_demandeDArret
- (id)init
{
    return [super init];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)arreter
{
}
@end
/**************************************************/


@implementation Consommateur

@synthesize nom, fileDEntree, estEnCoursDExecution, doitSArreter, verrouSurTacheEnCoursDExecution;
@synthesize tachesEnCoursDExecution, synchroFinDeTache, infosComplementaires;


- (id)init
{
    return [self initWithFile:nil nom:@""];
}


- (id)initWithFile:(id)uneFile nom:unNom
{
	if (self = [super init])
	{
		[uneFile retain];
		[fileDEntree release];
		fileDEntree=uneFile;
		
		[unNom retain];
		[nom release];
		nom=unNom;
        
        estEnCoursDExecution=NO;
        doitSArreter=NO;
        verrouSurTacheEnCoursDExecution=[[NSLock alloc] init];
	}
	return self;
}


- (void)dealloc
{
	[nom release];
	[fileDEntree release];
    [verrouSurTacheEnCoursDExecution release];
    [tachesEnCoursDExecution release];
    [synchroFinDeTache release];
    [infosComplementaires release];
    
	[super dealloc];
}


+ (void)consommateur:(id)unConsommateur
{
    id unElem;
    id uneFile;
    char sortie;
    int i;
    NSString *unNom;
    NSInteger compteurCondition;
    
    NSMutableDictionary *tachesEnCoursDExecution;
    NSLock *verrouSurTacheEnCoursDExecution;
    NSConditionLock *synchroFinDeTache;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	uneFile=[unConsommateur fileDEntree];
	if(uneFile==nil)
    {
        [pool release];
		return;
    }
	[uneFile retain];
    
	unNom=[unConsommateur nom];
	[unNom retain];
    
    tachesEnCoursDExecution=[unConsommateur tachesEnCoursDExecution];
    if(tachesEnCoursDExecution)
        [tachesEnCoursDExecution retain];
    
    verrouSurTacheEnCoursDExecution=[unConsommateur verrouSurTacheEnCoursDExecution];
    if(verrouSurTacheEnCoursDExecution)
        [verrouSurTacheEnCoursDExecution retain];
    
    synchroFinDeTache=[unConsommateur synchroFinDeTache];
    if(synchroFinDeTache)
        [synchroFinDeTache retain];
    
    [unConsommateur setEstEnCoursDExecution:YES];
    
	NSLog(@"Debut Consommateur %s\n",[unNom UTF8String]);	
	sortie=0;
	i=0;
	while(!sortie)
	{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
		unElem=[uneFile outWithLockAndTimeOut:10];
        if(unElem)
        {
            [unElem retain];
            
            if([unElem respondsToSelector: @selector (executerTache:)] )
            {
                NSString *idTache;
                @try
                {
                    if(tachesEnCoursDExecution && verrouSurTacheEnCoursDExecution)
                    {
                        
                        idTache=[NSString stringWithFormat:@"%@-%d",unNom,i];
                        [idTache retain];
                        
                        [verrouSurTacheEnCoursDExecution lock];
                        [tachesEnCoursDExecution setObject:unElem forKey:idTache];
                        [verrouSurTacheEnCoursDExecution unlock];
                        
                        [unElem executerTache:unConsommateur];
                        
                        [verrouSurTacheEnCoursDExecution lock];
                        [tachesEnCoursDExecution removeObjectForKey:idTache];
                        [verrouSurTacheEnCoursDExecution unlock];
                        
                        [idTache release];
                    }
                    else
                        [unElem executerTache:unConsommateur];
                }
                @catch (NSException * e)
                {
                    [idTache release];
                    NSLog(@"%@ : Execution error !",unNom);
                }
                i++;
            }
            else
            {
                if([unElem respondsToSelector: @selector (arreter)] )
                    sortie=1;
                else
                    NSLog(@"Warning : incorrect object recieved! Skip object.");
            }
            
            [unElem release];
        }
        else
        {
            if([unConsommateur doitSArreter])
                sortie=1;
        }
        
        
        [pool release];
    }
	NSLog(@"Fin Consommateur %s\n",[unNom UTF8String]);
    
    [unConsommateur setEstEnCoursDExecution:NO];
    
    if(synchroFinDeTache)
    {
        [synchroFinDeTache lock];
        compteurCondition=[synchroFinDeTache condition];
        compteurCondition--;
        [synchroFinDeTache unlockWithCondition:compteurCondition];
        [synchroFinDeTache release];
    }
    
    if(tachesEnCoursDExecution)
        [tachesEnCoursDExecution release];
    
    if(verrouSurTacheEnCoursDExecution)
        [verrouSurTacheEnCoursDExecution release];
    
    [unNom release];
    [uneFile release];
    
	[pool release];
}


- (void)run
{
	[NSThread detachNewThreadSelector:@selector(consommateur:) toTarget:[Consommateur class] withObject:self];	
}


- (void)arreter
{
    id demandeDArret;
    
    demandeDArret=[[Consommateur_demandeDArret alloc] init];
    
    [fileDEntree inWithLock:demandeDArret];
    
    [demandeDArret release];
    
    doitSArreter=YES;
}

@end
