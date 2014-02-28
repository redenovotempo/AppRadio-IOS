//
//  EquipeViewController.m
//  Radio Novo Tempo
//
//  Created by Michel  Lopes on 2/16/14.
//  Copyright (c) 2014 Novo Tempo. All rights reserved.
//

#import "EquipeViewController.h"

int numberOfPages = 7;
int widthOfPage = 100;
int heightOfPage = 100;
int screenSize = 0;
CGFloat FIRST_PADDING_LEFT = 50;
CGFloat PADDING_LEFT = 50;
BOOL isScrollNeedMove = YES;

@interface EquipeViewController ()

@property(nonatomic)UIButton * btnMain;
@property(nonatomic)UIScrollView * scroll;

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
    //Pegando tamanho da tela
    screenSize = (self.view.frame.size.width/2);
    
    if (isScrollNeedMove) {
        //Mandando scroll pro quadrado default
        [self.scroll setContentOffset:CGPointMake([self scrollStartPositionOnCenterItem], 0) animated:NO];
        isScrollNeedMove = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect frame = CGRectMake(0, 73, self.view.frame.size.width, 150);
    self.scroll = [[UIScrollView alloc]initWithFrame:frame];
    self.scroll.delegate = self;
    self.scroll.backgroundColor = [UIColor redColor];
    self.scroll.pagingEnabled = NO;
    
    UIButton * btnLast = nil;

    for (int i = 0; i<numberOfPages; i++) {
        if (btnLast != nil) {
            FIRST_PADDING_LEFT = 0;
        }
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btnLast.frame.origin.x+btnLast.frame.size.width+PADDING_LEFT+FIRST_PADDING_LEFT,25, widthOfPage, 100)];
        btn.backgroundColor = [UIColor blackColor];
        [self.scroll addSubview:btn];
        
        btnLast = btn;
    }
 
    self.scroll.contentSize = CGSizeMake((numberOfPages*widthOfPage)+((numberOfPages+1)*(PADDING_LEFT+15)), 1);
    [self.view addSubview:self.scroll];
    
    //criando marcador do meio
    self.btnMain = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 10, 50)];
    self.btnMain.center = CGPointMake(self.scroll.center.x, self.scroll.center.y-80);
    self.btnMain.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.btnMain];
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

-(float)scrollStartPositionOnCenterItem{
    //pegando itens do scroll
    NSArray * scrollItems =  self.scroll.subviews;
    if ([scrollItems count] == 0) {
        return 0;
    }
    //pegando posiçao do meio
    int startScrollPositionItem = (int)(scrollItems.count/2);
    //pegando item da posicao
    UIButton * item = scrollItems[startScrollPositionItem-1];
    //retornando o centro do item do meio
    return item.center.x;
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    int scrollPosition = aScrollView.contentOffset.x;
    NSArray * buttons =  aScrollView.subviews;
    for (UIButton * btnItem in buttons) {
        
        if (((scrollPosition + screenSize) <= btnItem.center.x + (widthOfPage/2)) && ((scrollPosition+ screenSize) >= btnItem.center.x - (widthOfPage/2))) {
            btnItem.backgroundColor = [UIColor blueColor];
            btnItem.frame = CGRectMake(btnItem.frame.origin.x, btnItem.frame.origin.y, widthOfPage + 20, heightOfPage + 20);
        }else{
            btnItem.backgroundColor = [UIColor blackColor];
            btnItem.frame = CGRectMake(btnItem.frame.origin.x, btnItem.frame.origin.y, widthOfPage, heightOfPage);
        }
    }
}


@end
