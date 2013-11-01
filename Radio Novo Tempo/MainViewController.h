//
//  MainViewController.h
//  Radio Novo Tempo
//
//  Created by MacMichas on 10/20/13.
//  Copyright (c) 2013 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayer/MediaPlayer.h"
#import "VolumeView.h"
#import "CoreLocation/CoreLocation.h"


@interface MainViewController : UIViewController<CLLocationManagerDelegate>
{
    MPMoviePlayerController *player;
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *pauseButton;
    IBOutlet UIView * volumeCanvas;
    IBOutlet UILabel * lblCurrentRadio;
    BOOL locationExist;
    
}

@property(nonatomic,retain)IBOutlet UILabel * lblCurrentRadio;
@property (weak, nonatomic) IBOutlet UISlider *sliderVolume;
@property(nonatomic,retain)IBOutlet UIView * volumeCanvas;
@property (nonatomic, retain) MPMoviePlayerController *player;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *pauseButton;

//Core Location values
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;


- (IBAction)playButtonPressed:(id)button;
- (IBAction)pauseButtonPressed:(id)button;
- (void) playAudio;
- (void) pauseAudio;
@end