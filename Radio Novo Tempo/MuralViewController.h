//
//  MuralViewController.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/12/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MuralTwitterCell.h"
#import "MuralBlogCell.h"
#import "MuralInstagramCell.h"
#import "MuralYoutubeCell.h"
#import "MuralTwitter.h"
#import "MuralBlog.h"
#import "MuralInstagram.h"
#import "MuralYoutube.h"
#import "MuralFacebook.h"
#import <SDWebImage/UIImageView+WebCache.h>




@interface MuralViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
   
    NSMutableArray * muralItensArray;

}

@property(nonatomic,retain)IBOutlet UITableView * muralTableView;
@property(nonatomic,retain)IBOutlet UIButton * playUiButton;

//menu
- (IBAction)OpenMenuButtonPressed:(id)button;

@end
