//
//  OutrosAppsViewController.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 2/20/15.
//  Copyright (c) 2015 Novo Tempo. All rights reserved.
//

#import "OutrosAppsViewController.h"
#import "AppDelegate.h"

@interface OutrosAppsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnOpenMenu;
@property (weak, nonatomic) IBOutlet UIWebView * webViewOtherApps;
@property(nonatomic,retain)UIView * loadingView;
@end

@implementation OutrosAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Observando Framework de menu para quando abrir chamar este metodo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rotateBtnOpenMenu)
                                                 name:@"GestureOpenMenu"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unRotateBtnOpenMenu)
                                                 name:@"GestureCloseMenu"
                                               object:nil];

    [self StartLoading];
    
    [self MainExecution];
}

-(void)MainExecution{
    
    if ([self CheckInternetConnection]) {
        [self loadContent];
    }else{
        [self InternetConnectionErrorMessage];
    }
}


-(void)loadContent{
    NSURL *websiteUrl = [NSURL URLWithString:@"http://www.novotempo.com/mobile"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webViewOtherApps loadRequest:urlRequest];
}


-(void)rotateBtnOpenMenu{
    
    //Criando animaçao
    [UIView animateWithDuration:0.5 animations:^{
        [self.btnOpenMenu setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        self.btnOpenMenu.center =  CGPointMake(CGRectGetMidX(self.btnOpenMenu.frame),CGRectGetMidY(self.btnOpenMenu.frame));
        
    }];
}


-(void)unRotateBtnOpenMenu{

    //Criando animaçao
    [UIView animateWithDuration:0.5 animations:^{
        [self.btnOpenMenu setTransform:CGAffineTransformIdentity];
        self.btnOpenMenu.center =  CGPointMake(CGRectGetMidX(self.btnOpenMenu.frame),CGRectGetMidY(self.btnOpenMenu.frame));
    }];
    
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

- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.loadingView removeFromSuperview];
}



-(void)InternetConnectionErrorMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops" message:@"Não é possível conectar. Talvez você não tenha conexão com a internet, certifique-se disso." delegate:self cancelButtonTitle:@"Tentar Novamente" otherButtonTitles: nil];
    [alert show];
}

-(BOOL)CheckInternetConnection{
    
    //Check Internet Connection.
    AppDelegate * apDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return apDel.CheckInternetConnection;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self MainExecution];
    }
}

@end
