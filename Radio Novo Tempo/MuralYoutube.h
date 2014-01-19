//
//  MuralYoutube.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MuralYoutube : NSObject


@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)NSString * icon;
@property(nonatomic,strong)NSMutableArray * data;

//Data
@property(nonatomic,strong)NSString * channel;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)NSString * link;
@property(nonatomic,strong)NSString * image;
@property(nonatomic,strong)NSString * createdDate;


+(MuralYoutube *)getFromDictionary: (NSDictionary *)dict;

@end

