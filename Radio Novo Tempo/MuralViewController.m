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
            
            
            //Calculando altura do titulo
            cell.constraintTitleHeight.constant = [self textViewHeightForAttributedText:muralYoutube.title andWidth:280 andFont:[UIFont systemFontOfSize:15]];
            
            //Criando separator
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
            separatorLineView.backgroundColor = [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1];
            [cell.contentView addSubview:separatorLineView];
            
            
            //Inserindo Valores
            cell.lblDate.text = [self dateFormat:muralYoutube.createdDate:@"dd/MM/yyyy"];
            cell.txtViewTitle.text = muralYoutube.title;
            cell.txtViewContent.text = muralYoutube.content;
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:muralYoutube.icon]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
            [cell.imgViewImage setImageWithURL:[NSURL URLWithString:muralYoutube.image]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
            
           
            
            //Criando botao
            cell.btnActionExecute.ArgString1 = muralYoutube.link;
            [cell.btnActionExecute addTarget: self
                                      action: @selector(ExecuteOnSafari:)
            forControlEvents: UIControlEventTouchUpInside];
            
            return cell;
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
            
            //acao do share para os butons
            [cell.btnShare addTarget:self action:@selector(shareMuralItem:) forControlEvents:UIControlEventTouchUpInside];
            
            
            //Calculando altura do titulo
            cell.constraintTitleHeight.constant = [self textViewHeightForAttributedText:muralBlog.title andWidth:280 andFont:[UIFont systemFontOfSize:15]];
            
            
            //Verificando se existe imagem no Blog
            if ([muralBlog.image isEqual:[NSNull null]]) {
                cell.constraintImgHeight.constant = 0;
                cell.imgViewBlog.hidden = YES;
                
            }else{
                cell.constraintImgHeight.constant = 180;
                cell.imgViewBlog.hidden = NO;
                [cell.imgViewBlog setImageWithURL:[NSURL URLWithString:muralBlog.image]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
                
            }
            
            return cell;
        }
    
        //Facebook
        else if ([[item objectForKey:@"type"] isEqualToString:@"facebook"]) {
            
            //Cell utilizada.
            NSString * cellIdentifier = @"MuralFacebookCell";
            MuralFacebookCell * cell = (MuralFacebookCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            //Serializando Objeto
            MuralFacebook * muralFacebook = [MuralFacebook getFromDictionary:item];
            
            //Instanciando Imagem pela Tag
            cell.imgViewFacebook  = (UIImageView*)[cell viewWithTag:100];
            cell.imgViewIcon  = (UIImageView*)[cell viewWithTag:101];
            
            //Limpando cor de fundo
            cell.backgroundColor = [UIColor clearColor];
            
            //Criando separator
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
            separatorLineView.backgroundColor = [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1];
            [cell.contentView addSubview:separatorLineView];
            
            //Inserindo Valores
            cell.lblDate.text = [self dateFormat:muralFacebook.createdDate :@"dd/MM/yyyy"];
            cell.txtViewContent.text = muralFacebook.message;
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:muralFacebook.icon]
                             placeholderImage:[UIImage imageNamed:@"loading4.png"] options:SDWebImageRefreshCached];
            
            //acao do share para os butons
            [cell.btnShare addTarget:self action:@selector(shareMuralItem:) forControlEvents:UIControlEventTouchUpInside];
            
            //verificando likes
            if ([muralFacebook.likes intValue] != 0) {
                
                [cell.btnLikes setTitle:[NSString stringWithFormat:@"%@",muralFacebook.likes] forState: UIControlStateNormal];
                cell.btnLikes.imageEdgeInsets =  UIEdgeInsetsMake(0, 0, 0, 11);
                
                UIImage *btnImage = [UIImage imageNamed:@"iconLoveBlue.png"];
                [cell.btnLikes  setImage:btnImage forState:UIControlStateNormal];
            }
            
            
            
            //Verificando se existe imagem no Facebook
            if ([muralFacebook.picture isEqual:[NSNull null]] || [muralFacebook.picture isEqualToString:@""]) {
                cell.constraintImgHeight.constant = 0;
                cell.imgViewFacebook.hidden = YES;
                
            }else{
                cell.constraintImgHeight.constant = 180;
                cell.imgViewFacebook.hidden = NO;
                [cell.imgViewFacebook setImageWithURL:[NSURL URLWithString:muralFacebook.picture]
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
    
    NSLog(@"%@",adress);
    
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
    img.frame = CGRectMake(img.frame.origin.x, img.frame.origin.y - 80, img.frame.size.width, img.frame.size.height);
    [img.layer addAnimation:rotate forKey:@"10"];
    txt.frame = CGRectMake(img.frame.origin.x + 10, img.frame.origin.y + 85, img.frame.size.width, img.frame.size.height);
    
    //Inserindo Componentes na LoadingView
    [loadingView addSubview:txt];
    [loadingView addSubview:img];
    
    
    //Alinhando LoadingView
    loadingView.center = self.view.center;
    loadingView.frame =  CGRectMake(self.view.frame.origin.x, 73, self.view.frame.size.width, self.view.frame.size.height);
    
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

-(void)ExecuteOnSafari:(id)sender{
    ArgButton * argButton = (ArgButton *)sender;
    if (argButton.ArgString1.length != 0 && argButton.ArgString1 != nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:argButton.ArgString1]];
    }
}


- (CGSize)text:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
  return [text sizeWithFont:font constrainedToSize:size];

}

- (CGFloat)textViewHeightForAttributedText: (NSString*)textString andWidth: (CGFloat)width andFont:(UIFont *)font{
    
    NSData* data = [textString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithData:data
                                                               options:nil
                                                    documentAttributes:NULL
                                                                 error:NULL];
    
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    
    CGSize sizeWithFont = [self text:textString sizeWithFont:font constrainedToSize:calculationView.frame.size];
    
    return size.height + sizeWithFont.height+3.5;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary * dict = [muralItensArray objectAtIndex:indexPath.row];
    
    //Twitter
    if ([[dict objectForKey:@"type"] isEqualToString:@"twitter"]) {
        
        //Serializando Objeto
        MuralTwitter * muralTwitter = [MuralTwitter getFromDictionary:dict];
        

        CGFloat REST_ELEMENTS_SIZE = 60;
        CGFloat PADDING_BOTTOM = 40;
        
        CGFloat DESCRIPTION_SIZE = [self textViewHeightForAttributedText:muralTwitter.message andWidth:280 andFont:[UIFont systemFontOfSize:14]];
        
        
        return REST_ELEMENTS_SIZE+DESCRIPTION_SIZE+PADDING_BOTTOM;
    }
    
    //Youtube
    if ([[dict objectForKey:@"type"] isEqualToString:@"youtube"]) {
        
        //Serializando Objeto
        MuralYoutube * muralYoutube = [MuralYoutube getFromDictionary:dict];
       
        CGFloat IMG_SIZE = 180;
        CGFloat REST_ELEMENTS_SIZE = 74;
        CGFloat PADDING_BOTTOM = 40;
        
        CGFloat DESCRIPTION_SIZE = [self textViewHeightForAttributedText:muralYoutube.content andWidth:280 andFont:[UIFont systemFontOfSize:14]];
        CGFloat TITLE_SIZE = [self textViewHeightForAttributedText:muralYoutube.title andWidth:280 andFont:[UIFont systemFontOfSize:15]];

         return REST_ELEMENTS_SIZE+IMG_SIZE+DESCRIPTION_SIZE+TITLE_SIZE+PADDING_BOTTOM;
    }
    
    //Instagram
    if ([[dict objectForKey:@"type"] isEqualToString:@"instagram"]) {
        
        //Serializando Objeto
        MuralInstagram * muralInstagram = [MuralInstagram getFromDictionary:dict];
        
        CGFloat IMG_SIZE = 320;
        CGFloat REST_ELEMENTS_SIZE = 74;
        CGFloat PADDING_BOTTOM = 40;
        CGFloat DESCRIPTION_SIZE = [self textViewHeightForAttributedText:muralInstagram.description andWidth:280 andFont:[UIFont systemFontOfSize:14]];
        
        return IMG_SIZE+REST_ELEMENTS_SIZE+PADDING_BOTTOM+DESCRIPTION_SIZE;
    }
    
    //Blog
    if ([[dict objectForKey:@"type"] isEqualToString:@"blog"]) {
       
        //Serializando Objeto
        MuralBlog * muralBlog = [MuralBlog getFromDictionary:dict];
        
        
        CGFloat IMG_SIZE = 180;
        CGFloat REST_ELEMENTS_SIZE = 74;
        CGFloat PADDING_BOTTOM = 40;
        CGFloat BUTTONS = 40;
        CGFloat DESCRIPTION_SIZE = [self textViewHeightForAttributedText:muralBlog.description andWidth:280 andFont:[UIFont systemFontOfSize:14]];
        CGFloat TITLE_SIZE = [self textViewHeightForAttributedText:muralBlog.title andWidth:280 andFont:[UIFont systemFontOfSize:15]];

        
        //Verificando se existe imagem no Blog
        if ([muralBlog.image isEqual:[NSNull null]]) {
            IMG_SIZE = 0;
        }
        return REST_ELEMENTS_SIZE+IMG_SIZE+DESCRIPTION_SIZE+TITLE_SIZE+PADDING_BOTTOM+BUTTONS;
    }
    
    //Facebook
    if ([[dict objectForKey:@"type"] isEqualToString:@"facebook"]) {
        
        //Serializando Objeto
        MuralFacebook * muralFacebook = [MuralFacebook getFromDictionary:dict];
        
        CGFloat IMG_SIZE = 180;
        CGFloat REST_ELEMENTS_SIZE = 74;
        CGFloat PADDING_BOTTOM = 50;
        CGFloat DESCRIPTION_SIZE = [self textViewHeightForAttributedText:muralFacebook.message andWidth:280 andFont:[UIFont systemFontOfSize:14]];
    
        
        //Verificando se existe imagem no Blog
        if ([muralFacebook.picture isEqual:[NSNull null]] || [muralFacebook.picture isEqualToString:@""]){
            IMG_SIZE = 0;
        }
        return REST_ELEMENTS_SIZE+IMG_SIZE+DESCRIPTION_SIZE+PADDING_BOTTOM;
    }
    
    return 0;
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    //Escondendo player
    if(y >= h-3) {
        self.containerView.hidden = YES;
    }else{
        self.containerView.hidden = NO;
        //NSLog(@"%f = y e %f = h",y,h+3);
    }
    
}

-(void)shareMuralItem:(id)sender{
    
    NSString* shareText = [NSString stringWithFormat:@"Compartilhando..."];
    
    NSArray* dataToShare = @[shareText];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:^{}];
}


@end
