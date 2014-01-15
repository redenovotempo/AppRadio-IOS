//
//  Radio.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "Radio.h"

@implementation Radio

+(Radio *)getFromDictionary: (NSDictionary *)dict{
    Radio * radio = [[Radio alloc] init];
    [radio setRadioId:[dict objectForKey:@"radioId"]];
    [radio setName:[dict objectForKey:@"name"]];
    [radio setStreamIOS:[dict objectForKey:@"streamIOS"]];
    [radio setStreamAndroid:[dict objectForKey:@"streamAndroid"]];
    [radio setLatitude:[dict objectForKey:@"latitude"]];
    [radio setLongitude:[dict objectForKey:@"longitude"]];
    [radio setLanguage:[dict objectForKey:@"language"]];
    [radio setApiLink:[dict objectForKey:@"apiLink"]];
    return radio;
}
@end
