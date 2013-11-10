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


@interface MainViewController : UIViewController<CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    MPMoviePlayerController *player;
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *pauseButton;
    IBOutlet UIView * volumeCanvas;
    IBOutlet UIButton * btnCurrentRadio;
    NSArray * globallistRadios;
    BOOL locationExist;
    
}
@property (weak, nonatomic) IBOutlet UIView *pickRadioListView;

@property(nonatomic,retain)IBOutlet UIButton * btnCurrentRadio;
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
- (IBAction)showRadioList:(id)button;
- (IBAction)hideRadioList:(id)button;
- (void) playAudio;
- (void) pauseAudio;
@end