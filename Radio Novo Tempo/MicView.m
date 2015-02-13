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
    [NTStyleKit drawIconWithFrame:rect isPressed:_isPressed];
    
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//        self.isPressed = YES;
//        [self setNeedsDisplay];
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//        self.isPressed = NO;
//        [self setNeedsDisplay];
//}
//
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    self.isPressed = NO;
//    [self setNeedsDisplay];
//}
//
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [[event allTouches] anyObject];
//    if ([touch self ]) {
//        self.isPressed = YES;
//        [self setNeedsDisplay];
//    }else{
//        self.isPressed = NO;
//        [self setNeedsDisplay];
//    }
//    
//}



@end
