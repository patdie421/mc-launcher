//
//  CI_Preferences.m
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 13/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "CTI_Preferences.h"

#import "globales.h"

#import "DonneesPreferences.h"
#import "Application.h"

#define D_FINDERPLISTFILE @"~/Library/LaunchAgents/com.apple.Finder.plist"
#define D_DOCKPLISTFILE @"~/Library/LaunchAgents/com.apple.Dock.plist"

#define D_MonTypeDeDonnees @"MonTypeDeDonnees"
#define D_derniereAppli @"Dernière de la liste"

static NSString *c_preferences=@"Preferences";
int prev_pasLancerFinder;

@implementation CTI_Preferences

@synthesize donneesPreferences,pere;

- (void)dealloc
{
    [copieFondEcran release];
    [copieListeApplications release];
    [donneesPreferences release];
    [pere release];
    
	[super dealloc];
}


- (id) init
{
    if ((self = [super init]) != nil)
    {
		fenetre=nil;
    }
    return self;
}


- (void)awakeFromNib
{
    [table registerForDraggedTypes:[NSArray arrayWithObject:D_MonTypeDeDonnees]];
}


- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == table)
    {
        return [copieListeApplications count];
    }
    return 0;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
    id identifiantColonne;
    
    identifiantColonne=[tableColumn identifier];
    
    if (tableView == table)
    {
        Application *uneApplication=[copieListeApplications objectAtIndex:row];
        
        if([identifiantColonne isEqualToString:@"APPLI"]==YES)
            return [[uneApplication nom] stringByDeletingPathExtension];
        if([identifiantColonne isEqualToString:@"PATH"]==YES)
            return [uneApplication chemin];
        if([identifiantColonne isEqualToString:@"DELAI"]==YES)
            return [NSNumber numberWithInt:[uneApplication delaiApresLancement]];
        if([identifiantColonne isEqualToString:@"ICONE"]==YES)
            return [uneApplication icone];

        return NULL;
    }
    return NULL;
}


- (void)tableView:(NSTableView *)tableView 
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)tableColumn
              row:(int)row
{
    id identifiantColonne;
    
    identifiantColonne=[tableColumn identifier];

    if (tableView == table)
    {
        if([identifiantColonne isEqualToString:@"DELAI"]==YES)
        {
            Application *uneApplication=[copieListeApplications objectAtIndex:row];
            
            [uneApplication setDelaiApresLancement:[anObject intValue]];
        }
    }    
}


// drag operation stuff
- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)row toPasteboard:(NSPasteboard*)pastBoard
{
    // Copie du numéro de ligne dans le presse papier.
    // Ce numero de ligne est stocké dans un NSData
    NSData *indexLignesPourPressePapier = [NSKeyedArchiver archivedDataWithRootObject:row];
    
    [pastBoard declareTypes:[NSArray arrayWithObject:D_MonTypeDeDonnees] owner:self];
    [pastBoard setData:indexLignesPourPressePapier forType:D_MonTypeDeDonnees];
    
    return YES;
}


- (BOOL)tableView:(NSTableView *)tableView 
       acceptDrop:(id )info
              row:(NSInteger)row 
    dropOperation:(NSTableViewDropOperation)operation
{
    // On récupère le numéro de ligne qui a été stocké dans le presse papier
    NSPasteboard* pastBoard = [info draggingPasteboard];
    NSData* indexLignesDepuisPressePapier = [pastBoard dataForType:D_MonTypeDeDonnees];
    NSIndexSet* IndexesDesLignes = [NSKeyedUnarchiver unarchiveObjectWithData:indexLignesDepuisPressePapier];
    NSInteger ligneSource = [IndexesDesLignes firstIndex];
    
    // On déplace la ligne source vers la ligne cible
    // traitement différent si on insert avant ou après
    if (ligneSource < row)
    {
        // la source est après la ligne cible
        [copieListeApplications insertObject:[copieListeApplications objectAtIndex:ligneSource] atIndex:row];
        [copieListeApplications removeObjectAtIndex:ligneSource];
    }
    else
    {
        // la source est avant
        NSString *objTmp=[copieListeApplications objectAtIndex:ligneSource];
        [objTmp retain];
        [copieListeApplications removeObjectAtIndex:ligneSource];
        [copieListeApplications insertObject:objTmp atIndex:row];
        [objTmp release];
        
    }
    // on rafraichit l'affiche de la table
    [table noteNumberOfRowsChanged];
    [table reloadData];
    
    return YES;
}


- (NSDragOperation)tableView:(NSTableView*)tableView
                validateDrop:(id)info 
                 proposedRow:(NSInteger)row 
       proposedDropOperation:(NSTableViewDropOperation)op
{
    return NSDragOperationEvery;
}


- (void)windowWillClose:(NSNotification *)notification
{
	fenetre=nil;
}


- (void)afficher
{
	if(!fenetre)
	{
		if (![NSBundle loadNibNamed:c_preferences owner: self])
		{
			DEBUGNSLOG(@"Can't load Nib file %@",c_preferences);
			return;
		}
		else
		{
            // finalisation du parametrage de la fenetre
			[fenetre setReleasedWhenClosed:YES];
			[fenetre setDelegate:self];
		}
	}
    // copie de la liste des applications dans une table temporaire
    copieListeApplications=[[NSMutableArray alloc] initWithArray:[donneesPreferences listeApplications]];
    copieFondEcran=[[NSString alloc] initWithString:[donneesPreferences fondEcran]];
    
    // chargement de l'image
    NSImage *uneImage = [[NSImage alloc] initWithContentsOfFile:copieFondEcran];
    [uneImage setSize:[image frame].size];
    [image setImage:uneImage];
    [image setEditable:NO];
    [image setImageFrameStyle:NSImageFrameNone];
    [uneImage release];
    
    [check_pasLancerFinder setState:[donneesPreferences lancerFInder]];
    prev_pasLancerFinder=[check_pasLancerFinder state];
    [check_proctection setState:[donneesPreferences protection]];
    [radio_typeDemarrage selectCellWithTag:[donneesPreferences typeDemarrage]];
    [champ_mdp1 setStringValue:[donneesPreferences motDePasse]];
    [champ_mdp2 setStringValue:[donneesPreferences motDePasse]];
    [onglet selectTabViewItemAtIndex:0];
    
    [appliAActiver removeAllItems];
    [appliAActiver addItemWithTitle:D_derniereAppli];
    for(id appli in copieListeApplications)
        [appliAActiver addItemWithTitle:[[appli nom] stringByDeletingPathExtension]];
    [appliAActiver selectItemAtIndex:[donneesPreferences numAppliAActiver]];
    [self anim_boutons:nil];
	[fenetre makeKeyAndOrderFront:self];
}


- (IBAction)anim_boutons:(id)sender
{   
    if([[radio_typeDemarrage selectedCell] tag]==2)
    {
        [check_pasLancerFinder setEnabled:YES];
        [check_pasLancerFinder setState:prev_pasLancerFinder];
    }
	else
    {
        prev_pasLancerFinder=[check_pasLancerFinder state];
        [check_pasLancerFinder setEnabled:NO];
        [check_pasLancerFinder setState:NO];
    }
    
    if([check_proctection state] == YES)
    {
        [label_mdp1 setTextColor:[NSColor controlTextColor]];
        [label_mdp2 setTextColor:[NSColor controlTextColor]];
        [champ_mdp1 setEnabled:YES];
        [champ_mdp2 setEnabled:YES];
    }
    else
    {
        [label_mdp1 setTextColor:[NSColor disabledControlTextColor]];
        [label_mdp2 setTextColor:[NSColor disabledControlTextColor]];
        [champ_mdp1 setEnabled:NO];
        [champ_mdp2 setEnabled:NO];
    }
}


- (IBAction)bouton_choisir:(id)sender
{
    NSArray *listeDesTypes=[[NSArray alloc] initWithObjects:@"png",@"jpeg",@"jpg", nil]; 
    NSOpenPanel* selecteurDeFichier = [NSOpenPanel openPanel];
    
    [selecteurDeFichier setCanChooseFiles:YES];
    [selecteurDeFichier setCanChooseDirectories:NO];
    [selecteurDeFichier setCanCreateDirectories:NO];
    [selecteurDeFichier setAllowedFileTypes:listeDesTypes];
    [selecteurDeFichier setAllowsOtherFileTypes:YES];
    [selecteurDeFichier setDirectoryURL:[NSURL fileURLWithPath:[@"~/Pictures" stringByExpandingTildeInPath] isDirectory:YES]];
    
    [selecteurDeFichier setTitle:NSLocalizedString(@"Choisissez une image",nil)];
    
    if ( [selecteurDeFichier runModal] == NSOKButton )
    {
        [copieFondEcran release];
        copieFondEcran=[[NSString alloc] initWithString:[[[selecteurDeFichier URLs] objectAtIndex:0] path]];
        
        NSImage *uneImage = [[NSImage alloc] initWithContentsOfFile:copieFondEcran];
        [uneImage setSize:[image frame].size];
        [image setImage:uneImage];
        [image setEditable:NO];
        [image setImageFrameStyle:NSImageFrameNone];
        [uneImage release];
    }
    
    [listeDesTypes release];
}


- (IBAction)bouton_annuler:(id)sender
{
    [copieListeApplications release];
    [copieFondEcran release];
    
	[fenetre performClose:self];
}


- (IBAction)bouton_ok:(id)sender
{
    if([[champ_mdp1 stringValue] isEqualToString:[champ_mdp2 stringValue]])
        [donneesPreferences setMotDePasse:[champ_mdp1 stringValue]];
    else
    {
        if([check_proctection state]==YES)
        {
            [onglet selectTabViewItemAtIndex:1];

            NSRunAlertPanel(@"Mot de passe incorrecte",@"Resaissez votre mot de passe, il doit être identique dans les deux champs",@"OK",nil,nil);
            
            return;
        }
    }

    NSMutableArray *ct=[donneesPreferences listeApplications];
    [ct removeAllObjects];
    
    for(id i in copieListeApplications)
        [ct addObject:i];
    
    [donneesPreferences setNumAppliAActiver:[appliAActiver indexOfSelectedItem]];
    [donneesPreferences setFondEcran:copieFondEcran];
    [donneesPreferences setProtection:[check_proctection state]];
    
    NSInteger typeDem = [[radio_typeDemarrage selectedCell] tag];
    if([donneesPreferences typeDemarrage] != typeDem)
    {
        switch (typeDem)
        {
            case 1:
                [self unsetFinderPlist];
                [self unsetDockPlist];
                break;
            case 2:
                [self unsetFinderPlist];
                [self setDockPlist];
                break;
            case 3:
                [self unsetDockPlist];
                [self setFinderPlist];
                break;
            default:
                break;
        }
        [donneesPreferences setTypeDemarrage:typeDem];
    }
    
    NSInteger lancerFinder = [check_pasLancerFinder state];
    if(typeDem ==2)
        if(lancerFinder)
            [self setNoFinderDock];
        else
            [self unsetFinderPlist];

    [donneesPreferences setLancerFInder:lancerFinder];

    [donneesPreferences sauver];
    
    [pere update];
    
    [copieListeApplications release];
    [copieFondEcran release];
    
	[fenetre performClose:self];
}


- (IBAction)bouton_plus:(id)sender
{
    NSArray *listeDesTypes=[[NSArray alloc] initWithObjects:@"app", nil]; 

    NSOpenPanel* selecteurDeFichier = [NSOpenPanel openPanel];
    
    [selecteurDeFichier setCanChooseFiles:YES];
    [selecteurDeFichier setCanChooseDirectories:NO];
    [selecteurDeFichier setCanCreateDirectories:NO];
    [selecteurDeFichier setAllowedFileTypes:listeDesTypes];
    [selecteurDeFichier setAllowsOtherFileTypes:YES];
    [selecteurDeFichier setDirectoryURL:[NSURL fileURLWithPath:@"/Applications" isDirectory:YES]];
    [selecteurDeFichier setTitle:NSLocalizedString(@"Choisissez une application",nil)];
    
    if ( [selecteurDeFichier runModal] == NSOKButton )
    {
        NSString *fullpath=[[[selecteurDeFichier URLs] objectAtIndex:0] path];
        [fullpath retain];
        Application *uneApplication=[[Application alloc] init];
        [uneApplication setChemin:[fullpath stringByDeletingLastPathComponent]];
        [uneApplication setNom:[fullpath lastPathComponent]];
        [uneApplication setPremierPlan:NO];
        [uneApplication setDelaiApresLancement:0];

        
        NSImage *icone=[[NSWorkspace sharedWorkspace] iconForFile:[uneApplication cheminComplet]];
        [uneApplication setIcone:icone];
        [copieListeApplications addObject:uneApplication];
        
        [uneApplication release];
        
        [table reloadData];
        
        NSString *selection=[[NSString alloc] initWithString:[appliAActiver titleOfSelectedItem]];
        [appliAActiver removeAllItems];
        [appliAActiver addItemWithTitle:D_derniereAppli];
        for(id appli in copieListeApplications)
            [appliAActiver addItemWithTitle:[[appli nom] stringByDeletingPathExtension]];
        [appliAActiver selectItemWithTitle:selection];
        if(![appliAActiver selectedItem])
            [appliAActiver selectItemAtIndex:0];
        [selection release];
        
        [fullpath release];
    }
    
    [listeDesTypes release];
    
}


- (IBAction)bouton_moins:(id)sender
{
    int uneLigne = [table selectedRow];
	
	if(uneLigne > -1)
    {
        [copieListeApplications removeObjectAtIndex:uneLigne];
        [table reloadData];
        
        NSString *selection=[[NSString alloc] initWithString:[appliAActiver titleOfSelectedItem]];
        [appliAActiver removeAllItems];
        [appliAActiver addItemWithTitle:D_derniereAppli];
        for(id appli in copieListeApplications)
            [appliAActiver addItemWithTitle:[[appli nom] stringByDeletingPathExtension]];
        [appliAActiver selectItemWithTitle:selection];
        if(![appliAActiver selectedItem])
            [appliAActiver selectItemAtIndex:0];
        [selection release];

    }
}


- (void)setNoFinderDock
{
    NSString *plistDest=[D_FINDERPLISTFILE stringByExpandingTildeInPath];
    NSString *plistSource=@"/System/Library/LaunchAgents/com.apple.Finder.plist";
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistSource])
        plistSource=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"template.com.apple.Finder.plist"];
    
    [self setProgramForPlist:@"/usr/bin/true" pListSource:plistSource pListDest:plistDest disabled:NO];
}


- (void)unsetDockPlist
{
    [self unsetLibraryPlistFile:D_DOCKPLISTFILE];
}


- (void)setDockPlist
{
    NSString *mclauncher=[[NSString alloc] initWithString:[[NSBundle mainBundle] executablePath]];
    NSString *plistDest=[D_DOCKPLISTFILE stringByExpandingTildeInPath];
    NSString *plistSource=@"/System/Library/LaunchAgents/com.apple.Dock.plist";
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistSource])
        plistSource=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"template.com.apple.Dock.plist"];
    
    [self setProgramForPlist:mclauncher pListSource:plistSource pListDest:plistDest disabled:NO];
    [mclauncher release];
}


- (void)unsetFinderPlist
{
    [self unsetLibraryPlistFile:D_FINDERPLISTFILE];
}


- (void)setFinderPlist
{
    NSString *mclauncher=[[NSString alloc] initWithString:[[NSBundle mainBundle] executablePath]];
    NSString *plistDest=[D_FINDERPLISTFILE stringByExpandingTildeInPath];
    NSString *plistSource=@"/System/Library/LaunchAgents/com.apple.Finder.plist";
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistSource])
        plistSource=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"template.com.apple.Finder.plist"];

    [self setProgramForPlist:mclauncher pListSource:plistSource pListDest:plistDest disabled:NO];
    [mclauncher release];
}


- (void)setProgramForPlist:(NSString *)cheminProgram pListSource:(NSString *)plistSource pListDest:(NSString *)plistDest disabled:(BOOL)disabled
{
    NSString *error;
    NSString *errorDesc = nil;
    NSPropertyListFormat format;

    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistSource];
    id tmpPtr = [NSPropertyListSerialization propertyListFromData: plistXML
                                                 mutabilityOption: NSPropertyListMutableContainersAndLeaves
                                                           format: &format
                                                 errorDescription: &errorDesc ];
    NSMutableDictionary *donneesPlist=[[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)tmpPtr];
    
    // mise à jour des valeurs
    if(disabled==NO)
        [donneesPlist setValue:cheminProgram forKey:@"Program"];
    else
        [donneesPlist setValue:[NSNumber numberWithBool:YES] forKey:@"Disabled"];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:donneesPlist
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData)
        [plistData writeToFile:plistDest atomically:YES];
    
    [donneesPlist release];
}


- (void)unsetLibraryPlistFile:(NSString *)fichier
{
    // juste faire un rm du fichier
    NSString *plistLocalLibrayLaunchAgentPlist=[fichier stringByExpandingTildeInPath];
    
    [[NSFileManager defaultManager] removeItemAtPath:plistLocalLibrayLaunchAgentPlist error:nil];
}


@end
