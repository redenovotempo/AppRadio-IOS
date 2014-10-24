//
//  Person.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 3/2/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "Person.h"

@implementation Person
@synthesize description;


+(Person *)getFromDictionary: (NSDictionary *)dict{
    Person * person = [[Person alloc] init];
    [person set_id:[dict objectForKey:@"id"]];
    [person setCidadenatal:[dict objectForKey:@"cidadenatal"]];
    [person setConhecidocomo:[dict objectForKey:@"conhecidocomo"]];
    [person setDescription:[dict objectForKey:@"description"]];
    [person setEstadocivil:[dict objectForKey:@"estadocivil"]];
    [person setFamilia:[dict objectForKey:@"familia"]];
    [person setIdade:[dict objectForKey:@"idade"]];
    [person setImage:[dict objectForKey:@"image"]];
    [person setName:[dict objectForKey:@"name"]];
    [person setNaogostade:[dict objectForKey:@"naogostade"]];
    [person setNaosaidecasasem:[dict objectForKey:@"naosaidecasasem"]];
    [person setOndejatrabalhou:[dict objectForKey:@"ondejatrabalhou"]];
    [person setRadionovotempo:[dict objectForKey:@"radionovotempo"]];
    [person setSenaotrabalhassenanovotemposeria:[dict objectForKey:@"senaotrabalhassenanovotemposeria"]];
    [person setSuafuncaonaradiont:[dict objectForKey:@"suafuncaonaradiont"]];
    [person setUmadatainesquecivel:[dict objectForKey:@"umadatainesquecivel"]];
    [person setUmamusica:[dict objectForKey:@"umamusica"]];
    [person setUmaviagem:[dict objectForKey:@"umaviagem"]];
    [person setUmpresente:[dict objectForKey:@"umpresente"]];
    [person setUmrecadoparaosouvintes:[dict objectForKey:@"umrecadoparaosouvintes"]];
    [person setUmsonho:[dict objectForKey:@"umsonho"]];

    return person;
}

@end
