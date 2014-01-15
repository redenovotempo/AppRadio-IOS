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
    

    //Realocate viewRadioList Position.
    viewRadioList.frame = [self SetViewRadioListCGRect: NO];
    
    //Monitorando  aplicaçao caso o usuario use o controle remoto do player.
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(CheckPlayerState)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
    //Verificando se a radio ja esta tocando.
    [self CheckPlayerState];
    
    //Customize Uislider Volume.
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMinimumTrackTintColor:[UIColor whiteColor]];
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMaximumTrackTintColor:[UIColor blackColor]];
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMaximumValueImage:[UIImage imageNamed:@"soundMax.png"]];
    [[UISlider appearanceWhenContainedIn:[MPVolumeView class], nil] setMinimumValueImage:[UIImage imageNamed:@"soundMin.png"]];
    volumeCanvas.backgroundColor = [UIColor clearColor];
    
    //Atualizando lista a cada 60 porcausa do delay GPS
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(ReloadPickerViewContent) userInfo:nil repeats:YES];
}

-(void)ReloadPickerViewContent{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
     if (!appDel.globallistRadios) {
         [self.pickerViewRadioList reloadAllComponents];
     }
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


- (void)viewWillAppear {
    

    [self becomeFirstResponder];
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

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //set item per row
    NSDictionary * dictRecipient = [[NSDictionary alloc]init];
    dictRecipient = [appDel.globallistRadios objectAtIndex:row];
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
        AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDel ExecuteMainAction];
    }
}

- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



@end