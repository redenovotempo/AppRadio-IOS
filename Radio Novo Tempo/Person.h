//
//  Person.h
//  Radio Novo Tempo
//
//  Created by MacMichas on 3/2/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject


@property(nonatomic,strong) NSNumber * _id;
@property(nonatomic,strong) NSString * cidadenatal;
@property(nonatomic,strong) NSString * conhecidocomo;
@property(nonatomic,strong) NSString * description;
@property(nonatomic,strong) NSString * estadocivil;
@property(nonatomic,strong) NSString * familia;
@property(nonatomic,strong) NSString * idade;
@property(nonatomic,strong) NSString * image;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * naogostade;
@property(nonatomic,strong) NSString * naosaidecasasem;
@property(nonatomic,strong) NSString * ondejatrabalhou;
@property(nonatomic,strong) NSString * radionovotempo;
@property(nonatomic,strong) NSString * senaotrabalhassenanovotemposeria;
@property(nonatomic,strong) NSString * suafuncaonaradiont;
@property(nonatomic,strong) NSString * umadatainesquecivel;
@property(nonatomic,strong) NSString * umamusica;
@property(nonatomic,strong) NSString * umaviagem;
@property(nonatomic,strong) NSString * umpresente;
@property(nonatomic,strong) NSString * umrecadoparaosouvintes;
@property(nonatomic,strong) NSString * umsonho;

+(Person *)getFromDictionary: (NSDictionary *)dict;

@end
