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
#import "MuralFacebook.h"
#import "MuralFacebookCell.h"
#import "MuralYoutubeCell.h"
#import "MuralTwitter.h"
#import "MuralBlog.h"
#import "MuralInstagram.h"
#import "MuralYoutube.h"
#import "MuralFacebook.h"
#import <SDWebImage/UIImageView+WebCache.h>





@interface MuralViewController : UIViewController<UITableViewDelegate,UITextViewDelegate, UITableViewDataSource, UIScrollViewDelegate,UIAlertViewDelegate >{
   
    NSMutableData  * urlData;

}


@property(nonatomic,strong)NSMutableArray * muralItensArray;
@property(nonatomic,strong)NSMutableArray * muralItensArray2;

@property (weak, nonatomic) IBOutlet UIButton *btnOpenMenu;
@property(nonatomic)BOOL needResetAnimation;

//Tabelas
@property(nonatomic,retain)IBOutlet UITableView * muralTableView;

@property (weak, nonatomic) IBOutlet UITableView *muralTableView2;

@property(nonatomic,retain)IBOutlet UIButton * playUiButton;



//Loading
@property(nonatomic,retain)IBOutlet UIImageView * imgLoading;
@property(nonatomic,retain)UIView * loadingView;
@property(nonatomic,retain)NSURLConnection * urlConnection;

//ContainView
@property(nonatomic,retain)IBOutlet UIView * containerView;



//menu
- (IBAction)OpenMenuButtonPressed:(id)button;


@end
