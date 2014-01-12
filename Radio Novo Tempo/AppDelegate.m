//
//  AppDelegate.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 10/20/13.
//  Copyright (c) 2013 Novo Tempo. All rights reserved.
//
 
#import "AppDelegate.h"


@implementation AppDelegate
@synthesize player;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //Trocando a cor da barra de status
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Autorizando o GPS a iniciar uma localização.
    self.needReloadCurrentStreamUrl = YES;
    self.lblRadioName = [[UILabel alloc]init];
    
    
    
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"RZ23YG9WW7W854NX454T"];
    
    
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    
    MenuViewController * menu = (MenuViewController*)[mainStoryboard
                                                          instantiateViewControllerWithIdentifier: @"Menu"];

    PlayerViewController * main = (PlayerViewController*)[mainStoryboard
                                                        instantiateViewControllerWithIdentifier: @"Player"];

    
    self.drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:main
                                             leftDrawerViewController:menu
                                             rightDrawerViewController:nil];
    
    
    self.drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeFull;
    
    self.window.rootViewController = self.drawerController;
    
    
    //player
    [self CreatePlayer];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    


}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)CheckInternetConnection{
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    
    switch (netStatus){
        case ReachableViaWWAN:{
            _hasInternet=YES;
            break;
        }
        case ReachableViaWiFi:{
            _hasInternet=YES;
            break;
        }
        case NotReachable:{
            _hasInternet=NO;
            break;
        }
    }
    
    return _hasInternet;
}

-(void)ChangeRootViewController:(NSString *)currentViewControllerName{
    
    //Encontrando Storyboard
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                              bundle: nil];
 
    //Definindo ViewControlle de menu, sempre do lado esquerdo.
    MenuViewController * menu = (MenuViewController*)[mainStoryboard
                                                      instantiateViewControllerWithIdentifier: @"Menu"];
  
    //Mural
    if ([currentViewControllerName isEqualToString:@"Mural"]) {
        MuralViewController * current = (MuralViewController*)[mainStoryboard
                                                               instantiateViewControllerWithIdentifier:currentViewControllerName];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:current
                                 leftDrawerViewController:menu
                                 rightDrawerViewController:nil];
    }
    
    //Main
    if ([currentViewControllerName isEqualToString:@"Player"]) {
        PlayerViewController * current = (PlayerViewController*)[mainStoryboard
                                                               instantiateViewControllerWithIdentifier:currentViewControllerName];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:current
                                 leftDrawerViewController:menu
                                 rightDrawerViewController:nil];
    }
    
    
    
    //Habilitando interaçao do usuario na viewcontroller aberta.
    self.drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeFull;
    
    //Abrindo a side para manter o efeito de fechamento.
    [self.drawerController openDrawerSide:MMDrawerSideLeft animated:NO completion:^(BOOL finished){
        self.window.rootViewController = self.drawerController;
        [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }];
}

- (void)PlayAudio {
    [player play];
    self.isPlayerStarted = YES;
}

- (void)PauseAudio {
    [player pause];
    self.isPlayerStarted = NO;
}

-(void)CreatePlayer {
    
    [player prepareToPlay];
    
    player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://stream.novotempo.com:1935/radio/smil:radionuevotiempo.smil/playlist.m3u8"]];
    player.movieSourceType = MPMovieSourceTypeStreaming;
    player.controlStyle  = MPMovieControlStyleNone;
    player.view.frame = CGRectMake(55, 180, 200, 30);
    player.backgroundView.backgroundColor = [UIColor clearColor];
    player.view.backgroundColor = [UIColor clearColor];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:nil];
    [[AVAudioSession sharedInstance] setActive:YES
                                         error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void) ChangePlayerStreamUrl: (NSString *) url{
    NSURL * serviceUrl = [NSURL URLWithString:url];
    player = [[MPMoviePlayerController alloc] initWithContentURL:serviceUrl];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self PlayAudio];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self PauseAudio];
            break;
        default:
            break;
    }
}


@end
