//
//  GerenciadorCompras.m
//  ComprasNoAplicativo
//
//  Created by Rafael Brigagão Paulino on 19/10/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import "GerenciadorCompras.h"

@interface GerenciadorCompras()
{
   //objeto que vai relizar uscas por info dos produtos
    SKProductsRequest *requisicaoProdutos;
}

@end

@implementation GerenciadorCompras

- (id)init
{
    self = [super init];
    
    if (self)
    {
        //quando fizermos um pedido de comorar, teremos que setar quem vai ser o "delegate"que vai visualizar as atualizacoes do status da compra. No caso ele se chama observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        //nossa classe sera a responsavel por tratar essas resposstas da appstore
    }
    
    return self;
}


//metodo sera acionado pelo VC quando o usuario quiser ter mais infos sobre um produto
-(void)obterDadosDoProduto:(NSString*)produtoID delegate:(id<GerenciadorComprasDelegate>)aDelegate
{
   //criar uma requisicao para  produto pedido, podemos passar mais do que um produto
    requisicaoProdutos = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:produtoID]];
    
    //avisando para o objeto que faz conexao com appstore que este é o seu delegate
    //avisando ao objeto de requisiscao que quando ele nos acionar quando as infos do produto chegar
    requisicaoProdutos.delegate = self;
    
    //quando a requisicao chegar nos avisaremos para a tela (ViewController)
    //guardando a instancia de quem deveremos acionar para enviar as infos do produto
    _delegate = aDelegate;
    
    [requisicaoProdutos start];
}


//metodo acionado quando chega as infos sobre o produto da appstore
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
  //conseguimos pegar a busca do produto que falhou atraves do array invalidProductIdentifiers
    //response.invalidProductIDENTIFIERS
    
    //CONSEGUIMOs pegar as buscas que deram certo no array products
    //dentro dessde array teremos objetos do tipo SKProduct
    if(response.products.count > 0)
    {
        
        //vamos acionar nossa tela e mandar o produto para ela
        [_delegate chegouDadosProduto:[response.products objectAtIndex:0]];
    }
}



-(void)comprarProduto:(SKProduct*)produto delegate:(id<GerenciadorComprasDelegate>)aDelegate
{
    //criar um objeto de transacao
    SKPayment *pagamento = [SKPayment paymentWithProduct:produto];
    
    //adicionar este pagamento na fila
    //quando o pagamento obter uma resposta, seremos acionado pelo transactionObserver
    [[SKPaymentQueue defaultQueue] addPayment:pagamento];
    
    _delegate = aDelegate;
}



//emtodo acionado sempre quando muda o status de um pagamento
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *pagamento in transactions)
    {
        if (pagamento.transactionState == SKPaymentTransactionStatePurchased)
        {
           //compra bem sucedida, devemos avisar a nossa tela que esta tudo ok
            //estamos enviando o objeto dessa transacao para o VC para que ele possafinalizala depois de enttegar o produto
            [_delegate compraRealizadaComSucesso:pagamento];
        }
        else if (pagamento.transactionState == SKPaymentTransactionStateFailed)
        {
            //compra nao deu cero bem provsvel que seja por falta de credito
            [_delegate compraFalhou];
        }
        else if (pagamento.transactionState == SKPaymentTransactionStateRestored)
        {
            //a compra ja estava ok, mas nao finalizamos ela corretamente, devemos tentar pedir para o usuaario baixar o produto novamente
            [_delegate compraRealizadaComSucesso:pagamento];
        }
    }
}



//metodo acionado depois que a compra foi entregue ao clinente, obrigatoriamente devemos finalizar as traansacoes bem sucedidas
-(void)finalizarComprar:(SKPaymentTransaction*)transacao
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transacao];
}

@end
