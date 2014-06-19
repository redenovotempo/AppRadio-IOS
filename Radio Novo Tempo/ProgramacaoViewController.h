//
//  ProgramacaoViewController.h
//  Radio Novo Tempo
//
//  Created by MacMichas on 6/18/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgramacaoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic)BOOL needResetAnimation;
@end
