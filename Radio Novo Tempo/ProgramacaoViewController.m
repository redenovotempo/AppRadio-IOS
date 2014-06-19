//
//  ProgramacaoViewController.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 6/18/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "ProgramacaoViewController.h"
#import "ArgButton.h"
#import "ProgramacaoTableViewCell.h"

@interface ProgramacaoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollDays;
@property(nonatomic,strong) NSArray * programingItems;

@end

@implementation ProgramacaoViewController

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
    
    [self setupScrollDays];
    
    _programingItems = @[@"Nisto Cremos",@"Tempos de Oração",@"Mais Perto",@"Cada dia"];
    
}

-(void)setupScrollDays{
    
    _scrollDays.contentSize = CGSizeMake(50*7 + 15, 56);
    _scrollDays.showsHorizontalScrollIndicator = NO;
    
    ArgButton * domingo = [[ArgButton alloc]initWithFrame:CGRectMake(0, 0, 70, 50)];
    domingo.ArgNumber1 = [NSNumber numberWithInt:1];
    domingo.ArgString1 = @"Dom";
    [self setupScrollDaysButton:domingo];
    [self callJsonPrograming:domingo];
    ArgButton * segunda = [[ArgButton alloc]initWithFrame:CGRectMake(50, 0, 70, 50)];
    segunda.ArgNumber1 = [NSNumber numberWithInt:2];
    segunda.ArgString1 = @"Seg";
    [self setupScrollDaysButton:segunda];
    ArgButton * terca = [[ArgButton alloc]initWithFrame:CGRectMake(100, 0, 70, 50)];
    terca.ArgNumber1 = [NSNumber numberWithInt:3];
    terca.ArgString1 = @"Ter";
    [self setupScrollDaysButton:terca];
    ArgButton * quarta = [[ArgButton alloc]initWithFrame:CGRectMake(150, 0, 70, 50)];
    quarta.ArgNumber1 = [NSNumber numberWithInt:4];
    quarta.ArgString1 = @"Qua";
    [self setupScrollDaysButton:quarta];
    ArgButton * quinta = [[ArgButton alloc]initWithFrame:CGRectMake(200, 0, 70, 50)];
    quinta.ArgNumber1 = [NSNumber numberWithInt:5];
    quinta.ArgString1 = @"Qui";
    [self setupScrollDaysButton:quinta];
    ArgButton * sexta = [[ArgButton alloc]initWithFrame:CGRectMake(250, 0, 70, 50)];
    sexta.ArgNumber1 = [NSNumber numberWithInt:6];
    sexta.ArgString1 = @"Sex";
    [self setupScrollDaysButton:sexta];
    ArgButton * sabado = [[ArgButton alloc]initWithFrame:CGRectMake(300, 0, 70, 50)];
    sabado.ArgNumber1 = [NSNumber numberWithInt:7];
    sabado.ArgString1 = @"Sáb";
    [self setupScrollDaysButton:sabado];
    
}

-(void)setupScrollDaysButton:(ArgButton *)sender{
    sender.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:15];
    sender.titleLabel.textColor = [UIColor whiteColor];
    [sender setTitle:sender.ArgString1 forState:UIControlStateNormal];
    [sender setTitleColor:[self getBlueColor] forState:UIControlStateHighlighted];
    [sender setTitleColor:[self getBlueColor] forState:UIControlStateSelected];
    [sender addTarget:self action:@selector(callJsonPrograming:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollDays addSubview:sender];
}

-(void)callJsonPrograming:(ArgButton *)sender{
    //Resetando cores dos botoes no scroll.
    [self changeButtonsTextColorToWhiteInScrollDays];
    
    //Selecionando o item chamado.
    [sender setTitleColor:[self getBlueColor] forState:UIControlStateNormal];
}

-(void)changeButtonsTextColorToWhiteInScrollDays{
    for (ArgButton * item in _scrollDays.subviews) {
        if ([item isMemberOfClass:[ArgButton class]]) {
           [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

-(UIColor *)getBlueColor{
    return [UIColor colorWithRed:57.0f/255.0f green:157.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _programingItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProgramacaoTableViewCell* cell = (ProgramacaoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textlbl.text = _programingItems[indexPath.row];
    cell.timelbl.text = @"15:45";
    return cell;
}
@end
