//
//  FilosofiaViewController.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 2/11/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "FilosofiaViewController.h"

@interface FilosofiaViewController ()

@end

@implementation FilosofiaViewController

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
    NSString * stringUrl = @"http://novotempo.com";
    NSURL * url  = [[NSURL alloc]initWithString:stringUrl];
    NSURLRequest * req = [[NSURLRequest alloc]initWithURL:url];
    
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.actIndicator stopAnimating];
     self.actIndicator.hidden = YES;
}

- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



@end
