//
//  ViewController.m
//  ComprasNoAplicativo
//
//  Created by Rafael Brigagão Paulino on 19/10/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    GerenciadorCompras *minhaLoja;
    
    SKProduct *produtoASerComprado;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    minhaLoja = [[GerenciadorCompras alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)buscarInfoProduto:(id)sender
{
    //pedir infos de umj produto especifico
    [minhaLoja obterDadosDoProduto:@"com.rafapaulino.ComprasNoAplicativo.idDoMeuProduto" delegate:self];
    
    
}


-(void)chegouDadosProduto:(SKProduct *)produto
{
    NSLog(@"Dados: %@ - %@", produto.localizedTitle, produto.localizedDescription);
    
    produtoASerComprado = produto;
}



- (IBAction)comprarProduto:(id)sender
{
    [minhaLoja comprarProduto:produtoASerComprado delegate:self];
}


-(void)compraFalhou
{
    NSLog(@"Erro ao efetuar a compra");
}

-(void)compraRealizadaComSucesso:(SKPaymentTransaction *)transacao
{
    NSLog(@"A compra foi efetuada com sucesso. Pode fazer o download do produto. Ou liberar uma nova fase. Ou aumentar a quantidade de moedinhas");
    //e nesse momento que devemos fazer as setagens para liberar o produto para o cliente
    
    //ao final da liberacao do produto, devemos finalizar a compra
    [minhaLoja finalizarComprar:transacao];
}




@end
