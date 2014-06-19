//
//  PedirMusicaViewController.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 6/19/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "PedirMusicaViewController.h"

@interface PedirMusicaViewController ()
@property (weak, nonatomic) IBOutlet UIButton *enviarBtn;
@property (weak, nonatomic) IBOutlet UITextField *musicTextField;
@property (weak, nonatomic) IBOutlet UITextField *artistTextField;

@end

@implementation PedirMusicaViewController

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
    _enviarBtn.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];
    _enviarBtn.titleLabel.textColor = [UIColor colorWithRed:71.0f/255.0f green:152.0f/255.0f blue:203.0f/255.0f alpha:1];
    
    [_musicTextField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
