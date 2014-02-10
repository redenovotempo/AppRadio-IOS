//
//  MuralFacebook.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/17/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MuralFacebook : NSObject

@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)NSString * icon;
@property(nonatomic,strong)NSMutableDictionary * data;

//Data
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * message;
@property(nonatomic,strong)NSString * picture;
@property(nonatomic,strong)NSString * createdDate;
@property(nonatomic,strong)NSNumber * likes;



+(MuralFacebook *)getFromDictionary: (NSDictionary *)dict;

@end
