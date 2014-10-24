//
//  PedirMusicaViewController.h
//  Radio Novo Tempo
//
//  Created by MacMichas on 6/19/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MessageUI;

@interface PedirMusicaViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic)BOOL needResetAnimation;
@end
