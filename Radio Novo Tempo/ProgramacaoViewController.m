//
//  ProgramacaoViewController.m
//  Radio Novo Tempo
//
//  Created by MacMichas on 6/18/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "ProgramacaoViewController.h"
#import "ArgButton.h"
#import "ProgramacaoTableViewCell.h"
#import "AppDelegate.h"
#import "ProgramingItem.h"

@interface ProgramacaoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollDays;

//Dados
@property(nonatomic,strong) NSMutableArray * programingItems;
@property(nonatomic,strong) NSMutableArray * filteredprogramingItems;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property(nonatomic,strong) UIButton * cancelSearchButton;
@property (weak, nonatomic) IBOutlet UILabel *titlelbl;
@property(nonatomic,strong) UISearchBar * searchBar;

//Loading
@property(nonatomic,retain)IBOutlet UIImageView * imgLoading;
@property(nonatomic,retain)UIView * loadingView;
@property(nonatomic,retain)NSURLConnection * urlConnection;
@property(nonatomic)NSMutableData * urlData;

@property (weak, nonatomic) IBOutlet UITableView *tablePrograming;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenMenu;

//JsonError
@property(nonatomic,strong)UIAlertView * jsonFailAlertView;


@end

@implementation ProgramacaoViewController

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
    
    [self setupScrollDays];
    
    //Observando Framework de menu para quando abrir chamar este metodo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rotateBtnOpenMenu)
                                                 name:@"GestureOpenMenu"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unRotateBtnOpenMenu)
                                                 name:@"GestureCloseMenu"
                                               object:nil];
    
    
    self.programingItems = [[NSMutableArray alloc]init];
    
}

-(void)CallProgramJsonData:(NSNumber*)number{
        
        //Iniciando View de loading
        [self StartLoading];
        _searchButton.hidden = YES;
    
        AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //Create Request Values
        NSString * action = @"programing";
        NSNumber * idRadio = appDel.radioCurrent.radioId;
        
        //Chamando JSON
        NSString * adress = [NSString stringWithFormat:@"http://novotempo.com/api/radio/?action=%@&idRadio=%@&%d",action,idRadio,[number intValue]];
    
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
        AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSError *jsonParsingError = nil;
        
        NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:self.urlData options:NSJSONReadingMutableContainers error:&jsonParsingError];
        
        
        self.programingItems = [resultados objectForKey:@"daySchedule"];
        
        if (jsonParsingError || !self.programingItems || self.programingItems == (id)[NSNull null]){
            _jsonFailAlertView = [[UIAlertView alloc]initWithTitle:@"Desculpe" message:[NSString stringWithFormat:@"%@ '%@' %@",NSLocalizedString(@"A_RADIO", @"A rádio"),appDel.radioCurrent.name,NSLocalizedString(@"NAO_POSSUI_PROGRAMACAO", @"não possui programação disponível.")] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_jsonFailAlertView show];

            NSLog (@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
        }else{
            [self.loadingView removeFromSuperview];
            _scrollDays.userInteractionEnabled = YES;
            _searchButton.hidden = NO;
            _tablePrograming.hidden = NO;
            [_tablePrograming reloadData];
        }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == _jsonFailAlertView) {
        [self OpenMenuButtonPressed:nil];
    }
}


-(void)setupScrollDays{
    
    _scrollDays.contentSize = CGSizeMake(50*7 + 15, 56);
    _scrollDays.showsHorizontalScrollIndicator = NO;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];

    
    
    ArgButton * domingo = [[ArgButton alloc]initWithFrame:CGRectMake(0, 0, 70, 50)];
    domingo.ArgNumber1 = [NSNumber numberWithInt:1];
    domingo.ArgString1 = @"Dom";
    [self setupScrollDaysButton:domingo];
    (weekday  == [domingo.ArgNumber1 integerValue])?[self callJsonPrograming:domingo]: nil;
    ArgButton * segunda = [[ArgButton alloc]initWithFrame:CGRectMake(50, 0, 70, 50)];
    segunda.ArgNumber1 = [NSNumber numberWithInt:2];
    segunda.ArgString1 = @"Seg";
    [self setupScrollDaysButton:segunda];
    (weekday  == [segunda.ArgNumber1 integerValue])?[self callJsonPrograming:segunda]: nil;
    ArgButton * terca = [[ArgButton alloc]initWithFrame:CGRectMake(100, 0, 70, 50)];
    terca.ArgNumber1 = [NSNumber numberWithInt:3];
    terca.ArgString1 = @"Ter";
    [self setupScrollDaysButton:terca];
    (weekday  == [terca.ArgNumber1 integerValue])?[self callJsonPrograming:terca]: nil;
    ArgButton * quarta = [[ArgButton alloc]initWithFrame:CGRectMake(150, 0, 70, 50)];
    quarta.ArgNumber1 = [NSNumber numberWithInt:4];
    quarta.ArgString1 = @"Qua";
    [self setupScrollDaysButton:quarta];
    (weekday  == [quarta.ArgNumber1 integerValue])?[self callJsonPrograming:quarta]: nil;
    ArgButton * quinta = [[ArgButton alloc]initWithFrame:CGRectMake(200, 0, 70, 50)];
    quinta.ArgNumber1 = [NSNumber numberWithInt:5];
    quinta.ArgString1 = @"Qui";
    [self setupScrollDaysButton:quinta];
    (weekday  == [quinta.ArgNumber1 integerValue])?[self callJsonPrograming:quinta]: nil;
    ArgButton * sexta = [[ArgButton alloc]initWithFrame:CGRectMake(250, 0, 70, 50)];
    sexta.ArgNumber1 = [NSNumber numberWithInt:6];
    sexta.ArgString1 = @"Sex";
    [self setupScrollDaysButton:sexta];
    (weekday  == [sexta.ArgNumber1 integerValue])?[self callJsonPrograming:sexta]: nil;
    ArgButton * sabado = [[ArgButton alloc]initWithFrame:CGRectMake(300, 0, 70, 50)];
    sabado.ArgNumber1 = [NSNumber numberWithInt:7];
    sabado.ArgString1 = @"Sáb";
    [self setupScrollDaysButton:sabado];
    if(weekday  == [sabado.ArgNumber1 integerValue]){
        [self callJsonPrograming:sabado];
        [_scrollDays setContentOffset:CGPointMake(_scrollDays.frame.origin.x+50, 0) animated:NO];
    }
    
}

-(void)setupScrollDaysButton:(ArgButton *)sender{
    sender.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:15];
    sender.titleLabel.textColor = [UIColor whiteColor];
    [sender setTitle:sender.ArgString1 forState:UIControlStateNormal];
    [sender setTitleColor:[self getBlueColor] forState:UIControlStateHighlighted];
    [sender setTitleColor:[self getBlueColor] forState:UIControlStateSelected];
    [sender addTarget:self action:@selector(callJsonPrograming:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollDays addSubview:sender];
}

-(void)callJsonPrograming:(ArgButton *)sender{
    //Resetando cores dos botoes no scroll.
    [self changeButtonsTextColorToWhiteInScrollDays];
    
    //Selecionando o item chamado.
    [sender setTitleColor:[self getBlueColor] forState:UIControlStateNormal];
    
    [self CallProgramJsonData:sender.ArgNumber1];
}

-(void)changeButtonsTextColorToWhiteInScrollDays{
    for (ArgButton * item in _scrollDays.subviews) {
        if ([item isMemberOfClass:[ArgButton class]]) {
           [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

-(UIColor *)getBlueColor{
    return [UIColor colorWithRed:57.0f/255.0f green:157.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Checando se a tabela q vai ser mostrada é a filtrada ou a tabela normal.
    if ([self isFilteredResultActive]) {
        return [_filteredprogramingItems count];
    } else {
        
        if (![_programingItems isKindOfClass:[NSNull class]]) {
            return [_programingItems count];
        }
        
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProgramacaoTableViewCell* cell = (ProgramacaoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
   
    NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
    
    //Verificando se o resultado é filtrado
    if ([self isFilteredResultActive]) {
        item = [_filteredprogramingItems objectAtIndex:indexPath.row];
    } else {
        item = [_programingItems objectAtIndex:indexPath.row];
    }
    
    cell.textlbl.text = [item objectForKey:@"program"];
    cell.timelbl.text = [item objectForKey:@"time"];
    return cell;
}


- (IBAction)OpenMenuButtonPressed:(id)button{
    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [_searchBar resignFirstResponder];
    
}

- (IBAction)searchIndProgramList:(id)sender {

    //Criando Search Bar.
    _searchBar = [[UISearchBar alloc]initWithFrame:_scrollDays.frame];
    _searchBar.delegate = self;
    _searchBar.backgroundImage = [[UIImage alloc]init];
    _searchBar.barTintColor = [self getBlueColor];
    _searchBar.text = @"Buscar item";
    

    //Editando TextFild da SearchBar.
    UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
    txfSearchField.backgroundColor = [UIColor colorWithRed:80.0f/255.0f green:137.0f/255.0f blue:178.0f/255.0f alpha:1];
    txfSearchField.textColor = [UIColor whiteColor];
    txfSearchField.font = [UIFont fontWithName:@"ProximaNova-Light" size:16];
    txfSearchField.clearButtonMode = UITextFieldViewModeNever;
    txfSearchField.clearsOnBeginEditing = YES;
    
    UIImage *imageIcon = [UIImage imageNamed: @"favIconSearchBar.png"];
    UIImageView *iView = [[UIImageView alloc] initWithImage:imageIcon];
    iView.frame = CGRectMake(8, 7, 14, 14);
    txfSearchField.leftView = iView;
    

    //Criando botao de cancelar busca.
    _cancelSearchButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 95, self.view.frame.origin.y+34, 100, _titlelbl.frame.size.height)];
    _cancelSearchButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:18];
    [_cancelSearchButton setTitle:@"Cancelar" forState:UIControlStateNormal];
    [_cancelSearchButton setTitleColor:[UIColor colorWithRed:80.0f/255.0f green:137.0f/255.0f blue:178.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [_cancelSearchButton addTarget:self action:@selector(hideSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelSearchButton];
    
    _searchButton.hidden = YES;
    _scrollDays.hidden = YES;
    [self.view addSubview:_searchBar];
    
    [_searchBar becomeFirstResponder];
}

-(void)hideSearchBar{
    [_searchBar removeFromSuperview];
    [_cancelSearchButton removeFromSuperview];
    
    _searchButton.hidden = NO;
    _scrollDays.hidden = NO;
    
    //Limpando array filtrado
    [_filteredprogramingItems removeAllObjects];
    //Limpando a search bar
    _searchBar.text = nil;
    //Recarregando tabela.
    [_tablePrograming reloadData];
    //Escondendo teclado
    [_searchBar resignFirstResponder];
}


-(void)StartLoading{
    
    //Iniciando LoadingView
    self.loadingView = [[UIView alloc]init];
    _scrollDays.userInteractionEnabled = NO;
    _tablePrograming.hidden = YES;
    
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
    
    
    //Alinhando LoadingView
    self.loadingView.center = _tablePrograming.center; //self.view.center;
    self.loadingView.frame =  CGRectMake(_tablePrograming.frame.origin.x, _tablePrograming.frame.origin.y, _tablePrograming.frame.size.width, self.view.frame.size.height-192);
    
    
    //Alinhando Componentes
    img.center = CGPointMake(CGRectGetMidX(self.loadingView.bounds), CGRectGetMidY(self.loadingView.bounds));
    img.frame = CGRectMake(img.frame.origin.x, img.frame.origin.y - 30, img.frame.size.width, img.frame.size.height);
   [img.layer addAnimation:rotate forKey:@"10"];
   
    
    
    txt.frame = CGRectMake(img.frame.origin.x + 10, img.frame.origin.y + 85, img.frame.size.width, img.frame.size.height);
    
    //Inserindo Componentes na LoadingView
    [self.loadingView addSubview:txt];
    [self.loadingView addSubview:img];
    
    

    //Alterando Cor de Fundo da LoadingView
    self.loadingView.backgroundColor = [UIColor whiteColor];
    
    //Inserindo LoadingView na View principal
    [self.view addSubview: self.loadingView];
    
}


-(BOOL)isFilteredResultActive{
    
    if (_filteredprogramingItems.count != 0 || [_searchBar.text length] != 0 )
        return YES;
    
    return NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //Limpando array filtrado
    [_filteredprogramingItems removeAllObjects];
    //Criando filtro
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.program contains[c] %@",searchBar.text];
    _filteredprogramingItems = [NSMutableArray arrayWithArray:[_programingItems filteredArrayUsingPredicate:predicate]];
    //Recarregando tabela.
    [_tablePrograming reloadData];
}

-(void)rotateBtnOpenMenu{
    
    //Criando animaçao
    [UIView animateWithDuration:0.5 animations:^{
        [self.btnOpenMenu setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        self.btnOpenMenu.center =  CGPointMake(CGRectGetMidX(self.btnOpenMenu.frame),CGRectGetMidY(self.btnOpenMenu.frame));
        [_searchBar resignFirstResponder];
    }];
    
    self.needResetAnimation = YES;
}


-(void)unRotateBtnOpenMenu{
    
    if (self.needResetAnimation) {
        //Criando animaçao
        [UIView animateWithDuration:0.5 animations:^{
            [self.btnOpenMenu setTransform:CGAffineTransformIdentity];
            self.btnOpenMenu.center =  CGPointMake(CGRectGetMidX(self.btnOpenMenu.frame),CGRectGetMidY(self.btnOpenMenu.frame));
            [_searchBar resignFirstResponder];
        }];
    }
    
}

@end
