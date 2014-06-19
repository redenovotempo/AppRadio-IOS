//
//  ProgramingItem.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 6/19/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "ProgramingItem.h"

@implementation ProgramingItem

+(ProgramingItem *)getFromDictionary: (NSDictionary *)dict{
    ProgramingItem * programingItem = [[ProgramingItem alloc] init];
    [programingItem setProgramingItemId:[dict objectForKey:@"id"]];
    [programingItem setProgram:[dict objectForKey:@"program"]];
    [programingItem setTime:[dict objectForKey:@"time"]];
    return programingItem;
}
@end
