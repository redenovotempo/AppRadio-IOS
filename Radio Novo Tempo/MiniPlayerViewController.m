//
//  MiniPlayerViewController.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/18/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "MiniPlayerViewController.h"

@interface MiniPlayerViewController ()

@end

@implementation MiniPlayerViewController

@synthesize playButton;
@synthesize pauseButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) PlayAudio {
    AppDelegate * apDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([apDel CheckInternetConnection]) {
        [self PlayAudioState];
        
        if (apDel.player.playbackState != MPMoviePlaybackStatePlaying){
            [apDel PlayAudio];
        }
    }else{
        [apDel InternetConnectionErrorMessage];
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

@end
