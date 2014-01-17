//
//  MuralViewController.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/12/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "MuralViewController.h"

@interface MuralViewController ()

@end


@implementation MuralViewController

@synthesize muralTableView;

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
    
    [self CallMuralJsonData];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [[NSString alloc] init];
    
    
    for (NSMutableDictionary * item in muralItensArray){
        
        if ([[item objectForKey:@"type"] isEqualToString:@"twitter"]) {
            MuralTwitter * muraltwitter = [MuralTwitter getFromDictionary:item];
        }
        if ([[item objectForKey:@"type"] isEqualToString:@"youtube"]) {
            MuralYoutube * muralYoutube = [MuralYoutube getFromDictionary:item];
        }
        if ([[item objectForKey:@"type"] isEqualToString:@"facebook"]) {
            MuralFacebook * muralFacebook = [MuralFacebook getFromDictionary:item];
        }
        if ([[item objectForKey:@"type"] isEqualToString:@"blog"]) {
            MuralBlog * muralBlog = [MuralBlog getFromDictionary:item];
        }
    }
    
    
    
    
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 5) {
        
        cellIdentifier = @"MuralBlogCell";
        
        MuralBlogCell * cell = (MuralBlogCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //Limpando cor de fundo
        cell.backgroundColor = [UIColor clearColor];
        
        //Criando separator
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
        separatorLineView.backgroundColor = [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1];
        
        [cell.contentView addSubview:separatorLineView];
    
        return cell;
    }
    
    if (indexPath.row == 8) {
        
        cellIdentifier = @"MuralYoutubeCell";
        
        MuralYoutubeCell * cell = (MuralYoutubeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //Limpando cor de fundo
        cell.backgroundColor = [UIColor clearColor];
        
        //Criando separator
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
        separatorLineView.backgroundColor = [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1];
        
        [cell.contentView addSubview:separatorLineView];
        
        return cell;
    }
    
    if (indexPath.row == 2 || indexPath.row == 4 ) {
        
        cellIdentifier = @"MuralInstagramCell";
        
        MuralInstagramCell * cell = (MuralInstagramCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //Limpando cor de fundo
        cell.backgroundColor = [UIColor clearColor];
        
        //Criando separator
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
        separatorLineView.backgroundColor = [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1];
        
        [cell.contentView addSubview:separatorLineView];
        
        return cell;
    }
    
    
    cellIdentifier = @"MuralTwitterCell";
    
    MuralTwitterCell * cell = (MuralTwitterCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Limpando cor de fundo
    cell.backgroundColor = [UIColor clearColor];
    
    //Criando separator
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
    separatorLineView.backgroundColor = [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1];
    
    [cell.contentView addSubview:separatorLineView];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row == 2 || indexPath.row == 4) {
        
        NSString * cellIdentifier = @"MuralInstagramCell";
        
        MuralInstagramCell * cell = (MuralInstagramCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        return cell.contentView.frame.size.height;

    }
    
    if (indexPath.row == 8) {
        
        NSString *  cellIdentifier = @"MuralYoutubeCell";
        
        MuralYoutubeCell * cell = (MuralYoutubeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        return cell.contentView.frame.size.height;
    }
    
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 5) {
        
       NSString * cellIdentifier = @"MuralBlogCell";
        
        MuralBlogCell * cell = (MuralBlogCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        return cell.contentView.frame.size.height;
    }
    
    NSString * cellIdentifier = @"MuralTwitterCell";
    
    MuralTwitterCell * cell = (MuralTwitterCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    
    return cell.contentView.frame.size.height;

}


- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


-(void)CallMuralJsonData{
    
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    //Create Request Values
    NSString * action = @"mural";
    NSNumber * idRadio = appDel.radioCurrent.radioId;
    
    
    //Chamando JSON
    NSString * adress = [NSString stringWithFormat:@"http://novotempo.com/api/radio/?action=%@&idRadio=%@",action,idRadio];
    
    NSData * adressData = [NSData dataWithContentsOfURL: [NSURL URLWithString:adress]];
    
    NSError *error;
    NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:adressData
                                                               options:NSJSONReadingMutableContainers error:&error];
    
    muralItensArray = [resultados objectForKey:@"mural"];
}



@end
