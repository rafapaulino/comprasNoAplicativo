//
//  ViewController.h
//  ComprasNoAplicativo
//
//  Created by Rafael Brigagão Paulino on 19/10/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GerenciadorCompras.h"

@interface ViewController : UIViewController <GerenciadorComprasDelegate>

- (IBAction)buscarInfoProduto:(id)sender;

- (IBAction)comprarProduto:(id)sender;

@end
