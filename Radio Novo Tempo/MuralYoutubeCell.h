//
//  MuralYoutubeCell.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArgButton.h"

@interface MuralYoutubeCell : UITableViewCell

@property(weak,nonatomic) IBOutlet UIImageView * imgViewIcon;
@property(weak,nonatomic) IBOutlet UILabel * lblDate;
@property(weak,nonatomic) IBOutlet UIImageView * imgViewImage;
@property(weak,nonatomic) IBOutlet ArgButton * btnActionExecute;
@property(weak,nonatomic) IBOutlet UITextView * txtViewTitle;
@property(weak,nonatomic) IBOutlet UITextView * txtViewContent;

//Constraints
@property(nonatomic,retain)IBOutlet NSLayoutConstraint * constraintTitleHeight;

@end
