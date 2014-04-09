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

@property(nonatomic)NSString * sharedText;


@end



@implementation MuralViewController

@synthesize imgLoading;
@synthesize loadingView;
@synthesize urlConnection;

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
    
    //Instanciando valores
    self.muralItensArray = [[NSMutableArray alloc]init];
    self.muralItensArray2 = [[NSMutableArray alloc]init];
    
    
    
    //Observando Framework de menu para quando abrir chamar este metodo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rotateBtnOpenMenu)
                                                 name:@"GestureOpenMenu"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unRotateBtnOpenMenu)
                                                 name:@"GestureCloseMenu"
                                               object:nil];
    
    //Need To reset Animation
    self.needResetAnimation = NO;
    
    self.sharedText = [[NSString alloc]init];
    [self MainExecution];
    
}



-(void)MainExecution{
    
    if (![self CheckInternetConnection]) {
        [self InternetConnectionErrorMessage];
    }else{
        if (self.muralItensArray.count == 0) {
            [self CallMuralJsonData];
        }
    }
}


-(BOOL)CheckInternetConnection{
    
    //Check Internet Connection.
    AppDelegate * apDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return apDel.CheckInternetConnection;
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
    if (tableView == self.muralTableView) {
        return [self.muralItensArray count];
    }else{
        return [self.muralItensArray2 count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
    
    if (tableView == self.muralTableView) {
        item = [self.muralItensArray objectAtIndex:indexPath.row];
    }else{
        item = [self.muralItensArray2 objectAtIndex:indexPath.row];
    }
    
    
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
            cell.lblAccount.text =[self checkText:muraltwitter.screenName];
            cell.lblDate.text = [self dateFormat:muraltwitter.createdDate :@"dd/MM/yyyy"];
            
            
            
            //Identificando Links.
            cell.txtViewContent.text = nil;
            cell.txtViewContent.editable = NO;
            cell.txtViewContent.delegate = self;
            cell.txtViewContent.userInteractionEnabled  = YES;
            cell.txtViewContent.dataDetectorTypes = UIDataDetectorTypeLink;
            cell.txtViewContent.text = [self checkText:muraltwitter.message];
            
            
            
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:[self checkText:muraltwitter.icon]]
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
            cell.txtViewTitle.text = [self checkText:muralYoutube.title];
            
            //Identificando Links.
            cell.txtViewContent.text = nil;
            cell.txtViewContent.editable = NO;
            cell.txtViewContent.delegate = self;
            cell.txtViewContent.userInteractionEnabled  = YES;
            cell.txtViewContent.dataDetectorTypes = UIDataDetectorTypeLink;
            cell.txtViewContent.text = [self checkText:muralYoutube.content];

            
            
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:[self checkText:muralYoutube.icon]]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
            [cell.imgViewImage setImageWithURL:[NSURL URLWithString:[self checkText:muralYoutube.image]]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
            
           
            
            //Criando botao
            cell.btnActionExecute.ArgString1 = [self checkText:muralYoutube.link];
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
            cell.lblDate.text = [self dateFormat:[self checkText:muralBlog.createdDate] :@"dd/MM/yyyy"];
            cell.txtViewTitle.text = [self checkText:muralBlog.title];
            
            //Identificando Links.
            cell.txtViewContent.text = nil;
            cell.txtViewContent.editable = NO;
            cell.txtViewContent.delegate = self;
            cell.txtViewContent.userInteractionEnabled  = YES;
            cell.txtViewContent.dataDetectorTypes = UIDataDetectorTypeLink;
            cell.txtViewContent.text = [self checkText:muralBlog.description];
            
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:[self checkText:muralBlog.icon]]
                             placeholderImage:[UIImage imageNamed:@"loading4.png"] options:SDWebImageRefreshCached];
            
            //acao do share para os butons
            cell.btnShare = [[ArgButton alloc]init];
            cell.btnShare.tag = 501;
            cell.btnShare.ArgString1 = muralBlog.url;
            self.sharedText = muralBlog.url;
            [cell.btnShare addTarget:self action:@selector(shareMuralItem:) forControlEvents:UIControlEventTouchUpInside];
            
            
            //Calculando altura do titulo
            cell.constraintTitleHeight.constant = [self textViewHeightForAttributedText:[self checkText:muralBlog.title] andWidth:280 andFont:[UIFont systemFontOfSize:15]];
            
            
            //Verificando se existe imagem no Blog
            if ([muralBlog.image isEqual:[NSNull null]] || [muralBlog.image isEqual:@""]) {
                cell.constraintImgHeight.constant = 0;
                cell.imgViewBlog.hidden = YES;
                
            }else{
                cell.constraintImgHeight.constant = 180;
                cell.imgViewBlog.hidden = NO;
                [cell.imgViewBlog setImageWithURL:[NSURL URLWithString:[self checkText:muralBlog.image]]
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
            cell.lblDate.text = [self dateFormat:[self checkText:muralFacebook.createdDate]:@"dd/MM/yyyy"];
            
            //Identificando Links.
            cell.txtViewContent.text = nil;
            cell.txtViewContent.editable = NO;
            cell.txtViewContent.delegate = self;
            cell.txtViewContent.userInteractionEnabled  = YES;
            cell.txtViewContent.dataDetectorTypes = UIDataDetectorTypeLink;
            cell.txtViewContent.text = [self checkText:muralFacebook.message];
            
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:[self checkText:muralFacebook.icon]]
                             placeholderImage:[UIImage imageNamed:@"loading4.png"] options:SDWebImageRefreshCached];
            
            //acao do share para os butons
            self.sharedText = muralFacebook.message;
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
            cell.lblAccount.text = [self checkText:muralInstagram.username];
            
            //Identificando Links.
            cell.txtViewContent.text = nil;
            cell.txtViewContent.editable = NO;
            cell.txtViewContent.delegate = self;
            cell.txtViewContent.userInteractionEnabled  = YES;
            cell.txtViewContent.dataDetectorTypes = UIDataDetectorTypeLink;
            cell.txtViewContent.text = [self checkText:muralInstagram.description];
            
            
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:[self checkText:muralInstagram.icon]]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
            [cell.imgViewContentImage setImageWithURL:[NSURL URLWithString:[self checkText:muralInstagram.image]]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
            
   
            return cell;

    }
    
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (tableView == self.muralTableView) {
        cell = [self.muralTableView cellForRowAtIndexPath:indexPath];
    }else{
        cell = [self.muralTableView2 cellForRowAtIndexPath:indexPath];
    }
    
    
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
    
    
    //Tratar items para ipad em duas colunas ou iphone em uma coluna.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        //self.muralItensArray = [resultados objectForKey:@"mural"];
        NSMutableArray * tempArray = [resultados objectForKey:@"mural"];
        
        //Varrendo array e separando numeros impares de pares nas duas listas do Ipad.
        for (NSDictionary * item in tempArray) {
            if ([tempArray indexOfObject:item]%2) {
                [self.muralItensArray addObject:item];
            }else{
                [self.muralItensArray2 addObject:item];
            }
        }
 
    }else{
        
        self.muralItensArray = [resultados objectForKey:@"mural"];
    }


    //Terminando View de loading
    [loadingView removeFromSuperview];
    
    if (jsonParsingError || !self.muralItensArray){
        NSLog (@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
        [self InternetConnectionErrorMessage];
    }else{
        [self.muralTableView reloadData];
        [self.muralTableView2 reloadData];
    }
}

-(void)InternetConnectionErrorMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops" message:@"Não é possível conectar. Talvez você não tenha conexão com a internet, certifique-se disso." delegate:self cancelButtonTitle:@"Tentar Novamente" otherButtonTitles: nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self MainExecution];
    }
}


-(void)StartLoading{
    
    //Iniciando LoadingView
    self.loadingView = [[UIView alloc]init];
    
    //Criando componentes
    UIImageView  * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading.png"]];
    UILabel * txt = [[UILabel alloc]init];
    txt.text = @"Carregando...";
    txt.font = [UIFont fontWithName:@"ProximaNova-Light" size:18];
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
    img.center = self.view.center;
    img.frame = CGRectMake(img.frame.origin.x, img.frame.origin.y - 80, img.frame.size.width, img.frame.size.height);
    [img.layer addAnimation:rotate forKey:@"10"];
    txt.frame = CGRectMake(img.frame.origin.x + 10, img.frame.origin.y + 85, img.frame.size.width, img.frame.size.height);
    
    //Inserindo Componentes na LoadingView
    [self.loadingView addSubview:txt];
    [self.loadingView addSubview:img];
    
    
    //Alinhando LoadingView
    self.loadingView.center = self.view.center;
    self.loadingView.frame =  CGRectMake(self.view.frame.origin.x, 73, self.view.frame.size.width, self.view.frame.size.height);
    
    //Alterando Cor de Fundo da LoadingView
    self.loadingView.backgroundColor = [UIColor whiteColor];
    
    //Inserindo LoadingView na View principal
    [self.view addSubview: self.loadingView];
    
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

- (CGSize)text:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
  return [text sizeWithFont:font constrainedToSize:size];

}

- (CGFloat)textViewHeightForAttributedText: (NSString*)textString andWidth: (CGFloat)width andFont:(UIFont *)font{
    
    
    if ([textString isEqual:[NSNull null]] || [textString isEqual:@""] || !textString) {
        return 5;
    }
    
    
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
    
    NSDictionary * dict = [[NSDictionary alloc]init];
    
    if (tableView == self.muralTableView) {
        dict = [self.muralItensArray objectAtIndex:indexPath.row];
    }else{
        dict = [self.muralItensArray2 objectAtIndex:indexPath.row];
    }
    
    
    //Twitter
    if ([[dict objectForKey:@"type"] isEqualToString:@"twitter"]) {
        
        //Serializando Objeto
        MuralTwitter * muralTwitter = [MuralTwitter getFromDictionary:dict];
        

        CGFloat REST_ELEMENTS_SIZE = 60;
        CGFloat PADDING_BOTTOM = 40;
        
        CGFloat DESCRIPTION_SIZE = [self textViewHeightForAttributedText:[self checkText:muralTwitter.message] andWidth:280 andFont:[UIFont systemFontOfSize:14]];
        
        
        return REST_ELEMENTS_SIZE+DESCRIPTION_SIZE+PADDING_BOTTOM;
    }
    
    //Youtube
    if ([[dict objectForKey:@"type"] isEqualToString:@"youtube"]) {
        
        //Serializando Objeto
        MuralYoutube * muralYoutube = [MuralYoutube getFromDictionary:dict];
       
        CGFloat IMG_SIZE = 180;
        CGFloat REST_ELEMENTS_SIZE = 74;
        CGFloat PADDING_BOTTOM = 40;
        
        CGFloat DESCRIPTION_SIZE = [self textViewHeightForAttributedText:[self checkText:muralYoutube.content] andWidth:280 andFont:[UIFont systemFontOfSize:14]];
        CGFloat TITLE_SIZE = [self textViewHeightForAttributedText:[self checkText:muralYoutube.title] andWidth:280 andFont:[UIFont systemFontOfSize:15]];

         return REST_ELEMENTS_SIZE+IMG_SIZE+DESCRIPTION_SIZE+TITLE_SIZE+PADDING_BOTTOM;
    }
    
    //Instagram
    if ([[dict objectForKey:@"type"] isEqualToString:@"instagram"]) {
        
        //Serializando Objeto
        MuralInstagram * muralInstagram = [MuralInstagram getFromDictionary:dict];
        
        CGFloat IMG_SIZE = 320;
        CGFloat REST_ELEMENTS_SIZE = 74;
        CGFloat PADDING_BOTTOM = 40;
        CGFloat DESCRIPTION_SIZE = [self textViewHeightForAttributedText:[self checkText:muralInstagram.description] andWidth:280 andFont:[UIFont systemFontOfSize:14]];
        
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
        CGFloat DESCRIPTION_SIZE = [self textViewHeightForAttributedText:[self checkText:muralBlog.description] andWidth:280 andFont:[UIFont systemFontOfSize:14]];
        CGFloat TITLE_SIZE = [self textViewHeightForAttributedText:[self checkText:muralBlog.title] andWidth:280 andFont:[UIFont systemFontOfSize:15]];

        
        //Verificando se existe imagem no Blog
        if ([muralBlog.image isEqual:[NSNull null]] || [muralBlog.image isEqual:@""]) {
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
        CGFloat PADDING_BOTTOM = 70;
        CGFloat DESCRIPTION_SIZE = [self textViewHeightForAttributedText:[self checkText:muralFacebook.message] andWidth:280 andFont:[UIFont systemFontOfSize:14]];
    
        
        //Verificando se existe imagem no Blog
        if ([muralFacebook.picture isEqual:[NSNull null]] || [muralFacebook.picture isEqualToString:@""]){
            IMG_SIZE = 0;
        }
        return REST_ELEMENTS_SIZE+IMG_SIZE+DESCRIPTION_SIZE+PADDING_BOTTOM;
    }
    
    return 0;
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
   
    //Criando apenas um scrol para as duas tabelas no ipad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    
        CGPoint offset = scrollView.contentOffset;
        
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        
        BOOL isMuralTable2Biggest = (self.muralTableView2.contentSize.height >= self.muralTableView.contentSize.height)? YES : NO;
        
        //Escondendo player
        if (scrollView == self.muralTableView2 || scrollView == self.muralTableView) {
            if(y >= h-3) {
                
                if (isMuralTable2Biggest) {
                    CGPoint  maxoffSet = CGPointMake(0, self.muralTableView2.frame.size.height+20);
                    [self.muralTableView setContentOffset:maxoffSet animated:YES];
                }else{
                    CGPoint  maxoffSet = CGPointMake(0, self.muralTableView.frame.size.height+20);
                    [self.muralTableView2 setContentOffset:maxoffSet animated:YES];
                }
                
            }
        }
    }
    
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
        }
    
    
    
    //Criando apenas um scrol para as duas tabelas no ipad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        if (aScrollView == self.muralTableView) {
            
            //Retirando o scrol da tabela do delegate
            CGRect scrollBounds = self.muralTableView2.bounds;
            scrollBounds.origin = offset;
            self.muralTableView2.bounds = scrollBounds;
            [self.muralTableView2 setContentOffset:offset animated:NO];

        }else if (aScrollView == self.muralTableView2){
            
            //Retirando o scrol da tabela do delegate
            CGRect scrollBounds = self.muralTableView.bounds;
            scrollBounds.origin = offset;
            self.muralTableView.bounds = scrollBounds;
            [self.muralTableView setContentOffset:offset animated:NO];
        }
    }
    
        
}

-(void)shareMuralItem:(id)sender{
    
    if (self.sharedText) {
        
        NSArray* dataToShare = @[self.sharedText];
        UIActivityViewController* activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                          applicationActivities:nil];
        
        [self presentViewController:activityViewController animated:YES completion:^{}];
    }
    
    
}


-(NSString * )checkText:(NSString *)text{
    
    if ([text isEqual:[NSNull null]] || [text isEqual:@""]) {
        return @"";
    }
    
    return text;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableDictionary * item = [self.muralItensArray objectAtIndex:indexPath.row];
    NSString * link = [[NSString alloc]init];
    
    //Twitter
    if ([[item objectForKey:@"type"] isEqualToString:@"twitter"]) {
        MuralTwitter * muralTwitter = [MuralTwitter getFromDictionary:item];
        NSMutableArray * urlsDict = [muralTwitter.urlsArray objectForKey:@"urls"];
        NSMutableDictionary * urls_ = [[NSMutableDictionary alloc]init];
        
        if (urlsDict && urlsDict.count != 0) {
           urls_  = [urlsDict objectAtIndex:0];
        }
        
        if (urls_) {
            link = [urls_ objectForKey:@"url"];
        }
        
    }//Youtube
    else if ([[item objectForKey:@"type"] isEqualToString:@"youtube"]) {
        MuralYoutube * muralYoutube = [MuralYoutube getFromDictionary:item];
        link  = muralYoutube.link;
    }//Blog
    else if ([[item objectForKey:@"type"] isEqualToString:@"blog"]) {
        MuralBlog * muralBlog = [MuralBlog getFromDictionary:item];
        link = muralBlog.url;
    }//Facebook
    else if ([[item objectForKey:@"type"] isEqualToString:@"facebook"]) {
        //MuralFacebook * muralFacebook = [MuralFacebook getFromDictionary:item];
    }//Instagram
    else if ([[item objectForKey:@"type"] isEqualToString:@"instagram"]) {
        //MuralInstagram * muralInstagram = [MuralInstagram getFromDictionary:item];
    }

    if (link) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
    }
    
    UITableViewCell *cell = [self.muralTableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
}


-(void)ExecuteOnSafari:(id)sender{
    ArgButton * argButton = (ArgButton *)sender;
    if (argButton.ArgString1.length != 0 && argButton.ArgString1 != nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:argButton.ArgString1]];
    }
}


-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    return YES;
}


-(void)rotateBtnOpenMenu{
    
    //Criando animaçao
    [UIView animateWithDuration:0.5 animations:^{
        [self.btnOpenMenu setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        self.btnOpenMenu.center =  CGPointMake(CGRectGetMidX(self.btnOpenMenu.bounds),CGRectGetMidY(self.btnOpenMenu.bounds));
        
    }];
    
    self.needResetAnimation = YES;
}


-(void)unRotateBtnOpenMenu{
    
    if (self.needResetAnimation) {
        //Criando animaçao
        [UIView animateWithDuration:0.5 animations:^{
            [self.btnOpenMenu setTransform:CGAffineTransformIdentity];
            self.btnOpenMenu.center =  CGPointMake(CGRectGetMidX(self.btnOpenMenu.bounds),CGRectGetMidY(self.btnOpenMenu.bounds));
        }];
    }

}

@end
