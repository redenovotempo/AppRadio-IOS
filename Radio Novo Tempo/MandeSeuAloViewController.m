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


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVerticalBtnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHorizontalBtnView;

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
    
    

}

- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}



- (IBAction)touchDown:(id)sender {
    self.lblRecordDetail.text = @"Gravando: 00:00";
    [self StartTimer];
    self.btnView.isPressed = YES;
    [self.btnView setNeedsDisplay];
    [UIView animateWithDuration:0.5 animations:^{
        self.bodyContainerView.backgroundColor = [UIColor colorWithRed:6.0f/255.0f green:43.0f/255.0f blue:69.0f/255.f alpha:1];
        self.lblRecordDetail.textColor = [UIColor whiteColor];
    }];
}


- (IBAction)cancelRecord:(id)sender {
    [self StopTimer];
    self.btnView.isPressed = NO;
    [self.btnView setNeedsDisplay];
    self.lblRecordDetail.textColor = [UIColor blackColor];
    self.lblRecordDetail.text = @"Cancelado! Pressione novamente o botão abaixo para iniciar uma gravação.";
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
    
    self.lblRecordDetail.text = @"Gerando arquivo, aguarde.";
    
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

//Call This to Start timer, will tick every second
-(void) StartTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

//Event called every time the NSTimer ticks.
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

//Call this to stop the timer event(could use as a 'Pause' or 'Reset')
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
@end
