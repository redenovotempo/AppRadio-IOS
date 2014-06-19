//
//  ProgramacaoTableViewCell.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 6/18/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "ProgramacaoTableViewCell.h"

@interface ProgramacaoTableViewCell ()


@end

@implementation ProgramacaoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    _textlbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];
    _timelbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
