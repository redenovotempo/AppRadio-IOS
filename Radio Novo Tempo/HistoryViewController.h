//
//  FilosofiaViewController.h
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 2/11/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HistoryViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;


- (IBAction)OpenMenuButtonPressed:(id)button;


@end
