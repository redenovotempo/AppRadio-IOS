//
//  MuralBlog.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MuralBlog : NSObject

@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)NSString * icon;
@property(nonatomic,strong)NSMutableDictionary * data;

//Data
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * description;
@property(nonatomic,strong)NSString * image;
@property(nonatomic,strong)NSString * url;
@property(nonatomic,strong)NSString * createdDate;


+(MuralBlog *)getFromDictionary: (NSDictionary *)dict;

@end
