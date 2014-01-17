//
//  MuralTwitter.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "MuralTwitter.h"

@implementation MuralTwitter

+(MuralTwitter *)getFromDictionary: (NSDictionary *)dict{
    
    MuralTwitter * muralTwitter = [[MuralTwitter alloc] init];
    
    [muralTwitter setType:[dict objectForKey:@"type"]];
    [muralTwitter setIcon:[dict objectForKey:@"icon"]];
    [muralTwitter setData:[dict objectForKey:@"data"]];
    [muralTwitter setName:[muralTwitter.data objectForKey:@"name"]];
    [muralTwitter setScreenName:[muralTwitter.data objectForKey:@"screenName"]];
    [muralTwitter setMessage:[muralTwitter.data objectForKey:@"message"]];
    [muralTwitter setCreatedDate:[muralTwitter.data objectForKey:@"createdDate"]];
    [muralTwitter setUrlsArray:[muralTwitter.data objectForKey:@"urls"]];
     
    return muralTwitter;
}

@end
