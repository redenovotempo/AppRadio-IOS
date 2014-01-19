//
//  MuralYoutube.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "MuralYoutube.h"

@implementation MuralYoutube

+(MuralYoutube *)getFromDictionary: (NSDictionary *)dict{
    
    MuralYoutube * muralYoutube = [[MuralYoutube alloc] init];
    
    [muralYoutube setType:[dict objectForKey:@"type"]];
    [muralYoutube setIcon:[dict objectForKey:@"icon"]];
    [muralYoutube setData:[dict objectForKey:@"data"]];
    [muralYoutube setChannel:[[muralYoutube.data objectAtIndex:0] objectForKey:@"channel"]];
    [muralYoutube setTitle:[[muralYoutube.data objectAtIndex:0] objectForKey:@"title"]];
    [muralYoutube setContent:[[muralYoutube.data objectAtIndex:0] objectForKey:@"content"]];
    [muralYoutube setImage:[[muralYoutube.data objectAtIndex:0] objectForKey:@"image"]];
    [muralYoutube setCreatedDate:[[muralYoutube.data objectAtIndex:0] objectForKey:@"createdDate"]];
    
    return muralYoutube;
}

@end
