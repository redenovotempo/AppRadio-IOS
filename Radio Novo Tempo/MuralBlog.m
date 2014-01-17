//
//  MuralBlog.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "MuralBlog.h"

@implementation MuralBlog

+(MuralBlog *)getFromDictionary: (NSDictionary *)dict{
    
    MuralBlog * muralBlog = [[MuralBlog alloc] init];
    
    [muralBlog setType:[dict objectForKey:@"type"]];
    [muralBlog setIcon:[dict objectForKey:@"icon"]];
    [muralBlog setData:[dict objectForKey:@"data"]];
    [muralBlog setTitle:[dict objectForKey:@"title"]];
    [muralBlog setDescription:[dict objectForKey:@"description"]];
    [muralBlog setImage:[dict objectForKey:@"image"]];
    [muralBlog setUrl:[dict objectForKey:@"url"]];
    [muralBlog setCreatedDate:[dict objectForKey:@"createdDate"]];
    
    return muralBlog;
}

@end
