//
//  PedirMusicaViewController.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 6/19/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "PedirMusicaViewController.h"
#import "PedirMusicaTableViewCell.h"
#import "AppDelegate.h"


@interface PedirMusicaViewController ()
@property (weak, nonatomic) IBOutlet UIButton *enviarBtn;
@property (weak, nonatomic) IBOutlet UITextField *musicTextField;
@property (weak, nonatomic) IBOutlet UITextField *artistTextField;
@property (weak, nonatomic) IBOutlet UIView *viewPedirMusica;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewPedirMusicaConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableRankingList;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenMenu;


@property (weak, nonatomic) IBOutlet UIImageView *imgArrowOnBestMusicOfWeek;


@property(nonatomic,strong)NSMutableArray * rankingList;

//Loading
@property(nonatomic,retain)IBOutlet UIImageView * imgLoading;
@property(nonatomic,retain)UIView * loadingView;
@property(nonatomic,retain)NSURLConnection * urlConnection;
@property(nonatomic)NSMutableData * urlData;

@end

@implementation PedirMusicaViewController

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
    
    
    _enviarBtn.hidden = YES;
    _enviarBtn.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];
    _enviarBtn.titleLabel.textColor = [UIColor colorWithRed:71.0f/255.0f green:152.0f/255.0f blue:203.0f/255.0f alpha:1];
    
    //[_musicTextField becomeFirstResponder];
    [self CallProgramJsonData];
    
    //Observando Framework de menu para quando abrir chamar este metodo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rotateBtnOpenMenu)
                                                 name:@"GestureOpenMenu"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unRotateBtnOpenMenu)
                                                 name:@"GestureCloseMenu"
                                               object:nil];
    
}


-(IBAction)sendRequest:(id)sender{

    [self sendEmail:_musicTextField.text artist:_artistTextField.text];
  
}


-(void)showEmptyFieldsErrorAlert{
    UIAlertView * alertV = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"DADOS_INCOMPLETOS_TITLE", @"Dados incompletos") message:NSLocalizedString(@"DADOS_INCOMPLETOS_MSG", @"Antes de enviar o pedido você precisa preencher os campos com o artista e música desejada") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertV show];
}



-(void)sendEmail:(NSString *)music artist:(NSString *)artist{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if (![self isFieldsFilled] && ([music isEqual:@""] || [artist isEqual:@""])) {
        [self showEmptyFieldsErrorAlert];
        return;
    }
  
    
    if ([MFMailComposeViewController canSendMail])
    {
        NSString * content = [[NSString alloc]init];
        content = [NSString stringWithFormat:@"%@<br><br> <b style='color:#126091;'>%@</b><br>%@<br><br><b style='color:#126091;'>%@</b><br>%@<br><br><i style='color:gray;'>App Rádio Novo Tempo <i>",NSLocalizedString(@"EMAIL_PEDIR_MUSICA_MSG",@"Olá pessoal da Novo Tempo, gostaria de fazer um pedido."),NSLocalizedString(@"MUSICA",@"Música:"),NSLocalizedString(@"ARTISTA",@"Artista:"),music,artist];
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:NSLocalizedString(@"EMAIL_PEDIR_MUSICA_ASSUNTO", @"#RADIO NT - Pedido de música")];
        [mail setMessageBody:content isHTML:YES];
        [mail setToRecipients:@[appDel.radioCurrent.emailContact]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"EMAIL_SEM_ACESSO_TITLE", @"Você não possui  uma conta de e-mail configurada.") message:NSLocalizedString(@"EMAIL_SEM_ACESSO_MSG", @"Adicione uma conta ( Ajustes de seu aparelho > Mail,Contatos,Calendários > Adicionar Conta ) e tente novamente.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alerta show];
    }

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            _musicTextField.text = @"";
            _artistTextField.text = @"";
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toggleRanking:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        if (_viewPedirMusicaConstraint.constant == 0) {
            _viewPedirMusicaConstraint.constant = 185;
            
            _imgArrowOnBestMusicOfWeek.transform = CGAffineTransformMakeRotation(M_PI);
            _enviarBtn.hidden = NO;
            
        }else{
            _viewPedirMusicaConstraint.constant = 0;
            _imgArrowOnBestMusicOfWeek.transform = CGAffineTransformMakeRotation(0);
            _enviarBtn.hidden = YES;
        }
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
    
        if (finished) {
            if (_viewPedirMusicaConstraint.constant == 0) {
                [_musicTextField resignFirstResponder];
                [_artistTextField resignFirstResponder];
            }else{
                [_musicTextField becomeFirstResponder];
            }
        }
        
    }];
}
- (IBAction)hideKeyboard:(id)sender {
    [_musicTextField resignFirstResponder];
    [_artistTextField resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rankingList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PedirMusicaTableViewCell* cell = (PedirMusicaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellRanking"];
    
    NSMutableDictionary * item = [_rankingList objectAtIndex:indexPath.row];
    
    NSNumber * number = [NSNumber numberWithLong:[_rankingList indexOfObject:item]+1];

    cell.numberlbl.text = [NSString stringWithFormat:@"%ld°",(long)[number integerValue]];
    cell.textlbl.text = [item objectForKey:@"music"];
    cell.detaillbl.text = [item objectForKey:@"artist"];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary * item = [_rankingList objectAtIndex:indexPath.row];

    [self sendEmail:[item objectForKey:@"music"] artist:[item objectForKey:@"artist"]];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(void)CallProgramJsonData{
    
    //Iniciando View de loading
    [self StartLoading];
    
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Create Request Values
    NSString * action = @"hit";
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
    
    NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:self.urlData options:NSJSONReadingMutableContainers error:&jsonParsingError];
    
    
    _rankingList = [resultados objectForKey:@"listplay"];
    
    if (jsonParsingError || !_rankingList){
        NSLog (@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
    }else{
        [self.loadingView removeFromSuperview];
        [_tableRankingList reloadData];
    }
    
}

-(void)StartLoading{
    
    //Iniciando LoadingView
    self.loadingView = [[UIView alloc]init];
    
    //Criando componentes
    UIImageView  * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading.png"]];
    UILabel * txt = [[UILabel alloc]init];
    txt.text = NSLocalizedString(@"CARREGANDO",@"Carregando...");
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

-(void)rotateBtnOpenMenu{
    
    //Criando animaçao
    [UIView animateWithDuration:0.5 animations:^{
        [self.btnOpenMenu setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        self.btnOpenMenu.center =  CGPointMake(CGRectGetMidX(self.btnOpenMenu.frame),CGRectGetMidY(self.btnOpenMenu.frame));
        [_musicTextField resignFirstResponder];
        [_artistTextField resignFirstResponder];
        
    }];
    
    self.needResetAnimation = YES;
}


-(void)unRotateBtnOpenMenu{
    
    if (self.needResetAnimation) {
        //Criando animaçao
        [UIView animateWithDuration:0.5 animations:^{
            [self.btnOpenMenu setTransform:CGAffineTransformIdentity];
            self.btnOpenMenu.center =  CGPointMake(CGRectGetMidX(self.btnOpenMenu.frame),CGRectGetMidY(self.btnOpenMenu.frame));
            [_musicTextField resignFirstResponder];
            [_artistTextField resignFirstResponder];
        }];
    }
    
}

- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [_musicTextField resignFirstResponder];
    [_artistTextField resignFirstResponder];
    
}



- (IBAction)tappedOnMoreMusics:(id)sender {
    [self toggleRanking:self];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([_musicTextField.text isEqualToString:@""] && _artistTextField == textField) {
        [_musicTextField becomeFirstResponder];
        return NO;
    }
    else if ([_artistTextField.text isEqualToString:@""] && _musicTextField == textField) {
        [_artistTextField becomeFirstResponder];
        return NO;
    }
    
    [self sendEmail:_musicTextField.text artist:_artistTextField.text];
    return YES;
}

-(BOOL)isFieldsFilled{
    if ([_musicTextField.text isEqual:@""]) {
        return NO;
    }
    
    if ([_artistTextField.text isEqual:@""]) {
        return NO;
    }
    
    return YES;
}

@end
