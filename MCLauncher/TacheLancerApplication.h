//
//  TacheLancerApplication.h
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 15/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "Tache.h"
#import "Application.h"

@interface TacheLancerApplication : Tache
{
    Application *application;
}

@property(readwrite, retain) Application *application;

@end
