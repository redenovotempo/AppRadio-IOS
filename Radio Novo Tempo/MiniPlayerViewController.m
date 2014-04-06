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
    self.btnRadioName.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:18];
    

    
    //Monitorando  aplicaçao caso o usuario use o controle remoto do player.
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(CheckPlayerState)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
    
    [self CheckPlayerState];
    [self ReloadRadioLabelName];
}


-(void)ReloadRadioLabelName{
    //Verificando se a radio ja esta tocando.
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Nome da radio atual que esta tocando
    if ([appDel.radioCurrent.name length] != 0) {
        [self.btnRadioName setTitle:appDel.radioCurrent.name forState:UIControlStateNormal];
    }
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
        
        [self CheckPlayerState];
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

- (IBAction)btnRadioNamePressed:(id)button{
    
     AppDelegate * apDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     [apDel ChangeRootViewController:@"Player" needCloseEffect:NO];

}

-(void)CheckPlayerState
{
    //Verificando se a radio ja esta tocando.
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Nome da radio atual que esta tocando
    if ([appDel.lblRadioName.text length] != 0) {
        [self.btnRadioName setTitle:appDel.lblRadioName.text forState:UIControlStateNormal];
    }
    
    //Estado dos botoes
    if (appDel.isPlayerStarted) {
        [self PlayAudioState];
    }else{
        [self PauseAudioState];
    }
    
    
}


@end
