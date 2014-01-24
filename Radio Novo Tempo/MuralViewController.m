//
//  MuralViewController.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 1/12/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "MuralViewController.h"
#define MAX_HEIGHT 2000;

@interface MuralViewController ()

@end



@implementation MuralViewController

@synthesize muralTableView;
@synthesize imgLoading;
@synthesize loadingView;
@synthesize urlConnection;
@synthesize urlData;

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

    
    if (muralItensArray.count == 0) {
        [self CallMuralJsonData];
    }
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
            cell.lblDate.text = [self dateFormat:muraltwitter.createdDate :@"dd/MM/yyyy"];
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
            cell.lblDate.text = [self dateFormat:muralYoutube.createdDate:@"dd/MM/yyyy"];
            cell.txtViewContent.text = muralYoutube.title;
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:muralYoutube.icon]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
            [cell.imgViewImage setImageWithURL:[NSURL URLWithString:muralYoutube.image]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
            
            //Criando botao
            [cell.btnActionExecute addTarget: self
                      action: @selector(Plyer)
            forControlEvents: UIControlEventTouchUpInside];
            
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
            cell.lblDate.text = [self dateFormat:muralBlog.createdDate :@"dd/MM/yyyy"];
            cell.txtViewTitle.text = muralBlog.title;
            cell.txtViewContent.text = muralBlog.description;
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:muralBlog.icon]
                             placeholderImage:[UIImage imageNamed:@"loading4.png"] options:SDWebImageRefreshCached];
            
            //Verificando se existe imagem no Blog
            if ([muralBlog.image isEqual:[NSNull null]]) {
                cell.imgViewBlog.hidden = YES;
            }else{
                cell.imgViewBlog.hidden = NO;
                [cell.imgViewBlog setImageWithURL:[NSURL URLWithString:muralBlog.image]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
            }
            
            //Concertando altura dos textos de acordo com o texto
            CGRect frameTxtViewContent = cell.txtViewContent.frame;
            frameTxtViewContent.size.height = cell.txtViewContent.contentSize.height;
            cell.txtViewContent.frame = frameTxtViewContent;
            
            //Concertando altura dos textos de acordo com o texto
            CGRect frameTxtViewTitle = cell.txtViewTitle.frame;
            frameTxtViewTitle.size.height = cell.txtViewTitle.contentSize.height;
            cell.txtViewTitle.frame = frameTxtViewTitle;
            
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
    
    //Iniciando View de loading
    [self StartLoading];
    
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Create Request Values
    NSString * action = @"mural";
    NSNumber * idRadio = appDel.radioCurrent.radioId;
    
    //Chamando JSON
    NSString * adress = [NSString stringWithFormat:@"http://novotempo.com/api/radio/?action=%@&idRadio=%@",action,idRadio];
    
    NSString * post = [[NSString alloc]init];
    NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:adress]];
    [request setHTTPMethod:@"POST"]; // 1
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"]; // 2
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    

    
    urlConnection = [[NSURLConnection alloc]init];
    urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];

    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    urlData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [urlData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *jsonParsingError = nil;
    
    NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&jsonParsingError];
    
    if (jsonParsingError)
        NSLog (@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
        
    muralItensArray = [resultados objectForKey:@"mural"];
    [muralTableView reloadData];

    //Terminando View de loading
    [loadingView removeFromSuperview];
}



-(void)StartLoading{
    
    //Iniciando LoadingView
    loadingView = [[UIView alloc]init];
    
    //Criando componentes
    UIImageView  * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading.png"]];
    UILabel * txt = [[UILabel alloc]init];
    txt.text = @"Carregando...";
    txt.textColor = [UIColor colorWithRed:(0/255.0) green:(91/255.0) blue:(149/255.0) alpha:1];


    //Criando animaçao
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat: M_PI * 2.0  * 1 * 10 ];
    rotate.duration = 10;
    rotate.repeatCount = INFINITY;
    rotate.delegate = self;
    rotate.fillMode = kCAFillModeForwards;
    rotate.removedOnCompletion = NO;
    
    //Alinhando Componentes
    img.center = muralTableView.center;
    img.frame = CGRectMake(img.frame.origin.x, img.frame.origin.y - 120, img.frame.size.width, img.frame.size.height);
    [img.layer addAnimation:rotate forKey:@"10"];
    txt.frame = CGRectMake(img.frame.origin.x + 10, img.frame.origin.y + 100, img.frame.size.width, img.frame.size.height);
    
    //Inserindo Componentes na LoadingView
    [loadingView addSubview:txt];
    [loadingView addSubview:img];
    
    
    //Alinhando LoadingView
    loadingView.center = muralTableView.center;
    loadingView.frame = muralTableView.frame;
    
    //Alterando Cor de Fundo da LoadingView
    loadingView.backgroundColor = [UIColor whiteColor];

    //Inserindo LoadingView na View principal
    [self.view addSubview: loadingView];
    
}


//Metodo de criaçao de data.
-(NSString *)dateFormat:(NSString *)dateString :(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:dateFromString];
    return strDate;
}

-(void)Plyer{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=TCr-GCR0ios"]];
}


@end
