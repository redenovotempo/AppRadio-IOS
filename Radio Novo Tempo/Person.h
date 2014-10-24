//
//  Person.h
//  Radio Novo Tempo
//
//  Created by MacMichas on 3/2/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject


@property(nonatomic,retain) NSNumber * _id;
@property(nonatomic,retain) NSString * cidadenatal;
@property(nonatomic,retain) NSString * conhecidocomo;
@property(nonatomic,strong) NSString * description;
@property(nonatomic,retain) NSString * estadocivil;
@property(nonatomic,retain) NSString * familia;
@property(nonatomic,retain) NSString * idade;
@property(nonatomic,retain) NSString * image;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * naogostade;
@property(nonatomic,retain) NSString * naosaidecasasem;
@property(nonatomic,retain) NSString * ondejatrabalhou;
@property(nonatomic,retain) NSString * radionovotempo;
@property(nonatomic,retain) NSString * senaotrabalhassenanovotemposeria;
@property(nonatomic,retain) NSString * suafuncaonaradiont;
@property(nonatomic,retain) NSString * umadatainesquecivel;
@property(nonatomic,retain) NSString * umamusica;
@property(nonatomic,retain) NSString * umaviagem;
@property(nonatomic,retain) NSString * umpresente;
@property(nonatomic,retain) NSString * umrecadoparaosouvintes;
@property(nonatomic,retain) NSString * umsonho;

+(Person *)getFromDictionary: (NSDictionary *)dict;

@end
