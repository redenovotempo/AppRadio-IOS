//
//  MandeSeuAloViewController.h
//  Radio Novo Tempo
//
//  Created by MacMichas on 2/11/15.
//  Copyright (c) 2015 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
@import MessageUI;

@interface MandeSeuAloViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate,MFMailComposeViewControllerDelegate>

@end
