//
//  AppDelegate.h
//  Radio Novo Tempo
//
//  Created by MacMichas on 10/20/13.
//  Copyright (c) 2013 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flurry.h"
#import "Reachability.h"
#import "MMDrawerController.h"
#import "PlayerViewController.h"
#import "MenuViewController.h"
#import "MMDrawerController.h"
#import "MuralViewController.h"
#import "AVFoundation/AVFoundation.h"


@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Reachability *internetReach;
    MPMoviePlayerController *player;
    
}
@property(strong,nonatomic)MMDrawerController * drawerController;
@property (strong, nonatomic) UIWindow * window;
@property(nonatomic,assign)BOOL hasInternet;

-(BOOL)CheckInternetConnection;
-(void)ChangeRootViewController:(NSString *)currentViewControllerName;

//player
@property (nonatomic, retain) MPMoviePlayerController *player;
@property(nonatomic,strong)UILabel * lblRadioName;
@property(nonatomic,assign)BOOL needReloadCurrentStreamUrl;
@property(nonatomic,assign)BOOL isPlayerStarted;

- (void) PlayAudio;
- (void) PauseAudio;
- (void) ChangePlayerStreamUrl: (NSString *) url;

@end