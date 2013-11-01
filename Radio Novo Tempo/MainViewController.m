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
@synthesize lblCurrentRadio;


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
    if (player.playbackState != MPMoviePlaybackStatePlaying){
        [player play];
    }
}

- (void) pauseAudio {
    if (player.playbackState == MPMoviePlaybackStatePlaying) {
        [player pause];
    }
}

- (IBAction)playButtonPressed:(id)button {
    [self playAudio];
    playButton.hidden = YES;
    pauseButton.hidden = NO;
}

- (IBAction)pauseButtonPressed:(id)button {
    [self pauseAudio];
    playButton.hidden = NO;
    pauseButton.hidden = YES;
    
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
    
    //NSLog(@"New location: %f, %f",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude);
    //if(newLocation.horizontalAccuracy <= 100.0f) { [locationManager stopUpdatingLocation]; }
    
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
    
    //} else if(error.code == kCLErrorLocationUnknown) {
    // retry
        
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
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
    NSString * action = @"radio";
    NSString * language = @"pt";
    
    
    //Chamando JSON
    NSString * adress = [NSString stringWithFormat:@"http://novotempo.com/api/radio/?action=%@&latitude=%f&longitude=%f&hl=%@",action,self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude,language];
    NSData * adressData = [NSData dataWithContentsOfURL: [NSURL URLWithString:adress]];
    
    NSError *error;
    NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:adressData
                                                          options:NSJSONReadingMutableContainers error:&error];
    
    //lblCurrentRadio.text = [resultados objectAtIndex:1];
    lblCurrentRadio.text = [NSString stringWithFormat:@"%@",[resultados objectForKey:@"name"]];
    
    NSString * stringUrl = [NSString stringWithFormat:@"%@",[resultados objectForKey:@"streamIOS"]];
    NSURL * serviceUrl = [NSURL URLWithString:stringUrl];
    
    [NSString stringWithFormat:@"%@",[resultados objectForKey:@"streamIOS"]];
    
    player = [[MPMoviePlayerController alloc] initWithContentURL:serviceUrl];
    

}

@end