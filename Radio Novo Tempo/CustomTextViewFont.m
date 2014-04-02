//
//  CustomTextViewFont.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 4/1/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "CustomTextViewFont.h"

@implementation CustomTextViewFont

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [super awakeFromNib]; self.font = [UIFont fontWithName:@"ProximaNova-Light" size:self.font.pointSize];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
