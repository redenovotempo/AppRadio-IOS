//
//  MiniPlayerViewController.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/18/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MiniPlayerViewController : UIViewController

@property(nonatomic,retain)IBOutlet UIButton * playButton;
@property(nonatomic,retain)IBOutlet UIButton * pauseButton;


- (IBAction)playButtonPressed:(id)button;
- (IBAction)pauseButtonPressed:(id)button;

@end
