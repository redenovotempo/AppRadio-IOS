//
//  MuralFacebookCell.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 2/9/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MuralFacebookCell : UITableViewCell


@property(weak,nonatomic)IBOutlet UIImageView * imgViewIcon;
@property(weak,nonatomic) IBOutlet UILabel * lblFacebookName;
@property(weak,nonatomic) IBOutlet UILabel * lblDate;
@property(weak,nonatomic) IBOutlet UIImageView * imgViewFacebook;
@property(weak,nonatomic) IBOutlet UITextView * txtViewContent;

//Constraints
@property(nonatomic,retain)IBOutlet NSLayoutConstraint * constraintImgHeight;


@end
