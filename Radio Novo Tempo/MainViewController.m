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


- (void)viewWillAppear {
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

@end