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
    [muralBlog setTitle:[muralBlog.data objectForKey:@"title"]];
    [muralBlog setDescription:[muralBlog.data objectForKey:@"description"]];
    [muralBlog setImage:[muralBlog.data objectForKey:@"image"]];
    [muralBlog setUrl:[muralBlog.data objectForKey:@"url"]];
    [muralBlog setCreatedDate:[muralBlog.data objectForKey:@"createdDate"]];
    
    return muralBlog;
}

@end
