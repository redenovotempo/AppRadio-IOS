//
//  MandeSeuAloViewController.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 2/11/15.
//  Copyright (c) 2015 Novo Tempo. All rights reserved.
//

#import "MicView.h"
#import "MandeSeuAloViewController.h"

@interface MandeSeuAloViewController ()
@property (weak, nonatomic) IBOutlet MicView *btnView;

@end

@implementation MandeSeuAloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnView.backgroundColor = [UIColor clearColor];
}


- (IBAction)touchDown:(id)sender {
    self.btnView.isPressed = YES;
    [self.btnView setNeedsDisplay];
}

- (IBAction)beginRecord:(id)sender {
    self.btnView.isPressed = NO;
    [self.btnView setNeedsDisplay];
    
    NSLog(@"iniciando gravação");
}


@end
