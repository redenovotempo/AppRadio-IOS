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
    
    if ([self CheckInternetConnection]) {
        //Carregando lista da API.
        [self CallNovoTempoService];
        [self ExecuteMainAction];
    }else{
        [self InternetConnectionErrorMessage];
    }
    
    
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

-(void)didReceiveMemoryWarning{
    [self.locationManager stopUpdatingLocation];
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
    
    //Player
    else if ([currentViewControllerName isEqualToString:@"Player"]) {
        PlayerViewController * current = (PlayerViewController*)[mainStoryboard
                                                               instantiateViewControllerWithIdentifier:currentViewControllerName];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:current
                                 leftDrawerViewController:menu
                                 rightDrawerViewController:nil];
    }
    //Filosofia
    else if ([currentViewControllerName isEqualToString:@"Filosofia"]) {
        FilosofiaViewController * current = (FilosofiaViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier:currentViewControllerName];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:current
                                 leftDrawerViewController:menu
                                 rightDrawerViewController:nil];
    }
    //EQUIPE
    else if ([currentViewControllerName isEqualToString:@"Equipe"]) {
        EquipeViewController * current = (EquipeViewController*)[mainStoryboard
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
    NSLog(@"%@",serviceUrl);
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


-(void)ExecuteMainAction{
    
    if ([self CheckInternetConnection]) {
        
        locationExist = YES;
        // Do any additional setup after loading the view from its nib.
        
        //Find Device Location.
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        //Verificando a necessidade de acessar o GPS novamente para descobrir a localizaçao.
        [self.locationManager startUpdatingLocation];
        
    }else{
        [self InternetConnectionErrorMessage];
    }
    
}

//Core Location Refresh Method
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    self.currentLocation = newLocation;
    if (self.currentLocation.coordinate.longitude && self.currentLocation.coordinate.latitude && locationExist) {
        [self CallNovoTempoService];
        [self.locationManager stopUpdatingLocation];
        locationExist = NO;
    }
}
//Core Location Error Method
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if(error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
        
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                         message:@"Não conseguimos localizar a rádio mais próxima a você. Vá em 'Ajustes' e certifique-se que este app esteja habilitado para usar o serviço de localização do Iphone."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    }
}


-(void)InternetConnectionErrorMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops" message:@"Não é possível conectar. Talvez você não tenha conexão com a internet, certifique-se disso." delegate:self cancelButtonTitle:@"Tentar Novamente" otherButtonTitles: nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self ExecuteMainAction];
    }
}


-(void)CallNovoTempoService{
    
    //Create Request Values
    NSString * action = @"radiolist";
    NSString * language = @"pt";
    
    
    //Chamando JSON
    NSString * adress = [NSString stringWithFormat:@"http://novotempo.com/api/radio/?action=%@&latitude=%f&longitude=%f&hl=%@",action,self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude,language];
    
      
    NSData * adressData = [NSData dataWithContentsOfURL: [NSURL URLWithString:adress]];
    
    NSError *error;
    NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:adressData
                                                               options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableArray * radioList = [resultados objectForKey:@"radios"];
    
    self.globallistRadios = radioList;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReloadPickerViewContent"
     object:self];
    
    
    Radio * radioDefault = [Radio getFromDictionary:[radioList objectAtIndex:0]];
    
    NSString * stringUrl = [NSString stringWithFormat:@"%@",radioDefault.streamIOS];
    
    
    if (self.needReloadCurrentStreamUrl) {
        [self ChangePlayerStreamUrl:stringUrl];
        self.needReloadCurrentStreamUrl = NO;
    }
    
    //Alterando radio atual da aplicaçao.
    self.radioCurrent = radioDefault;
}


@end
