//
//  Radio.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Radio : NSObject{

}


@property(nonatomic,strong) NSNumber * radioId;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * streamIOS;
@property(nonatomic,strong) NSString * streamAndroid;
@property(nonatomic,strong) NSString * latitude;
@property(nonatomic,strong) NSString * longitude;
@property(nonatomic,strong) NSString * language;
@property(nonatomic,strong) NSString * apiLink;
@property(nonatomic,strong) NSString * emailContact;


+(Radio *)getFromDictionary: (NSDictionary *)dict;


@end
