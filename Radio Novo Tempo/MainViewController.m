//
//  MainViewController.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 10/20/13.
//  Copyright (c) 2013 Novo Tempo. All rights reserved.
//

#import "MainViewController.h"
#import "AVFoundation/AVFoundation.h"


@implementation MainViewController
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
#define MAX_SIZE CGRectMake(0, 335, 320, 233);

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    viewRadioListMinrect = viewRadioList.frame;
    
    
    [player prepareToPlay];
    
    
    //Update ArrowImage and Title Position BY radio Name;
    [self refreshButtonSizeByTitle];
    
    
    self.navigationItem.title=@"";
    locationExist = YES;
    // Do any additional setup after loading the view from its nib.
    
    if (!self.player) {
        player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://50.22.36.40:1935/radio/novotempo/playlist.m3u8"]];
        player.movieSourceType = MPMovieSourceTypeStreaming;
        player.controlStyle  = MPMovieControlStyleNone;
        player.view.frame = CGRectMake(55, 180, 200, 30);
        player.backgroundView.backgroundColor = [UIColor clearColor];
        player.view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:player.view];
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:nil];
    [[AVAudioSession sharedInstance] setActive:YES
                                        error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    //Customize Uislider Volume.
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMinimumTrackTintColor:[UIColor whiteColor]];
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMaximumTrackTintColor:[UIColor blackColor]];
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMaximumValueImage:[UIImage imageNamed:@"soundMax.png"]];
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMinimumValueImage:[UIImage imageNamed:@"soundMin.png"]];
    volumeCanvas.backgroundColor = [UIColor clearColor];
    
    //Find Device Location.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}


- (void) playAudio {
    playButton.hidden = YES;
    pauseButton.hidden = NO;
    
    if (player.playbackState != MPMoviePlaybackStatePlaying){
        [player play];
    }
}

- (void) pauseAudio {
    playButton.hidden = NO;
    pauseButton.hidden = YES;
    
    if (player.playbackState == MPMoviePlaybackStatePlaying) {
        [player pause];
    }
}

- (IBAction)playButtonPressed:(id)button {
    [self playAudio];
}

- (IBAction)pauseButtonPressed:(id)button {
    [self pauseAudio];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [player play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [player pause];
            break;
        default:
            break;
    }
}

//Core Location Refresh Method
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    self.currentLocation = newLocation;
    if (currentLocation.coordinate.longitude && currentLocation.coordinate.latitude && locationExist) {
        //Consuming Novo Tempo`s Service.
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
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

-(void)didReceiveMemoryWarning{
    [locationManager stopUpdatingLocation];
}


-(void)callNovoTempoService{
   
    //Create Request Values
    NSString * action = @"radiolist";
    NSString * language = @"pt";
    
    
    //Chamando JSON
    NSString * adress = [NSString stringWithFormat:@"http://novotempo.com/api/radio/?action=%@&latitude=%f&longitude=%f&hl=%@",action,self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude,language];
    
    NSLog(@"%@",adress);
    NSData * adressData = [NSData dataWithContentsOfURL: [NSURL URLWithString:adress]];
    
    NSError *error;
    NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:adressData
                                                          options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableArray * radioList = [resultados objectForKey:@"radios"];

    globallistRadios = radioList;
    [self.pickerViewRadioList reloadAllComponents];
    
    
    NSDictionary * radioDefault =  [radioList objectAtIndex:0];
    
    [btnCurrentRadio setTitle:[NSString stringWithFormat:@"%@",[radioDefault objectForKey:@"name"]] forState:UIControlStateNormal];
    
    
    //Update ArrowImage and Title Position BY radio Name;
    [self refreshButtonSizeByTitle];
    
    NSString * stringUrl = [NSString stringWithFormat:@"%@",[radioDefault objectForKey:@"streamIOS"]];
    NSURL * serviceUrl = [NSURL URLWithString:stringUrl];
    player = [[MPMoviePlayerController alloc] initWithContentURL:serviceUrl];
    
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



- (IBAction)showRadioList:(id)button{

//    Realinhando viewRadioList de acordo com o tamanho da tela.
//    CGRect screenBound = [[UIScreen mainScreen] bounds];
//    CGSize screenSize = screenBound.size;
//    CGFloat screenHeight = screenSize.height;
//    CGRect frame = viewRadioList.frame;
//    frame.origin.y = screenHeight - 233;
//    viewRadioList.frame = frame;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2f];
    


    
    
    if (CGRectEqualToRect(viewRadioList.frame, viewRadioListMinrect)) {
        viewRadioList.frame = MAX_SIZE;
        
    }
    [UIView commitAnimations];
    
}

- (IBAction)hideRadioList:(id)button{
    
    
    int row = [self.pickerViewRadioList selectedRowInComponent:0];
    NSDictionary * selectedRadio = [globallistRadios objectAtIndex:row];
    [btnCurrentRadio setTitle:[NSString stringWithFormat:@"%@",[selectedRadio objectForKey:@"name"]]forState:UIControlStateNormal];
    
    
    if (selectedRadio) {
        NSString * stringUrl = [NSString stringWithFormat:@"%@",[selectedRadio objectForKey:@"streamIOS"]];
        NSURL * serviceUrl = [NSURL URLWithString:stringUrl];
        player = [[MPMoviePlayerController alloc] initWithContentURL:serviceUrl];
        [self playAudio];
    }
    
    //Update ArrowImage and Title Position BY radio Name;
    [self refreshButtonSizeByTitle];

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2f];
    
    CGRect  cgrectMaxPosition ;
    cgrectMaxPosition = MAX_SIZE;
    
    
    if (CGRectEqualToRect(viewRadioList.frame, cgrectMaxPosition)) {
        viewRadioList.frame = viewRadioListMinrect;
        
    }
    
    [UIView commitAnimations];
}

-(void)refreshButtonSizeByTitle{
    int btnCurrentRadioTextWidth =btnCurrentRadio.titleLabel.text.length * 18 + 20;
    [btnCurrentRadio setImageEdgeInsets:UIEdgeInsetsMake(0.0, btnCurrentRadioTextWidth, 0.0, 0.0)];
    [btnCurrentRadio setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 20)];
}


@end