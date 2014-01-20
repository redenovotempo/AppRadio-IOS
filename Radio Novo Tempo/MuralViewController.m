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
@synthesize imgLoading;

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
    
//    UIView * vi = [[UIView alloc]init];
//    UIImageView  * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading1.png"]];
//    [vi addSubview:img];
//     [self.view addSubview: vi];
//[self runSpinAnimationOnView:vi duration:2 rotations:1 repeat:YES];
    



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
    return [muralItensArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSMutableDictionary * item = [muralItensArray objectAtIndex:indexPath.row];
    
    
        //Twitter
        if ([[item objectForKey:@"type"] isEqualToString:@"twitter"]) {
            
            //Cell utilizada.
            NSString *cellIdentifier = @"MuralTwitterCell";
            
            MuralTwitterCell * cell = (MuralTwitterCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            
            //Serializando Objeto
            MuralTwitter * muraltwitter = [MuralTwitter getFromDictionary:item];
            
            //Limpando cor de fundo
            cell.backgroundColor = [UIColor clearColor];
            
            //Instanciando Imagem pela Tag
            cell.imgViewIcon  = (UIImageView*)[cell viewWithTag:101];
            
            //Criando separator
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
            separatorLineView.backgroundColor = [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1];
            [cell.contentView addSubview:separatorLineView];
            
            //Inserindo Valores
            cell.lblAccount.text = muraltwitter.screenName;
            cell.lblDate.text = muraltwitter.createdDate;
            cell.txtViewContent.text = muraltwitter.message;
           // cell.imgViewIcon.image  = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:muraltwitter.icon]]];
            
        
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:muraltwitter.icon]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
            
            
            return cell;

        }
        
        //Youtube
        else if ([[item objectForKey:@"type"] isEqualToString:@"youtube"]) {
            
            //Cell utilizada.
            NSString * cellIdentifier = @"MuralYoutubeCell";
            MuralYoutubeCell * cell = (MuralYoutubeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            
            //Serializando Objeto
            MuralYoutube * muralYoutube = [MuralYoutube getFromDictionary:item];
            
            //Limpando cor de fundo
            cell.backgroundColor = [UIColor clearColor];
            
            //Instanciando Imagem pela Tag
            cell.imgViewImage  = (UIImageView*)[cell viewWithTag:100];
            cell.imgViewIcon  = (UIImageView*)[cell viewWithTag:101];
            
            //Criando separator
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
            separatorLineView.backgroundColor = [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1];
            [cell.contentView addSubview:separatorLineView];
            
            //Inserindo Valores
            cell.lblDate.text = muralYoutube.createdDate;
            cell.txtViewTitle.text = muralYoutube.title;
            cell.txtViewContent.text = muralYoutube.content;
            //cell.imgViewIcon.image  = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:muralYoutube.icon]]];
            //cell.imgViewImage.image  = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:muralYoutube.image]]];
            
            
            
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:muralYoutube.icon]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
            
            
            [cell.imgViewImage setImageWithURL:[NSURL URLWithString:muralYoutube.image]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
            
            return cell;
        }
        
        //Facebook
        else if ([[item objectForKey:@"type"] isEqualToString:@"facebook"]) {
            MuralFacebook * muralFacebook = [MuralFacebook getFromDictionary:item];
            
            
        }
        
        //Blog
        else if ([[item objectForKey:@"type"] isEqualToString:@"blog"]) {
            
            //Cell utilizada.
            NSString * cellIdentifier = @"MuralBlogCell";
            MuralBlogCell * cell = (MuralBlogCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
            //Serializando Objeto
            MuralBlog * muralBlog = [MuralBlog getFromDictionary:item];
            
            //Instanciando Imagem pela Tag
            cell.imgViewBlog  = (UIImageView*)[cell viewWithTag:100];
            cell.imgViewIcon  = (UIImageView*)[cell viewWithTag:101];
            
            //Limpando cor de fundo
            cell.backgroundColor = [UIColor clearColor];
            
            //Criando separator
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
            separatorLineView.backgroundColor = [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1];
            [cell.contentView addSubview:separatorLineView];
            
            //Inserindo Valores
            cell.lblDate.text = muralBlog.createdDate;
            cell.txtViewTitle.text = muralBlog.title;
            cell.txtViewContent.text = muralBlog.description;
            //cell.imgViewIcon.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:muralBlog.icon]]];
            
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:muralBlog.icon]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
            
            
            if ([muralBlog.image isEqual:[NSNull null]]) {
                cell.imgViewBlog.image = nil;
            }else{
                
                [cell.imgViewBlog setImageWithURL:[NSURL URLWithString:muralBlog.image]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
           
            }
            
            return cell;
        }
        
        //Instagram
        else if ([[item objectForKey:@"type"] isEqualToString:@"instagram"]) {
            
            //Cell utilizada.
            NSString * cellIdentifier = @"MuralInstagramCell";
            MuralInstagramCell * cell = (MuralInstagramCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            
            //Serializando Objeto
            MuralInstagram * muralInstagram = [MuralInstagram getFromDictionary:item];
            
            
            //Instanciando Imagem pela Tag
            cell.imgViewContentImage  = (UIImageView*)[cell viewWithTag:100];
            cell.imgViewIcon  = (UIImageView*)[cell viewWithTag:101];
            
            //Limpando cor de fundo
            cell.backgroundColor = [UIColor clearColor];
            
            //Criando separator
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
            separatorLineView.backgroundColor = [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1];
            [cell.contentView addSubview:separatorLineView];
            
            //Inserindo Valores
            cell.lblAccount.text = muralInstagram.username;
            cell.txtViewContent.text = muralInstagram.description;
            //cell.imgViewIcon.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:muralInstagram.icon]]];
            //cell.imgViewContentImage.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:muralInstagram.image]]];
            
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:muralInstagram.icon]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
            
            [cell.imgViewContentImage setImageWithURL:[NSURL URLWithString:muralInstagram.image]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
            
   
            return cell;

    }
    

    UITableViewCell *cell = [muralTableView cellForRowAtIndexPath:indexPath];
    
    // NOTE: Add some code like this to create a new cell if there are none to reuse
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    NSDictionary * dict = [muralItensArray objectAtIndex:indexPath.row];
    
    //Twitter
    if ([[dict objectForKey:@"type"] isEqualToString:@"twitter"]) {
        MuralTwitterCell * cell = (MuralTwitterCell *)[tableView dequeueReusableCellWithIdentifier:@"MuralTwitterCell"];
        return cell.contentView.frame.size.height;
    }
    
    //Youtube
    if ([[dict objectForKey:@"type"] isEqualToString:@"youtube"]) {
        MuralYoutubeCell * cell = (MuralYoutubeCell *)[tableView dequeueReusableCellWithIdentifier:@"MuralYoutubeCell"];
        return cell.contentView.frame.size.height;
    }
    
    //Instagram
    if ([[dict objectForKey:@"type"] isEqualToString:@"instagram"]) {
        MuralInstagramCell * cell = (MuralInstagramCell *)[tableView dequeueReusableCellWithIdentifier:@"MuralInstagramCell"];
        return cell.contentView.frame.size.height;
    }
    
    //Blog
    if ([[dict objectForKey:@"type"] isEqualToString:@"blog"]) {
        MuralBlogCell * cell = (MuralBlogCell *)[tableView dequeueReusableCellWithIdentifier:@"MuralBlogCell"];
        return cell.contentView.frame.size.height;
    }
    
    return 0;
    
  
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

-(IBAction)rotate:(id)sender{
    [UIView animateWithDuration:1.5 delay:2.0 options:UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:20];
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        imgLoading.transform = CGAffineTransformRotate(imgLoading.transform, 180.0);
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
        //imgLoading.hidden = YES;
    }];
}





@end
