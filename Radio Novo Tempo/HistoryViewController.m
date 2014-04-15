//
//  FilosofiaViewController.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 2/11/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "HistoryViewController.h"



@interface HistoryViewController ()

//Loading
@property(nonatomic,retain)IBOutlet UIImageView * imgLoading;
@property(nonatomic,retain)UIView * loadingView;
@property(nonatomic,retain)NSURLConnection * urlConnection;
@property(nonatomic)NSMutableData * urlData;

//Elementos
@property(nonatomic,strong)NSDictionary * filosofiaDictionary;

@end



@implementation HistoryViewController

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
    
    [self MainExecution];
}

-(void)MainExecution{
    
    if ([self CheckInternetConnection]) {
        [self CallFilosofiaJsonData];
    }else{
        [self InternetConnectionErrorMessage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{

}


- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


-(void)CallFilosofiaJsonData{
    
    //Iniciando View de loading
    [self StartLoading];
    
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Create Request Values
    NSString * action = @"history";
    NSNumber * idRadio = appDel.radioCurrent.radioId;
    
    //Chamando JSON
    NSString * adress = [NSString stringWithFormat:@"http://novotempo.com/api/radio/?action=%@&idRadio=%@",action,idRadio];
    
    //NSLog(@"%@",adress);
    
    NSString * post = [[NSString alloc]init];
    NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:adress]];
    [request setHTTPMethod:@"POST"]; // 1
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"]; // 2
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    
    self.urlConnection = [[NSURLConnection alloc]init];
    self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.urlData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.urlData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *jsonParsingError = nil;
    
    self.filosofiaDictionary = [NSJSONSerialization JSONObjectWithData:self.urlData options:NSJSONReadingMutableContainers error:&jsonParsingError];

    
    if (jsonParsingError || !self.filosofiaDictionary){
        NSLog (@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
    }else{
        [self.loadingView removeFromSuperview];
    }
    
    [self loadJsonContentInWebView];
}

-(void)loadJsonContentInWebView{
    
    NSString * title = [NSString stringWithFormat:@"%@",[self checkText:[self.filosofiaDictionary objectForKey:@"title"]]];
    NSString * description = [NSString stringWithFormat:@"%@",[self checkText:[self.filosofiaDictionary objectForKey:@"description"]]];
    
    if ([title isEqual:@""]) {
        title = @"Title empty...";
    }
    if ([description isEqual:@""]) {
        description = @"Description empty...";
    }
    
    title = [NSString stringWithFormat:@"<h2>%@</h2>",title];
    description = [description stringByReplacingOccurrencesOfString:@"\n"
                                                 withString:@"</br>"];
    
    [self.webView loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</br>%@</body></html>",title,description] baseURL:nil];
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


-(NSString * )checkText:(NSString *)text{
    
    if ([text isEqual:[NSNull null]] || [text isEqual:@""]) {
        return @"";
    }
    
    return text;
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

-(BOOL)CheckInternetConnection{
    
    //Check Internet Connection.
    AppDelegate * apDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return apDel.CheckInternetConnection;
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
