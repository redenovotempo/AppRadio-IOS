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

int widthOfPage = 100;
int heightOfPage = 100;
int screenSize = 0;
CGFloat PADDING_LEFT = 50;
BOOL isScrollNeedMove = YES;

@interface EquipeViewController ()


//Loading
@property(nonatomic,retain)IBOutlet UIImageView * imgLoading;
@property(nonatomic,retain)UIView * loadingView;
@property(nonatomic,retain)NSURLConnection * urlConnection;
@property(nonatomic)NSMutableData * urlData;

//Scroll
@property(nonatomic)UIButton * btnMain;
@property(nonatomic)UIScrollView * scroll;

//Elementos
@property(nonatomic,strong)NSMutableArray * equipeArray;
@property(nonatomic,strong)Person * selectedPerson;

//Elementos visuais
@property (weak, nonatomic) IBOutlet UITextView *textViewPersonRecord;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (weak, nonatomic) IBOutlet UILabel *lblMaritalStatus;


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

-(void)viewWillAppear:(BOOL)animated{

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Pegando tamanho da tela
    screenSize = (self.view.frame.size.width/2);
    
    [self CallEquipJsonData];
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
        NSLog(@"%@",resultados);
    }
}

-(void)createScrollElements{
    

    CGRect frame = CGRectMake(0, 73, self.view.frame.size.width, 150);
    self.scroll = [[UIScrollView alloc]initWithFrame:frame];
    self.scroll.delegate = self;
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
    
    //Mandando scroll pro quadrado default
    if (isScrollNeedMove) {
        [self.scroll setContentOffset:CGPointMake([self scrollStartPositionOnCenterItem], 0) animated:NO];
        isScrollNeedMove = NO;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    int scrollPosition = aScrollView.contentOffset.x;
    NSArray * views =  aScrollView.subviews;
    
    //Varrendo items do array
    for (UIView * viewItem in views) {
        
        //Conferindo tipo dos items que estao vindo do scroll.
        if ([viewItem isKindOfClass:[UIViewPerson class]]){
            UIViewPerson * viewItemPerson = (UIViewPerson *)viewItem;
            
            //encontrou o item selecionado
            if (((scrollPosition + screenSize) <= viewItemPerson.center.x + (widthOfPage/2)) && ((scrollPosition+ screenSize) >= viewItemPerson.center.x - (widthOfPage/2))) {
                
                //Verificando se o item selecionado existe
                if (viewItemPerson) {
                    //Verificando se o item tem um codigo
                    if (viewItemPerson.code) {
                        
                        //Aumentando item encontrado
                        [UIView animateWithDuration:0.2 animations:^{
                            viewItemPerson.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                        }];
      
                        //Buscando item com o codigo
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id == %d",[viewItemPerson.code intValue]];
                        NSArray *filtered = [self.equipeArray filteredArrayUsingPredicate:predicate];
                        
                        //Pegando item selecionado
                        self.selectedPerson = [Person getFromDictionary:filtered[0]];
                        
                        //Chamando metodo que atualiza dados da tela de acordo com o item selecionado.
                        [self updateDataWidthSelectedPerson];

                    }
                }
            }
            else{
                [UIView animateWithDuration:0.2 animations:^{
                    viewItem.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                }];
            }
        }
    }
}


-(void)updateDataWidthSelectedPerson{
    //Atualizando texto de recado
    self.textViewPersonRecord.text = self.selectedPerson.umrecadoparaosouvintes;
    //Atualizando cidade
    self.lblCity.text = self.selectedPerson.cidadenatal;
    //Atualizando idade
    self.lblAge.text = self.selectedPerson.idade;
    //Atualizando estado civil
    self.lblMaritalStatus.text = self.selectedPerson.estadocivil;
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
    UIView * item = scrollItems[startScrollPositionItem-1];
    
    //retornando o centro do item do meio
    float result = item.center.x-8;
    
    return result;
}



-(void)StartLoading{
    
    //Iniciando LoadingView
    self.loadingView = [[UIView alloc]init];
    
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




@end
