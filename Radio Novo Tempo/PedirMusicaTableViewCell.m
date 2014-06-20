//
//  PedirMusicaTableViewCell.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 6/19/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "PedirMusicaTableViewCell.h"

@implementation PedirMusicaTableViewCell

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
    _textlbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];
    _numberlbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];
    _detaillbl.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
