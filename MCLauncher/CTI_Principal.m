//
//  CI_Principal.m
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 13/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "globales.h"

#import "CTI_Principal.h"
#import "CTI_Fenetre2.h"
#import "CTI_Preferences.h"
#import "PopupPIN.h"
#import "Progression.h"

#import "File.h"
#import "Consommateur.h"
#import "Application.h"
#import "TacheLancerApplication.h"


void PostMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point) 
{
    CGEventRef theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
    CGEventSetType(theEvent, type);
    CGEventPost(kCGHIDEventTap, theEvent);
    CFRelease(theEvent);
}

void LeftClick(const CGPoint point) 
{
    PostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, point);
    PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, point);
    PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, point);
}


/**************************************************/
/* Classe definissant un objet privé utilisé pour */
/* déclancher une "Tache" à la fin du lancement   */
/* des applications                               */
/**************************************************/
@interface QuitterFS : Tache
{
    NSArray *listeFenetres;
    Progression *progression;
    Application *appliAActiver;
    NSArray *listeApplications;
}
@property(readwrite, retain) NSArray *listeFenetres;
@property(readwrite, retain) Progression *progression;
@property(readwrite, retain) Application *appliAActiver;
@property(readwrite, retain) NSArray *listeApplications;

@end

@implementation QuitterFS

@synthesize listeFenetres,progression,appliAActiver,listeApplications;


-(void)executerTache:(id)unObjet
{
    [progression arreter];
    [[progression view] removeFromSuperview];

    for(id i in listeApplications)
    {
        if(i!=appliAActiver)
            [i masquer];
    }

//    sleep(1);
    
    for(CTI_Fenetre2 *f in listeFenetres)
    {
        [f endFullScreen];
        [f fermer];
    }
     
    if(appliAActiver)
        [appliAActiver activer];

    [NSCursor unhide];
}
@end
/**************************************************/


@implementation CTI_Principal

@synthesize last;

- (BOOL)donnerAcces
{
    if([donneesPreferences protection])
    {
        if(!popupPIN)
        {
            popupPIN=[[PopupPIN alloc] init];
        }
        if([popupPIN afficher]==NO)
            return NO;
        else
        {
            if([[donneesPreferences motDePasse] isEqualToString:[popupPIN motDePasse]])
                return YES;
            else
                return NO;
        }
    }
    else
        return YES;
}


- (void)dealloc
{
    [CTI_preferences release];
    [donneesPreferences release];
    [listeFenetres release];
    
	[super dealloc];
}


- (void)ajouterProgression:(Progression *)uneProgression alaFenetre:(CTI_Fenetre2 *)uneFenetre
{
    NSView *vprogression=[uneProgression view];
    NSWindow *wfenetre=[uneFenetre fenetre];
    
    CGFloat l1=[vprogression frame].size.width;
    CGFloat l2=[wfenetre frame].size.width;
    CGFloat l=(l2 - l1)/2;
    
    CGFloat h1=[vprogression frame].size.height;
    CGFloat h2=[wfenetre frame].size.height;
    CGFloat h=(h2-h1)/3;
    
    NSRect nrect=[vprogression frame];
    nrect.origin.x=l;
    nrect.origin.y=h;
    [vprogression setFrame:nrect];
    
    [uneFenetre addSubView:vprogression];        
}


- (void)ouvrirFenetres
{
    listeFenetres=[[NSMutableArray alloc] init];
    NSArray *listeEcrans=[NSScreen screens];
    for(id ecran in listeEcrans)
    {
        CTI_Fenetre2 *uneFenetre=[[CTI_Fenetre2 alloc] init];
        
        [uneFenetre setPath_image:[donneesPreferences fondEcran]];
        [listeFenetres addObject:uneFenetre];
        [uneFenetre afficherSurEcran:ecran];
        [uneFenetre fullScreen:ecran];
        [uneFenetre release];
    }    
}


- (void)afficherProgression:(NSArray *)listeApplications
{
    int max=0;

    progression=[[Progression alloc] init];
    [self ajouterProgression:progression alaFenetre:[listeFenetres objectAtIndex:0]];

    for(Application * app in listeApplications)
        max=max+[app delaiApresLancement];
    
    max=max+[listeApplications count];

    [progression setMax:max-1];
    [progression demarrer];
}


- (void)lancerOrdonnanceur
{
    fileTaches=[[File alloc] init];
    ordonnanceur=[[Consommateur alloc] initWithFile:fileTaches nom:@"Lanceur"];
    [ordonnanceur run];
}


- (void)ordonnancerApplications:(NSArray *)listeApplications
{
    TacheLancerApplication *uneTache;

    for(int i=0;i<[listeApplications count];i++)
    {
        uneTache=[[TacheLancerApplication alloc] init];
        [uneTache setApplication:[listeApplications objectAtIndex:i]];
        [fileTaches inWithLock:uneTache];
        [uneTache release];
    }

}

-(void)setWallpaper
{
    NSWorkspace *sws =[NSWorkspace sharedWorkspace];
    NSURL *image =[NSURL fileURLWithPath:[donneesPreferences fondEcran]];
    NSError *err = nil;
    for(NSScreen *screen in [NSScreen screens])
    {
        NSDictionary *opt =[sws desktopImageOptionsForScreen:screen]; // option à revoir ...
        [sws setDesktopImageURL:image forScreen:screen options:opt error:&err];
        if(err)
        {
            NSLog(@"%@",[err localizedDescription]);
        }
    }
}


- (void)start
{
    NSArray *listeApplications = [donneesPreferences listeApplications];
    if([listeApplications count])
    {
        [NSCursor hide];
        
        // [self setWallpaper];
        [self ouvrirFenetres];
        
        [self afficherProgression:listeApplications];
        
        // lacement des applications];
        [self ordonnancerApplications:listeApplications];
        
        // création d'une tache "spéciale" lancée pour arrêter le mode plein écran
        QuitterFS *finFS = [[QuitterFS alloc] init];
        
        if([donneesPreferences numAppliAActiver]>0)
            [finFS setAppliAActiver:[listeApplications objectAtIndex:[donneesPreferences numAppliAActiver]-1]];
        else
            [finFS setAppliAActiver:nil];
        
        [finFS setListeFenetres:listeFenetres];
        [finFS setProgression:progression];
        [finFS setListeApplications:listeApplications];
        
        [fileTaches inWithLock:finFS];
        
        [finFS release];
    }
}


- (void)awakeFromNib
{
    /*
     * chargement des préférences
     */
    donneesPreferences=[[DonneesPreferences alloc] init];
    [donneesPreferences charger];

    // lancer Ordonnanceur
    [self lancerOrdonnanceur];

    [self start];
}


- (void) update
{
    for(id fenetre in listeFenetres)
    {
        [fenetre setPath_image:[donneesPreferences fondEcran]];
        [fenetre update];
    }
}


- (IBAction)startall:(id)sender
{
    [self start];
}


- (IBAction)menu_preferences:(id)sender
{
    if([self donnerAcces])
    {
        if(!CTI_preferences)
        {
            CTI_preferences=[[CTI_Preferences alloc] init];
            [CTI_preferences setDonneesPreferences:donneesPreferences];
            [CTI_preferences setPere:self];
        }
        [CTI_preferences afficher];
    }
}


- (IBAction)menu_terminal:(id)sender
{
    if([self donnerAcces])
        [[NSWorkspace sharedWorkspace] launchApplication:@"/Applications/Utilities/Terminal.app"];
}


@end
