//
//  MuralBlogCell.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MuralBlogCell : UITableViewCell

@property(weak,nonatomic)IBOutlet UIImageView * imgViewIcon;
@property(weak,nonatomic) IBOutlet UILabel * lblBlogName;
@property(weak,nonatomic) IBOutlet UILabel * lblDate;
@property(weak,nonatomic) IBOutlet UIImageView * imgViewBlog;
@property(weak,nonatomic) IBOutlet UITextView * txtViewTitle;
@property(weak,nonatomic) IBOutlet UITextView * txtViewContent;

//Constraints
@property(nonatomic,retain)IBOutlet NSLayoutConstraint * constraintTitleHeight;
@property(nonatomic,retain)IBOutlet NSLayoutConstraint * constraintImgHeight;


@end
