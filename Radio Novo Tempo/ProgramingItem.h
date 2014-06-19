//
//  ProgramingItem.h
//  Radio Novo Tempo
//
//  Created by MacMichas on 6/19/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgramingItem : NSObject

@property(nonatomic,strong) NSNumber * programingItemId;
@property(nonatomic,strong) NSString * program;
@property(nonatomic,strong) NSString * time;


+(ProgramingItem *)getFromDictionary: (NSDictionary *)dict;


@end
