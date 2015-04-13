//
//  MXWBookViewController.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/13/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWBookViewController.h"
#import "MXWBook.h"
#import "MXWNote.h"

@interface MXWBookViewController ()

@end

@implementation MXWBookViewController

- (id) initWithModel:(MXWBook *) aBook {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _book = aBook;
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.imgPrortraid.image = self.book.portraidImg;
    
    if ([self.book.finished isEqual:[NSNumber numberWithBool:YES]]) {

        self.imgFinished.image = [UIImage imageNamed:@"TheEnd.jpg"];
    
    }
    
    if ([self.book.favorites isEqual:[NSNumber numberWithBool:YES]]) {
        
        UIImage * btnImage = [UIImage imageNamed:@"starUP.png"];
        [self.buttonFavorite setImage:btnImage
                             forState:UIControlStateNormal];
        
        
    } else {
        
        UIImage * btnImage = [UIImage imageNamed:@"starDOWM.png"];
        [self.buttonFavorite setImage:btnImage
                             forState:UIControlStateNormal];
        
    }
    
    if (self.book.pdfData == nil) {
        UIImage * btnImage = [UIImage imageNamed:@"pdfdownload.png"];
        [self.buttonFavorite setImage:btnImage
                             forState:UIControlStateNormal];
    } else {
        UIImage * btnImage = [UIImage imageNamed:@"pdf.gif"];
        [self.buttonFavorite setImage:btnImage
                             forState:UIControlStateNormal];
    }
    
}


- (IBAction)actionFavorite:(id)sender {
    
    
    
}

- (IBAction)actionPDF:(id)sender {
    
    if (self.book.pdfData == nil) {
        
        UIImage * btnImage = [UIImage imageNamed:@"pdfdownloading.gif"];
        [self.buttonFavorite setImage:btnImage
                             forState:UIControlStateNormal];
        
        [self.book downloadPDFwithCompletionBlock:^(bool downloaded) {
            if (downloaded) {
                UIImage * btnImage = [UIImage imageNamed:@"pdf.gif"];
                [self.buttonFavorite setImage:btnImage
                                     forState:UIControlStateNormal];
            }
            
        }];
    } else {
        // abri el PDF VC
    }
}
@end
