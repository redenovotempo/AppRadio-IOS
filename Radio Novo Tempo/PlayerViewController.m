//
//  MainViewController.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 10/20/13.
//  Copyright (c) 2013 Novo Tempo. All rights reserved.
//

#import "PlayerViewController.h"
#import "AVFoundation/AVFoundation.h"




@implementation PlayerViewController
@synthesize player;
@synthesize playButton;
@synthesize pauseButton;
@synthesize volumeCanvas;
@synthesize sliderVolume;
@synthesize currentLocation;
@synthesize locationManager;
@synthesize btnCurrentRadio;
@synthesize viewRadioList;
@synthesize globallistRadios;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

#pragma mark - View lifecycle

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Realocate viewRadioList Position.
    viewRadioList.frame = [self SetViewRadioListCGRect: NO];
    
    //Monitorando  aplicaçao caso o usuario use o controle remoto do player.
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(CheckPlayerState)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
    [self CheckPlayerState];
    
    
    
    //Customize Uislider Volume.
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMinimumTrackTintColor:[UIColor whiteColor]];
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMaximumTrackTintColor:[UIColor blackColor]];
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMaximumValueImage:[UIImage imageNamed:@"soundMax.png"]];
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMinimumValueImage:[UIImage imageNamed:@"soundMin.png"]];
    volumeCanvas.backgroundColor = [UIColor clearColor];

    //ExecuteMainAction
    [self ExecuteMainAction];
}

-(void)CheckPlayerState
{
    //Verificando se a radio ja esta tocando.
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Nome da radio atual que esta tocando
    if ([appDel.lblRadioName.text length] != 0) {
        [btnCurrentRadio setTitle:appDel.lblRadioName.text forState:UIControlStateNormal];
    }
    
    //Estado dos botoes
    if (appDel.isPlayerStarted) {
        [self PlayAudioState];
    }else{
        [self PauseAudioState];
    }

}

-(void)ExecuteMainAction{
    
    if ([self CheckInternetConnection]) {
        
        self.navigationItem.title=@"";
        locationExist = YES;
        // Do any additional setup after loading the view from its nib.
        
        //Find Device Location.
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        //Verificando a necessidade de acessar o GPS novamente para descobrir a localizaçao.
        [locationManager startUpdatingLocation];
        
    }else{
        [self InternetConnectionErrorMessage];
    }
    
}

-(BOOL)CheckInternetConnection{

    //Check Internet Connection.
    AppDelegate * apDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return apDel.CheckInternetConnection;
}



- (void) PlayAudio {
    AppDelegate * apDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([self CheckInternetConnection]) {
            [self PlayAudioState];
        
        if (apDel.player.playbackState != MPMoviePlaybackStatePlaying){
            [apDel PlayAudio];
        }
    }else{
        [self InternetConnectionErrorMessage];
    }
}



- (void) PauseAudio {
    AppDelegate * apDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self PauseAudioState];
    
    if (apDel.player.playbackState == MPMoviePlaybackStatePlaying) {
        AppDelegate * apDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [apDel PauseAudio];
    }
}

- (void) PlayAudioState
{
    playButton.hidden = YES;
    pauseButton.hidden = NO;
}

- (void) PauseAudioState
{
    playButton.hidden = NO;
    pauseButton.hidden = YES;

}

- (IBAction)playButtonPressed:(id)button {
    [self PlayAudio];
}

- (IBAction)pauseButtonPressed:(id)button {
    [self PauseAudio];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


//Core Location Refresh Method
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    self.currentLocation = newLocation;
    if (currentLocation.coordinate.longitude && currentLocation.coordinate.latitude && locationExist) {
        [self callNovoTempoService];
        [locationManager stopUpdatingLocation];
        locationExist = NO;
    }
}
//Core Location Error Method
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
        
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Ops!"
                                                        message:@"Não conseguimos localizar a rádio mais próxima a você. Vá em 'Ajustes' e certifique-se que este app esteja habilitado para usar o serviço de localização do Iphone."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewWillAppear {
    

    [self becomeFirstResponder];
}

-(void)didReceiveMemoryWarning{
    [locationManager stopUpdatingLocation];
}


-(void)callNovoTempoService{
   
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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

    globallistRadios = radioList;
    [self.pickerViewRadioList reloadAllComponents];
    
    
    NSDictionary * radioDefault =  [radioList objectAtIndex:0];
    
    if ([radioDefault objectForKey:@"name"] && [appDel.lblRadioName.text length] == 0) {
        [btnCurrentRadio setTitle:[NSString stringWithFormat:@"%@",[radioDefault objectForKey:@"name"]] forState:UIControlStateNormal];
    }
    
    NSString * stringUrl = [NSString stringWithFormat:@"%@",[radioDefault objectForKey:@"streamIOS"]];
    
    
    if (appDel.needReloadCurrentStreamUrl) {
        [appDel ChangePlayerStreamUrl:stringUrl];
        appDel.needReloadCurrentStreamUrl = NO;
    }
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return [globallistRadios count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    NSDictionary * dictRecipient = [[NSDictionary alloc]init];
    dictRecipient = [globallistRadios objectAtIndex:row];
    return [dictRecipient objectForKey:@"name"];
}


-(CGRect)SetViewRadioListCGRect:(BOOL)IsClosed{

    //Realinhando viewRadioList de acordo com o tamanho da tela.
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    CGFloat screenWidth = screenSize.width;
    
    CGRect frame = viewRadioList.frame;
    frame.origin.y = screenHeight - 233;
    viewRadioList.frame = frame;
    
    CGRect Position;
    
    if (IsClosed){
        Position = CGRectMake(0, screenHeight - 233, screenWidth, 233);
    }else{
        Position = CGRectMake(0, screenHeight + 233, screenWidth, 233);
    }
    
    return Position;
}


- (IBAction)showRadioList:(id)button{

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2f];
    
    
    if (CGRectEqualToRect(viewRadioList.frame, [self SetViewRadioListCGRect: NO])) {
        viewRadioList.frame = [self SetViewRadioListCGRect:YES];
        
    }
    [UIView commitAnimations];
    
}

- (IBAction)hideRadioList:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    int row = [self.pickerViewRadioList selectedRowInComponent:0];
    NSDictionary * selectedRadio = [globallistRadios objectAtIndex:row];
    
    if ([selectedRadio objectForKey:@"name"]) {
        [btnCurrentRadio setTitle:[NSString stringWithFormat:@"%@",[selectedRadio objectForKey:@"name"]]forState:UIControlStateNormal];
        
        appDel.lblRadioName.text = [NSString stringWithFormat:@"%@",[selectedRadio objectForKey:@"name"]];
    }
    
    if (selectedRadio) {
        [player stop];
        NSString * stringUrl = [NSString stringWithFormat:@"%@",[selectedRadio objectForKey:@"streamIOS"]];
        
        //NSURL * serviceUrl = [NSURL URLWithString:stringUrl];
        //player = [[MPMoviePlayerController alloc] initWithContentURL:serviceUrl];
        
               [appDel ChangePlayerStreamUrl:stringUrl];
        
        [self PlayAudio];
    }
    
    //Update ArrowImage and Title Position BY radio Name;
    //[self refreshButtonSizeByTitle];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2f];
    
    CGRect  cgrectMaxPosition ;
    cgrectMaxPosition = [self SetViewRadioListCGRect:(NO)];
    
    
    if (CGRectEqualToRect(viewRadioList.frame, [self SetViewRadioListCGRect: YES])) {
        viewRadioList.frame = [self SetViewRadioListCGRect: NO];
        
    }
    
    [UIView commitAnimations];
}

-(void)refreshButtonSizeByTitle{
    int btnCurrentRadioTextWidth =btnCurrentRadio.titleLabel.text.length * 18;
    [btnCurrentRadio setImageEdgeInsets:UIEdgeInsetsMake(0.0, btnCurrentRadioTextWidth, 0.0, 0.0)];
    [btnCurrentRadio setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 20)];
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

- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    

    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



@end