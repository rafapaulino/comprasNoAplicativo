//
//  GerenciadorCompras.h
//  ComprasNoAplicativo
//
//  Created by Rafael Brigagão Paulino on 19/10/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol GerenciadorComprasDelegate <NSObject>

@required

-(void)chegouDadosProduto:(SKProduct*)produto;

-(void)compraRealizadaComSucesso:(SKPaymentTransaction*)transacao;

-(void)compraFalhou;

@end

@interface GerenciadorCompras : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, weak) id<GerenciadorComprasDelegate> delegate;


-(void)obterDadosDoProduto:(NSString*)produtoID delegate:(id<GerenciadorComprasDelegate>)aDelegate;


-(void)comprarProduto:(SKProduct*)produto delegate:(id<GerenciadorComprasDelegate>)aDelegate;



//metodo acionado depois que a compra foi entregue ao clinente, obrigatoriamente devemos finalizar as traansacoes bem sucedidas
-(void)finalizarComprar:(SKPaymentTransaction*)transacao;



@end
