//
//  EquipeViewController.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 2/16/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "EquipeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Person.h"
#import "UIViewPerson.h"
#import "EquipeDadosCell.h"


BOOL abortGDCProcess = NO;
#define CheckerGDCProcess if ( abortGDCProcess ) { goto endProcess; }

int widthOfPage = 100;
int heightOfPage = 100;
int screenSize = 0;
CGFloat PADDING_LEFT = 50;

@interface EquipeViewController ()

//Loading
@property(nonatomic,retain)IBOutlet UIImageView * imgLoading;
@property(nonatomic,retain)UIView * loadingView;
@property(nonatomic,retain)NSURLConnection * urlConnection;
@property(nonatomic)NSMutableData * urlData;

//Scroll
@property(nonatomic)UIButton * btnMain;
@property(nonatomic)UIScrollView * scroll;
@property(nonatomic)NSNumber * lastCodeUpdated;
@property(nonatomic)BOOL isScrollNeedMove;

//Elementos
@property(nonatomic,strong)NSMutableArray * equipeArray;
@property(nonatomic,strong)Person * selectedPerson;
@property(nonatomic,retain)NSArray * selectedPersonDataArray;
@property(nonatomic,retain)UITextView * calculationView;

//Elementos visuais
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightText;
@property (weak, nonatomic) IBOutlet UITableView *tableSelectedPersonData;

//Thread
@property(nonatomic)BOOL canUpdateSelectedPersonElements;


@end

@implementation EquipeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self MainExecution];
    
}

-(void)MainExecution{
    
   
    if ([self CheckInternetConnection]) {
        
        self.isScrollNeedMove = YES;
        self.canUpdateSelectedPersonElements = YES;
        
        //instanciando txtview de altura
        self.calculationView = [[UITextView alloc]init];
        self.lastCodeUpdated = [[NSNumber alloc]init];
        
        //Pegando tamanho da tela
        screenSize = (self.view.frame.size.width/2);
        
        [self CallEquipJsonData];
        
    }else{
        [self InternetConnectionErrorMessage];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



-(void)CallEquipJsonData{
    
    //Iniciando View de loading
    [self StartLoading];
    
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Create Request Values
    NSString * action = @"team";
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
    
    NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:self.urlData options:NSJSONReadingMutableContainers error:&jsonParsingError];
    
    
    self.equipeArray = [resultados objectForKey:@"team"];
    
    if (jsonParsingError || !self.equipeArray){
        NSLog (@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
    }else{
        [self.loadingView removeFromSuperview];
        [self createScrollElements];
    }
}

-(void)createScrollElements{
    

    CGRect frame = CGRectMake(0, 73, self.view.frame.size.width, 150);
    self.scroll = [[UIScrollView alloc]initWithFrame:frame];
    self.scroll.delegate = self;
    self.scroll.tag = 22;
    //self.scroll.backgroundColor = [UIColor redColor];
    self.scroll.pagingEnabled = NO;
    self.scroll.showsHorizontalScrollIndicator = NO;
    
    UIViewPerson * lastView = nil;
    
    for (NSDictionary * dictPerson in self.equipeArray) {
        
        Person * currentPerson = [Person getFromDictionary:dictPerson];
        
        UIViewPerson * viewItem;
        if (lastView != nil) {
            //Criando view sem o FIRST_PADDING_LEFT
            viewItem = [[UIViewPerson alloc]initWithFrame:CGRectMake(lastView.frame.origin.x+lastView.frame.size.width+PADDING_LEFT,25, widthOfPage, 100)];
        }else{
            //Criando view
            viewItem = [[UIViewPerson alloc]initWithFrame:CGRectMake(lastView.frame.origin.x+lastView.frame.size.width+PADDING_LEFT+screenSize,25, widthOfPage, 100)];
        }
        
        //Colocando codigo unico em cada view
        viewItem.code = currentPerson._id;
        
        //Criando imagem do item
        UIImageView * imgThumb = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            NSString * strUrlImg = currentPerson.image;
            NSURL * imgurl = [NSURL URLWithString:strUrlImg];
            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl]];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                imgThumb.image = image;
                imgThumb.center = CGPointMake(CGRectGetMidX(viewItem.bounds), CGRectGetMidY(viewItem.bounds)-imgThumb.frame.size.height/2+20);
                CALayer *imageLayer = imgThumb.layer;
                [imageLayer setCornerRadius:33];
                [imageLayer setMasksToBounds:YES];
            });
        });
        

        //Criando label
        UILabel * lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewItem.frame.size.width + (viewItem.frame.size.width/2), 20)];
        lblName.font = [UIFont fontWithName:@"ProximaNova-Light" size:18];
        lblName.center = CGPointMake(CGRectGetMidX(viewItem.bounds), imgThumb.frame.origin.y + imgThumb.frame.size.height + lblName.frame.size.height);
        lblName.font = [lblName.font fontWithSize:15];
        lblName.textAlignment = NSTextAlignmentCenter;
        
        //Pegando first Name
        NSRange rangeFirstName = [currentPerson.name rangeOfString:@" "];
        NSString * firstName = [currentPerson.name substringToIndex:rangeFirstName.location];
        
        //Pegando last Name
        NSRange rangeLastName = [currentPerson.name rangeOfString:@" " options: NSBackwardsSearch];
        NSString * lastName = [currentPerson.name substringFromIndex:(rangeLastName.location+1)];
        
        //Printando nome na tela
        lblName.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    
        lblName.textColor = [UIColor whiteColor];
        //[lblName sizeToFit];
        
        //inserindo label
        [viewItem addSubview:lblName];
        
        //Inserindo imagem
        [viewItem addSubview:imgThumb];
        
        //Inserindo no scroll
        [self.scroll addSubview:viewItem];
        
        //Pegando ultimo elemento
        lastView = viewItem;
    }
    
    self.scroll.contentSize = CGSizeMake((self.equipeArray.count*widthOfPage)+((self.equipeArray.count+1)*(PADDING_LEFT+15))+(screenSize * 2)-widthOfPage, 1);
    [self.view addSubview:self.scroll];
    
    //atualizando posiçao do scroll.
    [self updateScrollPosition];
}

-(void)updateScrollPosition{
    //Mandando scroll pro quadrado default
    if (self.isScrollNeedMove) {
        [self.scroll setContentOffset:CGPointMake([self scrollStartPositionOnCenterItem], 0) animated:NO];
        self.isScrollNeedMove = NO;
    }

}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    //Parando scroll da tabela e mandando pro top.
    if (aScrollView.tag == 22) {
        [self.tableSelectedPersonData setContentOffset:CGPointZero animated:NO];
    }
    
    int scrollPosition = aScrollView.contentOffset.x;
    NSArray * views =  aScrollView.subviews;
    BOOL isFetchedOnePerson = NO;

    //Varrendo items do array
    for (UIView * viewItem in views) {
        
        //Conferindo tipo dos items que estao vindo do scroll.
        if ([viewItem isKindOfClass:[UIViewPerson class]] && self.canUpdateSelectedPersonElements){
            UIViewPerson * viewItemPerson = (UIViewPerson *)viewItem;
            
            //encontrou o item selecionado
            if (((scrollPosition + screenSize) <= viewItemPerson.center.x + (widthOfPage/2)) && ((scrollPosition+ screenSize) >= viewItemPerson.center.x - (widthOfPage/2))) {
                
                isFetchedOnePerson = YES;
                
                //Verificando se o item selecionado existe
                if (viewItemPerson) {
                    self.selectedPerson = nil;
                    abortGDCProcess = YES;
                    
                    //Verificando se o item tem um codigo
                    if (viewItemPerson.code) {
                    
                        if (viewItemPerson.code != self.lastCodeUpdated) {
                            
                            //Criando imagem do item
                            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                                //Background Thread
                                
                                //Travando thread
                                self.canUpdateSelectedPersonElements = NO;
                                
                                //Buscando item com o codigo
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id == %d",[viewItemPerson.code intValue]];
                                NSArray *filtered = [self.equipeArray filteredArrayUsingPredicate:predicate];
                                
                                //Pegando item selecionado
                                self.selectedPerson = [Person getFromDictionary:filtered[0]];
                                
                                
                                dispatch_async(dispatch_get_main_queue(), ^(void){
                                    //Run UI Updates
                                   
                                    //Aumentando item encontrado
                                    [UIView animateWithDuration:0.2 animations:^{
                                        viewItemPerson.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                                    }];
                                    
                                    //Chamando metodo que atualiza dados da tela de acordo com o item selecionado.
                                    abortGDCProcess = NO;
                                    [self updateDataWidthSelectedPerson];
                                    
                                    //Travando thread
                                    self.canUpdateSelectedPersonElements = YES;

                                });
                            });
                            
                        }
                        //Guardando codigo do ultimo item selecionado para nao repetir o processo a cada pixel percorrido pelo scroll
                        self.lastCodeUpdated = viewItemPerson.code;
                    }
                }
            }
            else{
                //Diminuindo itens que nao estao no centro
                [UIView animateWithDuration:0.2 animations:^{
                    viewItem.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                }];
            }
        }
    }
    
    //Verificando de algum item foi encontrado no centro para zerar o ultimo item.
    if (!isFetchedOnePerson) {
        self.lastCodeUpdated = nil;
    }

}





-(void)updateDataWidthSelectedPerson{

  
    
        //Atualizando texto de recado
        if (![_selectedPerson.description isEqual:@""]) {
            self.tableSelectedPersonData.tableHeaderView = nil;
            UITextView * txtView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  [self textViewHeightForAttributedText:_selectedPerson.description andWidth:320 andFont:[UIFont systemFontOfSize:15]] + 20)];
            [txtView setFont:[UIFont systemFontOfSize:15]];
            txtView.textAlignment = NSTextAlignmentCenter;
            txtView.textColor = [UIColor grayColor];
            txtView.text = _selectedPerson.description;
            self.tableSelectedPersonData.tableHeaderView = txtView;
        }
        
        
        //Criando imagem do item
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
        CheckerGDCProcess
        {
            
            //Atualizando dados
            NSDictionary * cidadenatal =@{@"value": _selectedPerson.cidadenatal,@"name": @"cidade natal"};
            CheckerGDCProcess
            NSDictionary * conhecidocomo =@{@"value": _selectedPerson.conhecidocomo,@"name": @"conhecido como"};
            CheckerGDCProcess
            //NSDictionary * description =@{@"value": self.selectedPerson.description,@"name": @"description"};
            CheckerGDCProcess
            NSDictionary * estadocivil =@{@"value": _selectedPerson.estadocivil,@"name": @"estado civil"};
            CheckerGDCProcess
            NSDictionary * familia =@{@"value": _selectedPerson.familia,@"name": @"familia"};
            CheckerGDCProcess
            //NSDictionary * _id =@{@"value": self.selectedPerson._id,@"name": @"_id"};
            CheckerGDCProcess
            NSDictionary * idade =@{@"value": _selectedPerson.idade,@"name": @"idade"};
            CheckerGDCProcess
            //NSDictionary * image =@{@"value": self.selectedPerson.image,@"name": @"image"};
            CheckerGDCProcess
            NSDictionary * name =@{@"value": _selectedPerson.name,@"name": @"name"};
            CheckerGDCProcess
            NSDictionary * naogostade =@{@"value": _selectedPerson.naogostade,@"name": @"nao gosta de"};
            CheckerGDCProcess
            NSDictionary * naosaidecasasem =@{@"value": _selectedPerson.naosaidecasasem,@"name": @"nao sai de casa sem"};
            CheckerGDCProcess
            NSDictionary * ondejatrabalhou =@{@"value": _selectedPerson.ondejatrabalhou,@"name": @"onde ja trabalhou"};
            CheckerGDCProcess
            NSDictionary * radionovotempo =@{@"value": _selectedPerson.radionovotempo,@"name": @"radio novotempo"};
            CheckerGDCProcess
            NSDictionary * senaotrabalhassenanovotemposeria =@{@"value": _selectedPerson.senaotrabalhassenanovotemposeria,@"name": @"se nao trabalhasse na novotempo seria"};
            CheckerGDCProcess
            NSDictionary * suafuncaonaradiont =@{@"value": _selectedPerson.suafuncaonaradiont,@"name": @"sua funcao na radio nt"};
            CheckerGDCProcess
            NSDictionary * umadatainesquecivel =@{@"value": _selectedPerson.umadatainesquecivel,@"name": @"uma data inesquecivel"};
            CheckerGDCProcess
            NSDictionary * umamusica =@{@"value": _selectedPerson.umamusica,@"name": @"uma musica"};
            CheckerGDCProcess
            NSDictionary * umaviagem =@{@"value": _selectedPerson.umaviagem,@"name": @"uma viagem"};
            CheckerGDCProcess
            NSDictionary * umpresente =@{@"value": _selectedPerson.umpresente,@"name": @"um presente"};
            CheckerGDCProcess
            NSDictionary * umrecadoparaosouvintes =@{@"value": _selectedPerson.umrecadoparaosouvintes,@"name": @"um recado para os ouvintes"};
            CheckerGDCProcess
            NSDictionary * umsonho =@{@"value": _selectedPerson.umsonho,@"name": @"um sonho"};


            CheckerGDCProcess
            //Inserindo lista no array
            self.selectedPersonDataArray = @[
                                             cidadenatal,
                                             conhecidocomo,
                                             //description,
                                             estadocivil,
                                             familia,
                                             //_id,
                                             idade,
                                             //image,
                                             name,
                                             naogostade,
                                             naosaidecasasem,
                                             ondejatrabalhou,
                                             radionovotempo,
                                             senaotrabalhassenanovotemposeria,
                                             suafuncaonaradiont,
                                             umadatainesquecivel,
                                             umamusica,
                                             umaviagem,
                                             umpresente,
                                             umrecadoparaosouvintes,
                                             umsonho];



                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //Run UI Updates
                    [self.tableSelectedPersonData reloadData];

                });
            
        }
        endProcess:
            //NSLog(@"Pulou processo!!");
            return;
            
        });
}

-(float)scrollStartPositionOnCenterItem{
    //pegando itens do scroll
    NSArray * scrollItems =  self.scroll.subviews;
    if ([scrollItems count] == 0) {
        return 0;
    }
    //pegando posiçao do meio
    int startScrollPositionItem = (int)(scrollItems.count/2);
    
    //pegando item da posicao
    UIView * item = scrollItems[startScrollPositionItem];
    
    //retornando o centro do item do meio
    float result = (self.scroll.bounds.size.width - item.frame.size.width / 2.0f - 21);
    
    //CGRectGetMidX(item.bounds); //item.center.x-8;
    return result;
}

- (CGFloat)textViewHeightForAttributedText: (NSString*)textString andWidth: (CGFloat)width andFont:(UIFont *)font{
    
    NSData* data = [textString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithData:data
                                                                options:nil
                                                     documentAttributes:NULL
                                                                  error:NULL];
    
    [self.calculationView setAttributedText:text];
    
    CGSize size = [self.calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    
    CGSize sizeWithFont = [self text:textString sizeWithFont:font constrainedToSize:self.calculationView.frame.size];
    
    return size.height + sizeWithFont.height+3.5;
}

- (CGSize)text:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [text sizeWithFont:font constrainedToSize:size];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selectedPersonDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * item = [self.selectedPersonDataArray objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier = @"EquipeDadosCell";
    EquipeDadosCell * cell = (EquipeDadosCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.lblName.text = [[item objectForKey:@"name"] uppercaseString];
    cell.txtValue.text = [item objectForKey:@"value"];
    
    //Calculando altura do titulo
    cell.heightConstraint.constant = [self textViewHeightForAttributedText:[item objectForKey:@"value"] andWidth:280 andFont:[UIFont systemFontOfSize:15]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary * item = [self.selectedPersonDataArray objectAtIndex:indexPath.row];
    
    float value = [self textViewHeightForAttributedText:[item objectForKey:@"value"] andWidth:280 andFont:[UIFont systemFontOfSize:15]];
    float title = 23;
    
    return value + title;
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


@end
