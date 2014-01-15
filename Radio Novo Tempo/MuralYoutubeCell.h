//
//  MuralYoutubeCell.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/14/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MuralYoutubeCell : UITableViewCell

@property(weak,nonatomic) IBOutlet UIImageView * imgViewIcon;
@property(weak,nonatomic) IBOutlet UILabel * lblDate;
@property(weak,nonatomic) IBOutlet UIImageView * imgViewImage;
@property(weak,nonatomic) IBOutlet UITextView * txtviewContentTitle;
@property(weak,nonatomic) IBOutlet UITextView * txtViewContent;

@end
