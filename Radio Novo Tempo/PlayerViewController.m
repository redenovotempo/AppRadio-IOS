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
@synthesize playButton;
@synthesize pauseButton;
@synthesize volumeCanvas;
@synthesize sliderVolume;
@synthesize currentLocation;
@synthesize locationManager;
@synthesize btnCurrentRadio;
@synthesize viewRadioList;



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
    
    //self.viewRadioList.backgroundColor = [UIColor redColor];
    
    
//    NSDictionary * objects = @{@"picker":self.pickerViewRadioList};
//    
//    self.viewRadioList.translatesAutoresizingMaskIntoConstraints = YES;
//    
//    [self.viewRadioList addConstraints:[NSLayoutConstraint
//                               constraintsWithVisualFormat:@"V:|[picker]"
//                               options:0
//                               metrics:0
//                               views:objects]];
    


    
    self.jumtButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:18];
    btnCurrentRadio.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:18];
    self.btnOkPickerView.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light-Bold" size:18];
    
    //Monitorando  aplicaçao caso o usuario use o controle remoto do player.
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(CheckPlayerState)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
    
    //Refresh na lista de dados.
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(ReloadPickerViewContent)
                                                name:@"ReloadPickerViewContent"
                                              object:nil];
    
    //Verificando se a radio ja esta tocando.
    [self CheckPlayerState];
    
    volumeCanvas.backgroundColor = [UIColor clearColor];

    [[UISlider appearanceWhenContainedIn:[volumeCanvas class], nil] setMaximumValueImage:[UIImage imageNamed:@"soundMax.png"]];
    [[UISlider appearanceWhenContainedIn:[volumeCanvas class], nil] setMinimumValueImage:[UIImage imageNamed:@"soundMin.png"]];
    [volumeCanvas setMinimumVolumeSliderImage:[UIImage imageNamed:@"minSlider.png"] forState:UIControlStateNormal];
    [volumeCanvas setMaximumVolumeSliderImage:[UIImage imageNamed:@"maxSlider.png"] forState:UIControlStateNormal];
    
}



-(void)ReloadPickerViewContent{
    [self.pickerViewRadioList reloadAllComponents];
    [self ReloadRadioLabelName];
}

-(void)ReloadRadioLabelName{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReloadRadioLabelName"
     object:self];
    
    //Verificando se a radio ja esta tocando.
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Nome da radio atual que esta tocando
    if ([appDel.radioCurrent.name length] != 0) {
        [btnCurrentRadio setTitle:appDel.radioCurrent.name forState:UIControlStateNormal];
        
    }
}


-(void)CheckPlayerState
{
    [self ReloadRadioLabelName];
    
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Estado dos botoes
    if (appDel.isPlayerStarted) {
        [self PlayAudioState];
    }else{
        [self PauseAudioState];
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

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)didReceiveMemoryWarning{
    [locationManager stopUpdatingLocation];
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    //set number of rows
    return [appDel.globallistRadios count];
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self ReloadRadioLabelName];
    
    UILabel* tView = (UILabel*)view;
    if (!tView){
        
        tView = [[UILabel alloc] init];
        tView.text = [[appDel.globallistRadios objectAtIndex:row] objectForKey:@"name"];
        tView.font = [UIFont fontWithName:@"ProximaNova-Light" size:20];
        tView.textAlignment = NSTextAlignmentCenter;
    }
    return tView;
}




- (IBAction)showRadioList:(id)button{
    
    [UIView animateWithDuration:0.3 animations:^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _botomRadioListConstraintIpad.constant = 0;
        }else{
            _botomRadioListConstraint.constant = 0;
        }
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)hideRadioList:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
   
    long row = [self.pickerViewRadioList selectedRowInComponent:0];
    Radio * selectedRadio = [Radio getFromDictionary:[appDel.globallistRadios objectAtIndex:row]];
    
    if (selectedRadio.name) {
        [btnCurrentRadio setTitle:[NSString stringWithFormat:@"%@",selectedRadio.name]forState:UIControlStateNormal];
        
        
        appDel.lblRadioName.text = [NSString stringWithFormat:@"%@",selectedRadio.name];
    }
    
    if (selectedRadio) {
        [appDel.player stop];
        
        NSString * stringUrl = [NSString stringWithFormat:@"%@",selectedRadio.streamIOS];
        [appDel ChangePlayerStreamUrl:stringUrl];
        
        //Alterando radio default da aplicaçao.
        appDel.radioCurrent = selectedRadio;
        [self PlayAudio];
    }
    
    [self hideRadioListElements];
    
    [appDel CallProgramJsonByToday];
    
}


-(void)hideRadioListElements{
 
    [UIView animateWithDuration:0.3 animations:^{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _botomRadioListConstraintIpad.constant = -233;
    }
    else{
        _botomRadioListConstraint.constant = -233;
    }
        [self.view layoutIfNeeded];
    }];
}

-(void)refreshButtonSizeByTitle{
    long btnCurrentRadioTextWidth =btnCurrentRadio.titleLabel.text.length * 18;
    [btnCurrentRadio setImageEdgeInsets:UIEdgeInsetsMake(0.0, btnCurrentRadioTextWidth, 0.0, 0.0)];
    [btnCurrentRadio setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 20)];
}

-(void)InternetConnectionErrorMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops" message:@"Não é possível conectar. Talvez você não tenha conexão com a internet, certifique-se disso." delegate:self cancelButtonTitle:@"Tentar Novamente" otherButtonTitles: nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDel ExecuteMainAction];
    }
}

- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



- (IBAction)hidePlayer:(id)sender {
    AppDelegate * apDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [apDel ChangeRootViewController:@"Mural" needCloseEffect:NO];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([[touch view] isKindOfClass:[UIImageView class]])
    {
        [self hideRadioListElements];
    }
    
}

- (IBAction)nextRadioListItem:(id)sender {
    
    self.currentPickerViewItem = [self.pickerViewRadioList selectedRowInComponent:0];
    [self.pickerViewRadioList selectRow:self.currentPickerViewItem-1 inComponent:0 animated:YES];
    
}

- (IBAction)previousRadioListItem:(id)sender{
    self.currentPickerViewItem = [self.pickerViewRadioList selectedRowInComponent:0];
    [self.pickerViewRadioList selectRow:self.currentPickerViewItem+1 inComponent:0 animated:YES];
}



@end