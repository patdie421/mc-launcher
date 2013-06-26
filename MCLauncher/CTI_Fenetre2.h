//
//  CTI_Fenetre2.h
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 15/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTI_Fenetre2 : NSObject
{
    id fenetre;
    id imageView;
    
    NSString *path_image;
}

- (void)afficherSurEcran:(NSScreen *)ecran;
- (void)fermer;
- (void)fullScreen:(NSScreen *)ecran;
- (void)endFullScreen;
- (void)makeFront;
- (void)update;

@property(readwrite, retain) NSString *path_image;

- (void)addSubView:(id) view;
- (NSWindow *)fenetre;

@end
