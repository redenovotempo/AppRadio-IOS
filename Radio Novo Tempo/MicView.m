//
//  MicView.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 2/12/15.
//  Copyright (c) 2015 Novo Tempo. All rights reserved.
//

#import "MicView.h"
#import "NTStyleKit.h"

@implementation MicView

- (void)drawRect:(CGRect)rect {
    [NTStyleKit drawIconWithIsPressed:_isPressed];
}


@end
