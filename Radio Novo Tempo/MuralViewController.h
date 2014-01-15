//
//  MuralViewController.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/12/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MuralTwitterCell.h"
#import "MuralBlogCell.h"
#import "MuralInstagramCell.h"
#import "MuralYoutubeCell.h"
#import "AppDelegate.h"

@interface MuralViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

}
@property(nonatomic,retain)IBOutlet UITableView * muralTableView;

//menu
- (IBAction)OpenMenuButtonPressed:(id)button;

@end
