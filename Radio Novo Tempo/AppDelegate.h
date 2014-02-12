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
#import "AVFoundation/AVFoundation.h"
#import "PlayerViewController.h"
#import "MenuViewController.h"
#import "MMDrawerController.h"
#import "MuralViewController.h"
#import "FilosofiaViewController.h"
#import "Radio.h"



@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>{
    
    Reachability *internetReach;
    MPMoviePlayerController *player;
    BOOL locationExist;
    
}
@property(strong,nonatomic)MMDrawerController * drawerController;
@property (strong, nonatomic) UIWindow * window;
@property(nonatomic,assign)BOOL hasInternet;
@property(strong,nonatomic)Radio * radioCurrent;
@property(strong,nonatomic)NSMutableArray * globallistRadios;

-(BOOL)CheckInternetConnection;
-(void)InternetConnectionErrorMessage;
-(void)ChangeRootViewController:(NSString *)currentViewControllerName;

//GetRadioList
-(void)ExecuteMainAction;

//Core Location values
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

//player
@property (nonatomic, retain) MPMoviePlayerController *player;
@property(nonatomic,strong)UILabel * lblRadioName;
@property(nonatomic,assign)BOOL needReloadCurrentStreamUrl;
@property(nonatomic,assign)BOOL isPlayerStarted;

- (void) PlayAudio;
- (void) PauseAudio;
- (void) ChangePlayerStreamUrl: (NSString *) url;

@end