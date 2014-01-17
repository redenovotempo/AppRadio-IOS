//
//  MuralTwitter.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MuralTwitter : NSObject


@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)NSString * icon;
@property(nonatomic,strong)NSMutableDictionary * data;

//Data
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * screenName;
@property(nonatomic,strong)NSString * message;
@property(nonatomic,strong)NSString * createdDate;
@property(nonatomic,strong)NSMutableArray * urlsArray;

//Urls
//@property(nonatomic,strong)NSMutableArray * hashtags;
//@property(nonatomic,strong)NSMutableArray * symbols;
//@property(nonatomic,strong)NSMutableArray * urls;
//@property(nonatomic,strong)NSMutableArray * user_mentions;


+(MuralTwitter *)getFromDictionary: (NSDictionary *)dict;



@end
