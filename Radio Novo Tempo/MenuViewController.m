//
//  MenuViewController.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/7/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "MenuViewController.h"
#import "MuralViewController.h"

@interface MenuViewController ()

@end




@implementation MenuViewController

@synthesize menuTableView;

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
    
    menuArray = [NSMutableArray arrayWithObjects:@"Mural",@"Programação",@"Peça sua música",@"Equipe",@"História da Rádio",@"Mande seu alô",nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuCell";
    
    MenuCell * cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    cell.lblText.text = [menuArray objectAtIndex:indexPath.row];

    //Limpando cor de fundo
    cell.backgroundColor = [UIColor clearColor];
    
    //Criando cor de seleçao
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:(52/255.0) green:(141/255.0) blue:(185/255.0) alpha:0.6];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MenuCell * cell = (MenuCell *)[menuTableView cellForRowAtIndexPath:indexPath];

    [appDel ChangeRootViewController:cell.lblText.text needCloseEffect:YES];

}

@end
