//
//  MenuItem.h
//  Radio Novo Tempo
//
//  Created by MacMichas on 2/23/15.
//  Copyright (c) 2015 Novo Tempo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * key;

-(instancetype)initWithKey:(NSString *)key AndTitle:(NSString *)title;

@end
