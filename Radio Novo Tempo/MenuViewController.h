//
//  MenuViewController.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/7/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MenuCell.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * menuArray;
}
@property (nonatomic,retain) IBOutlet UITableView * menuTableView;
@end
