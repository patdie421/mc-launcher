//
//  CTI_Fenetre2.m
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 15/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "CTI_Fenetre2.h"
#import "globales.h"

@implementation CTI_Fenetre2

@synthesize path_image;

- (void)dealloc
{
    [imageView release];
    [fenetre release];
    
    [path_image release];

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
}


- (NSWindow *)fenetre
{
    return fenetre;
}


- (void)afficherSurEcran:(NSScreen *)ecran
{
    if(!fenetre)
	{
        fenetre = [[ NSWindow alloc] initWithContentRect:[ecran frame] 
                                                styleMask:NSBorderlessWindowMask
                                                  backing:NSBackingStoreBuffered
                                                    defer:NO
                                                   screen:ecran];
        imageView=[[NSImageView alloc] init];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:path_image];
        
        [image setSize:NSMakeSize([ecran frame].size.width,[ecran frame].size.height)];
        [imageView setFrame:NSMakeRect(0,0,[ecran frame].size.width,[ecran frame].size.height)];
        [imageView setImage:image];
        [[fenetre contentView] addSubview: imageView];
        
        [image release];
    }
    [fenetre makeKeyAndOrderFront:self];
}


- (void)fermer
{
    [fenetre close];
}


- (void)fullScreen:(NSScreen *)ecran
{
    [[fenetre contentView] enterFullScreenMode:ecran withOptions:nil];
}


- (void)endFullScreen
{
    [[fenetre contentView] exitFullScreenModeWithOptions:nil];
}


- (void)makeFront
{
    [fenetre makeKeyAndOrderFront:nil];
}


- (void)addSubView:(id) view
{
    [[fenetre contentView] addSubview: view];    
}


- (void)update
{
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path_image];
    
    [image setSize:NSMakeSize([imageView frame].size.width,[imageView frame].size.height)];
    [imageView setImage:image];
    
    [image release];
}


@end
