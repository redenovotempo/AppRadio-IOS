//
//  MandeSeuAloViewController.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 2/11/15.
//  Copyright (c) 2015 Novo Tempo. All rights reserved.
//

#import "MicView.h"
#import "MandeSeuAloViewController.h"
#import "AppDelegate.h"

@interface MandeSeuAloViewController ()
@property (weak, nonatomic) IBOutlet MicView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenMenu;
@property (weak, nonatomic) IBOutlet UIView *bodyContainerView;
@property (weak, nonatomic) IBOutlet UILabel *lblRecordDetail;

//Botao Gravar.
@property (weak, nonatomic) IBOutlet UIImageView *micPermissionImageView;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainMicPermissionProcess;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVerticalBtnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHorizontalBtnView;

//Audio
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation MandeSeuAloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnView.backgroundColor = [UIColor clearColor];
    
    //Observando Framework de menu para quando abrir chamar este metodo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rotateBtnOpenMenu)
                                                 name:@"GestureOpenMenu"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unRotateBtnOpenMenu)
                                                 name:@"GestureCloseMenu"
                                               object:nil];
    
    
    
    [self setupRecorder];

}
- (IBAction)tryAgainSetupRecorder:(id)sender {
    
    [self setupRecorder];
}

-(void)setupRecorder{
    NSArray *dirPaths;
    NSString *docsDir;
    
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sound.caf"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    
    NSLog(@"%@",soundFileURL);
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    
    
    if ([audioSession recordPermission] == AVAudioSessionRecordPermissionGranted) {
        _lblRecordDetail.text=@"Pressione o botão abaixo para gravar e mandar o seu alô. Arraste seu dedo durante a gravação para cancelar o procedimento.";
        _micPermissionImageView.hidden = YES;
        _tryAgainMicPermissionProcess.hidden = YES;
        _btnView.hidden = NO;
    }else{
        _lblRecordDetail.text=@"Você não autorizou este aplicativo para ter acesso ao microfone do seu device. Vá em Ajustes do iPhone(iPad) > Rádio NT e autorize como mostra na imagem abaixo:";
        _micPermissionImageView.hidden = NO;
        _tryAgainMicPermissionProcess.hidden = NO;
        _btnView.hidden = YES;
    }
    
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        [_audioRecorder prepareToRecord];
    }

}


-(void)deleteSoundFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"sound.caf"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (fileExists) {
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (success) {
            
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }

}


- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}



- (IBAction)touchDown:(id)sender {
    self.lblRecordDetail.text = @"Gravando: 00:00";
    [self StartTimer];
    
    //Recording
    if (!_audioRecorder.recording)
    {
        [_audioRecorder record];
    }
    
    
    self.btnView.isPressed = YES;
    [self.btnView setNeedsDisplay];
    [UIView animateWithDuration:0.5 animations:^{
        self.bodyContainerView.backgroundColor = [UIColor colorWithRed:6.0f/255.0f green:43.0f/255.0f blue:69.0f/255.f alpha:1];
        self.lblRecordDetail.textColor = [UIColor whiteColor];
    }];
}


- (IBAction)cancelRecord:(id)sender {
    [self StopTimer];
    
    //Stop Record
    if (_audioRecorder.recording)
    {
        [_audioRecorder stop];
        [self deleteSoundFile];
    }
    
    
    self.btnView.isPressed = NO;
    [self.btnView setNeedsDisplay];
    self.lblRecordDetail.textColor = [UIColor blackColor];
    self.lblRecordDetail.text = @"Cancelado! Pressione novamente o botão abaixo para iniciar uma gravação. Arraste seu dedo durante a gravação para cancelar o procedimento.";
    _constraintHorizontalBtnView.constant = -25;
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.25 initialSpringVelocity:0.0 options:0 animations:^{
        _constraintHorizontalBtnView.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL completed){
    
    }];
    
    
    
    
    self.bodyContainerView.backgroundColor = [UIColor whiteColor];
}

- (IBAction)beginRecord:(id)sender {
    [self StopTimer];
    self.btnView.isPressed = NO;
    [self.btnView setNeedsDisplay];
    
    //Stop Record
    if (_audioRecorder.recording)
    {
        [_audioRecorder stop];
    }
    
    self.lblRecordDetail.text = @"Gerando arquivo, aguarde.";
    
    [self sendEmail];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.bodyContainerView.backgroundColor = [UIColor whiteColor];
        self.lblRecordDetail.textColor = [UIColor blackColor];
    }];
}



-(void)rotateBtnOpenMenu{
    
    //Criando animaçao
    [UIView animateWithDuration:0.5 animations:^{
        [self.btnOpenMenu setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        self.btnOpenMenu.center =  CGPointMake(CGRectGetMidX(self.btnOpenMenu.frame),CGRectGetMidY(self.btnOpenMenu.frame));
    }];
}


-(void)unRotateBtnOpenMenu{
    
    //Criando animaçao
    [UIView animateWithDuration:0.5 animations:^{
        [self.btnOpenMenu setTransform:CGAffineTransformIdentity];
        self.btnOpenMenu.center =  CGPointMake(CGRectGetMidX(self.btnOpenMenu.frame),CGRectGetMidY(self.btnOpenMenu.frame));
    }];
    
}

//In Header
int timeSec = 0;
int timeMin = 0;
NSTimer *timer;

-(void) StartTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)timerTick:(NSTimer *)timer
{
    timeSec++;
    if (timeSec == 60)
    {
        timeSec = 0;
        timeMin++;
    }
    //Format the string 00:00
    NSString* timeNow = [NSString stringWithFormat:@"Gravando: %02d:%02d", timeMin, timeSec];
    //Display on your label
    //[timeLabel setStringValue:timeNow];
    self.lblRecordDetail.text= timeNow;
}

- (void) StopTimer
{
    [timer invalidate];
    timeSec = 0;
    timeMin = 0;
    //Since we reset here, and timerTick won't update your label again, we need to refresh it again.
    //Format the string in 00:00
    NSString* timeNow = [NSString stringWithFormat:@"Gravando: %02d:%02d", timeMin, timeSec];
    //Display on your label
    // [timeLabel setStringValue:timeNow];
    self.lblRecordDetail.text= timeNow;
}

-(void)sendEmail{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    if ([MFMailComposeViewController canSendMail])
    {
        NSString * content = [[NSString alloc]init];
        content = @"";
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"#RADIO NT - Meu alô"];
        [mail setMessageBody:content isHTML:YES];
        [mail setToRecipients:@[appDel.radioCurrent.emailContact]];
        
        
        
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"sound.caf"];
        
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
        NSData *dataToSend = [[NSData alloc] initWithContentsOfURL:fileURL];
        
        // Set up recipients
        NSArray *toRecipients = nil;
        NSArray *ccRecipients = nil;
        NSArray *bccRecipients = nil;
        
        [mail setToRecipients:toRecipients];
        [mail setCcRecipients:ccRecipients];
        [mail setBccRecipients:bccRecipients];
        
        [mail setMessageBody:@"" isHTML:YES];
        [mail addAttachmentData:dataToSend mimeType:@"audio/x-caf" fileName:[NSString stringWithFormat:@"%@.caf",[[UIDevice currentDevice] name]]];
        
        
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VC_SEM_CONTA", @"Você não possui  uma conta de e-mail configurada.") message:NSLocalizedString(@"ADICIONANDO_CONTA", @"Adicione uma conta ( Ajustes de seu aparelho > Mail,Contatos,Calendários > Adicionar Conta ) e tente novamente.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alerta show];
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self cancelRecord:nil];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            [self showSucessEmailSentMenssage];
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)showSucessEmailSentMenssage{
    
    self.lblRecordDetail.text = @"Pressione o botão abaixo para iniciar uma gravação. Arraste seu dedo durante a gravação para cancelar o procedimento.";
    
    UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Obrigado!" message:@"Sua mensagem foi enviada para nossa equipe com sucesso." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alerta show];
}

@end
