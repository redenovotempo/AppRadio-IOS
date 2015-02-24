//
//  MenuViewController.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/7/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "MenuViewController.h"
#import "MuralViewController.h"
#import "MenuItem.h"

@interface MenuViewController ()
@property(nonatomic,strong)NSMutableArray * menuArray;

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
    
    MenuItem * mural = [[MenuItem alloc]initWithKey:@"Mural" AndTitle:NSLocalizedString(@"MURAL", @"Mural")];
    MenuItem * programacao = [[MenuItem alloc]initWithKey:@"Programação" AndTitle:NSLocalizedString(@"PROGRAMACAO", @"Programação")];
    MenuItem * pecaSuaMusica = [[MenuItem alloc]initWithKey:@"Peça sua música" AndTitle:NSLocalizedString(@"PECA_SUA_MUSICA", @"Peça sua música")];
    MenuItem * mandeSeuAlo = [[MenuItem alloc]initWithKey:@"Mande seu alô" AndTitle:NSLocalizedString(@"MANDE_SEU_ALO", @"Mande seu alô")];
    MenuItem * filosofia = [[MenuItem alloc]initWithKey:@"Filosofia" AndTitle:NSLocalizedString(@"FILOSOFIA", @"Filosofia")];
    MenuItem * equipe = [[MenuItem alloc]initWithKey:@"Equipe" AndTitle:NSLocalizedString(@"EQUIPE", @"Equipe")];
    MenuItem * outrosApps = [[MenuItem alloc]initWithKey:@"Outros apps" AndTitle:NSLocalizedString(@"OUTROS_APPS", @"Outros apps")];
    
    
//    menuArray = [NSMutableArray arrayWithObjects:@"Mural",@"Programação",@"Peça sua música",@"Mande seu alô",@"Filosofia",@"Equipe",@"Outros apps",nil];
    self.menuArray = [[NSMutableArray alloc]init];
    self.menuArray = [NSMutableArray arrayWithObjects:mural,programacao,pecaSuaMusica,mandeSeuAlo,filosofia,equipe,outrosApps,nil];

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
    return [self.menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuCell";
    
    MenuCell * cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    MenuItem * currentItem = (MenuItem *) [self.menuArray objectAtIndex:indexPath.row];
    
    cell.lblText.text = currentItem.title;

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

    MenuItem * currentItem = (MenuItem *) [self.menuArray objectAtIndex:indexPath.row];
    
    [appDel ChangeRootViewController:currentItem.key needCloseEffect:YES];

}

@end
