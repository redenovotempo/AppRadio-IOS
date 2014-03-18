//
//  MuralBlogCell.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "MuralBlogCell.h"

@implementation MuralBlogCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.btnShare = [[ArgButton alloc]init];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)likeAction:(id)sender{
    NSLog(@"liked!!");
}
-(IBAction)shareAction:(id)sender{
    NSLog(@"Shared!!");
}

@end
