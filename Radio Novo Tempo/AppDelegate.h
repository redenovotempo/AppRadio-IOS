//
//  AppDelegate.h
//  Radio Novo Tempo
//
//  Created by MacMichas on 10/20/13.
//  Copyright (c) 2013 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flurry.h"

@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Reachability *internetReach;
}
@property (strong, nonatomic) UIWindow * window;
@property(nonatomic,assign)BOOL hasInternet;
-(BOOL)CheckInternetConnection;
@end