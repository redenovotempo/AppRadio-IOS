        //
//  AppDelegate.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 10/20/13.
//  Copyright (c) 2013 Novo Tempo. All rights reserved.
//
 
#import "AppDelegate.h"
#import "ProgramingItem.h"

@import Foundation;

@interface AppDelegate()

@property(nonatomic)UIStoryboard * mainStoryboard;

@end

@implementation AppDelegate
@synthesize player;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _programingItems = [[NSMutableArray alloc]init];
    
    if ([self CheckInternetConnection]) {
        //Carregando lista da API.
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
    
    
    //Declarando storyboard
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
          self.mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }else{
        self.mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];

    }

    
    MenuViewController * menu = (MenuViewController*)[self.mainStoryboard
                                                          instantiateViewControllerWithIdentifier: @"Menu"];
    
    PlayerViewController * main = (PlayerViewController*)[self.mainStoryboard
                                                        instantiateViewControllerWithIdentifier: @"Player"];

    self.drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:main
                                             leftDrawerViewController:menu
                                             rightDrawerViewController:nil];
    
    
    //Habilitando interaçao do usuario na viewcontroller aberta.
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

-(void)ChangeRootViewController:(NSString *)currentViewControllerName needCloseEffect:(BOOL)needEffect{
    

    
    
 
    //Definindo ViewControlle de menu, sempre do lado esquerdo.
    MenuViewController * menu = (MenuViewController*)[self.mainStoryboard
                                                      instantiateViewControllerWithIdentifier: @"Menu"];
  
    //Mural
    if ([currentViewControllerName isEqualToString:@"Mural"]) {
        MuralViewController * current = (MuralViewController*)[self.mainStoryboard
                                                               instantiateViewControllerWithIdentifier:currentViewControllerName];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:current
                                 leftDrawerViewController:menu
                                 rightDrawerViewController:nil];
        
        
        //Habilitando gestos
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
    
    //Programação
    if ([currentViewControllerName isEqualToString:@"Programação"]) {
        ProgramacaoViewController * current = (ProgramacaoViewController*)[self.mainStoryboard
                                                               instantiateViewControllerWithIdentifier:currentViewControllerName];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:current
                                 leftDrawerViewController:menu
                                 rightDrawerViewController:nil];
        
        
        //Habilitando gestos
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
    
    //Programação
    if ([currentViewControllerName isEqualToString:@"Peça sua música"]) {
        PedirMusicaViewController * current = (PedirMusicaViewController*)[self.mainStoryboard
                                                                           instantiateViewControllerWithIdentifier:currentViewControllerName];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:current
                                 leftDrawerViewController:menu
                                 rightDrawerViewController:nil];
        
        
        //Habilitando gestos
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
    
    //Player
    else if ([currentViewControllerName isEqualToString:@"Player"]) {
        PlayerViewController * current = (PlayerViewController*)[self.mainStoryboard
                                                               instantiateViewControllerWithIdentifier:currentViewControllerName];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:current
                                 leftDrawerViewController:menu
                                 rightDrawerViewController:nil];
    }
    //history
    else if ([currentViewControllerName isEqualToString:@"História da Rádio"]) {
        HistoryViewController * current = (HistoryViewController*)[self.mainStoryboard
                                                                 instantiateViewControllerWithIdentifier:currentViewControllerName];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:current
                                 leftDrawerViewController:menu
                                 rightDrawerViewController:nil];
        
        
        //Habilitando gestos
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
    //EQUIPE
    else if ([currentViewControllerName isEqualToString:@"Equipe"]) {
        EquipeViewController * current = (EquipeViewController*)[self.mainStoryboard
                                                                       instantiateViewControllerWithIdentifier:currentViewControllerName];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:current
                                 leftDrawerViewController:menu
                                 rightDrawerViewController:nil];
        
        
        //Habilitando gestos
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
    //Mande Seu Alô
    else if ([currentViewControllerName isEqualToString:@"Mande seu alô"]) {
        MandeSeuAloViewController * current = (MandeSeuAloViewController*)[self.mainStoryboard
                                                                 instantiateViewControllerWithIdentifier:currentViewControllerName];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:current
                                 leftDrawerViewController:menu
                                 rightDrawerViewController:nil];
        
        
        //Habilitando gestos
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
    
    
    
    //Habilitando interaçao do usuario na viewcontroller aberta.
    self.drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeFull;


    
    if (needEffect) {
        //Abrindo a side para manter o efeito de fechamento.
        [self.drawerController openDrawerSide:MMDrawerSideLeft animated:NO completion:^(BOOL finished){
            self.window.rootViewController = self.drawerController;
            [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }];
    }else{
        self.window.rootViewController = self.drawerController;
    }
    

}

- (void)PlayAudio {
    [player stop];
    [player play];
    self.isPlayerStarted = YES;
}

- (void)PauseAudio {
    [player stop];
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
    //NSLog(@"%@",serviceUrl);
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
        
        [self CallNovoTempoService];
        
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
    
    [self CallProgramJsonByToday];
    
    [NSTimer scheduledTimerWithTimeInterval:300.0f target:self selector:@selector(CallProgramJsonByToday) userInfo:nil repeats:YES];
    
}

-(void)CallProgramJsonByToday{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"needUpdateCurrentProgramName" object:self];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];
    [self CallProgramJsonData:[NSNumber numberWithInteger:weekday]];
}


///Programação
-(void)CallProgramJsonData:(NSNumber*)number{
    
    [_programingItems removeAllObjects];
    
    //Create Request Values
    NSString * action = @"programing";
    NSNumber * idRadio = self.radioCurrent.radioId;
    
    //Chamando JSON
    NSString * adress = [NSString stringWithFormat:@"http://novotempo.com/api/radio/?action=%@&idRadio=%@&%d",action,idRadio,[number intValue]];
    
    NSString * post = [[NSString alloc]init];
    NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:adress]];
    [request setHTTPMethod:@"POST"]; // 1
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"]; // 2
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    self.urlConnection = [[NSURLConnection alloc]init];
    self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.urlProgramData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.urlProgramData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *jsonParsingError = nil;
    
    NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:self.urlProgramData options:NSJSONReadingMutableContainers error:&jsonParsingError];
    
    
    if (![[resultados objectForKey:@"daySchedule"] isKindOfClass:[NSNull class]]) {
        for (NSDictionary * item in [resultados objectForKey:@"daySchedule"]) {
            ProgramingItem * currentItem = [ProgramingItem getFromDictionary:item];
            [_programingItems addObject:currentItem];
        }
    }
    
    if (jsonParsingError || !_programingItems || _programingItems.count == 0){
        NSLog (@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
        _hasProgramData = NO;
    }else{
        _hasProgramData = YES;
        //_currentProgramName = [self getCurrentProgramName];
        ProgramingItem * selectedItem =  _programingItems.lastObject;
        _currentProgramName = selectedItem.program;
    }
}


///Função antiga para descobrir qual programação da radio NT
///é a programação mais perto da hora atual do telefone.

-(NSString *)getCurrentProgramName{
    NSString * result = [[NSString alloc]init];
    
    
    NSTimeInterval oldDiff = 0;
    
    ProgramingItem * currentSelectedNearItem = [[ProgramingItem alloc]init];
    
    for (ProgramingItem * item in _programingItems) {
        
        //Actual
        NSInteger currentItemHour = [self getHourByProgramingItem:item];
        NSInteger currentItemMinut = [self getMinutByProgramingItem:item];
        NSDate * currentItemDate = [self getDateWithHour:currentItemHour andMinut:currentItemMinut];
        
        NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:currentItemDate];
        
        if (diff < oldDiff || oldDiff == 0) {
            oldDiff = diff;
            currentSelectedNearItem = item;
        }
    }
    
    result = currentSelectedNearItem.program;
    
    return result;
}

-(NSInteger)getMinutByProgramingItem:(ProgramingItem *)item{
    NSRange range = NSMakeRange(0,2);
    NSString * resultWithOutMinut = [item.time stringByReplacingCharactersInRange:range withString:@""];
    NSString * currentStringItemMinut = [resultWithOutMinut stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSInteger currentItemMinut = [currentStringItemMinut intValue];
    
    return currentItemMinut;
}

-(NSInteger)getHourByProgramingItem:(ProgramingItem *)item{
    NSRange range = NSMakeRange(0,2);
    NSString * resultWithOutMinut = [item.time stringByReplacingCharactersInRange:range withString:@""];
    NSString * currentStringItemHour = [item.time stringByReplacingOccurrencesOfString:resultWithOutMinut withString:@""];
    NSInteger currentItemHour = [currentStringItemHour intValue];
    
    return currentItemHour;
}

-(NSDate *)getDateWithHour:(NSInteger)hour andMinut:(NSInteger)minut{

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    
    NSDateComponents *components = [calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
    
    [components setHour:hour];
    [components setMinute:minut];
    NSDate * resultDate = [calendar dateFromComponents:components];
    
    return resultDate;
}


@end
