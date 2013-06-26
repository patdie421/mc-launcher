//
//  BarreDeProgression.h
//  MCDisplayImage
//
//  Created by Patrice DIETSCH on 19/06/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Progression : NSObject
{
    IBOutlet id view;
    IBOutlet id barre;
    IBOutlet id texte;
    int cptr;
    int max;
}

@property(readwrite) int cptr;
@property(readwrite) int max;

- (id) view;
- (void) demarrer;
- (void)arreter;

@end
