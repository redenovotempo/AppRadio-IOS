//
//  EquipeDadosCell.h
//  Radio Novo Tempo
//
//  Created by MacMichas on 3/2/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipeDadosCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextView *txtValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end
