//
//  MuralInstagram.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MuralInstagram : NSObject

@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)NSString * icon;
@property(nonatomic,strong)NSMutableDictionary * data;

//Data
@property(nonatomic,strong)NSString * username;
@property(nonatomic,strong)NSString * description;
@property(nonatomic,strong)NSString * image;


+(MuralInstagram *)getFromDictionary: (NSDictionary *)dict;

@end
