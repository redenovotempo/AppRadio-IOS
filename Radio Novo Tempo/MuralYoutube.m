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
    [muralYoutube setChannel:[dict objectForKey:@"channel"]];
    [muralYoutube setTitle:[dict objectForKey:@"title"]];
    [muralYoutube setContent:[dict objectForKey:@"content"]];
    [muralYoutube setImage:[dict objectForKey:@"image"]];
    [muralYoutube setCreatedDate:[dict objectForKey:@"createdDate"]];
    
    return muralYoutube;
}

@end
