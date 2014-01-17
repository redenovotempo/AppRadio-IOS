//
//  MuralFacebook.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/17/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "MuralFacebook.h"

@implementation MuralFacebook

+(MuralFacebook *)getFromDictionary: (NSDictionary *)dict{
    
    MuralFacebook * muralFacebook = [[MuralFacebook alloc] init];
    
    [muralFacebook setType:[dict objectForKey:@"type"]];
    [muralFacebook setIcon:[dict objectForKey:@"icon"]];
    [muralFacebook setData:[dict objectForKey:@"data"]];
    [muralFacebook setName:[dict objectForKey:@"name"]];
    [muralFacebook setMessage:[dict objectForKey:@"message"]];
    [muralFacebook setPicture:[dict objectForKey:@"picture"]];
    [muralFacebook setCreatedDate:[dict objectForKey:@"createdDate"]];
    [muralFacebook setLikes:[dict objectForKey:@"likes"]];
    
    return muralFacebook;
}


@end
