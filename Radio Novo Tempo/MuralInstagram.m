//
//  MuralInstagram.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "MuralInstagram.h"



@implementation MuralInstagram
@synthesize description;

+(MuralInstagram *)getFromDictionary: (NSDictionary *)dict{
    
    MuralInstagram * muralInstagram = [[MuralInstagram alloc] init];
    
    [muralInstagram setType:[dict objectForKey:@"type"]];
    [muralInstagram setIcon:[dict objectForKey:@"icon"]];
    [muralInstagram setData:[dict objectForKey:@"data"]];
    [muralInstagram setUsername:[[muralInstagram.data objectAtIndex:0] objectForKey:@"username"]];
    [muralInstagram setDescription:[[muralInstagram.data objectAtIndex:0] objectForKey:@"description"]];
    [muralInstagram setImage:[[muralInstagram.data objectAtIndex:0] objectForKey:@"image"]];
    
     return muralInstagram;
}

@end
