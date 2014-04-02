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
#import "AppDelegate.h"
#import "Radio.h"


@interface PlayerViewController : UIViewController<CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *pauseButton;
    IBOutlet UIView * volumeCanvas;
    IBOutlet UIButton * btnCurrentRadio;
    //NSMutableArray * globallistRadios;
    BOOL locationExist;
    Radio * radioSelected;
}

//Pular pro mural
- (IBAction)hidePlayer:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *jumtButton;

//Controle do RadioList
@property(nonatomic)long currentPickerViewItem;
@property (weak, nonatomic) IBOutlet UIButton *btnOkPickerView;

- (IBAction)nextRadioListItem:(id)sender;
- (IBAction)previousRadioListItem:(id)sender;




@property (nonatomic,retain)NSMutableArray * globallistRadios;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewRadioList;
@property (strong, nonatomic) IBOutlet UIView *viewRadioList;

@property(nonatomic,retain)IBOutlet UIButton * btnCurrentRadio;
@property (weak, nonatomic) IBOutlet UISlider *sliderVolume;
@property(nonatomic,retain)IBOutlet UIView * volumeCanvas;

//Player
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
- (void) PlayAudio;
- (void) PauseAudio;

//menu
- (IBAction)OpenMenuButtonPressed:(id)button;

@end