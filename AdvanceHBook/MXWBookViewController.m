//
//  MXWBookViewController.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/13/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWBookViewController.h"
#import "MXWBook.h"
#import "MXWTag.h"
#import "MXWAuthor.h"
#import "MXWGender.h"
#import "MXWNote.h"
#import "MXWNote.h"

@interface MXWBookViewController ()

@end

@implementation MXWBookViewController

- (id) initWithModel:(MXWBook *) aBook {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _book = aBook;
        self.title = aBook.title;
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout= UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;

    [self manageBook];
}


- (IBAction)actionFavorite:(id)sender {
    
    if ([self.book.favorites isEqual:[NSNumber numberWithBool:YES]]) {
        
        self.book.favorites =[NSNumber numberWithBool:NO];
        
        UIImage * btnImage = [UIImage imageNamed:@"starDOWN.png"];
        [self.buttonFavorite setImage:btnImage
                             forState:UIControlStateNormal];
        
    } else {
        
        self.book.favorites =[NSNumber numberWithBool:YES];
        
        UIImage * btnImage = [UIImage imageNamed:@"starUP.png"];
        [self.buttonFavorite setImage:btnImage
                             forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)actionPDF:(id)sender {
    
    if (self.book.pdfData == nil) {
        
        UIImage * btnImage = [UIImage imageNamed:@"pdfdownloading.gif"];
        [self.buttonPDF setImage:btnImage
                             forState:UIControlStateNormal];
        
        [self.book downloadPDFwithCompletionBlock:^(bool downloaded) {
            if (downloaded) {
                UIImage * btnImage = [UIImage imageNamed:@"pdf.gif"];
                [self.buttonPDF setImage:btnImage
                                     forState:UIControlStateNormal];
            }
            
        }];
    } else {
        // abri el PDF VC
    }
}

- (void) manageBook {
    self.imgPrortraid.image = self.book.portraidImg;
    
    if ([self.book.finished isEqual:[NSNumber numberWithBool:NO]]) {
        
        self.imgFinished.image = [UIImage imageNamed:@"TheEnd.jpg"];
        
    }
    
    if ([self.book.favorites isEqual:[NSNumber numberWithBool:YES]]) {
        
        UIImage * btnImage = [UIImage imageNamed:@"starUP.png"];
        [self.buttonFavorite setImage:btnImage
                             forState:UIControlStateNormal];
        
        
    } else {
        
        UIImage * btnImage = [UIImage imageNamed:@"starDOWN.png"];
        [self.buttonFavorite setImage:btnImage
                             forState:UIControlStateNormal];
        
    }
    
    if (self.book.pdfData == nil) {
        UIImage * btnImage = [UIImage imageNamed:@"pdfdownload.png"];
        [self.buttonPDF setImage:btnImage
                             forState:UIControlStateNormal];
    } else {
        UIImage * btnImage = [UIImage imageNamed:@"pdf.gif"];
        [self.buttonPDF setImage:btnImage
                             forState:UIControlStateNormal];
    }
    
    if (self.book.lastDayAcces)
        self.lblLastDayAcces.text = [[self.book.lastDayAcces
                                     descriptionWithLocale:[NSLocale autoupdatingCurrentLocale]]
                                     stringByAppendingString:[NSString stringWithFormat:@"(%@)",self.book.lastPage]];
    
    self.lblTitle.text = self.book.title;
    
    NSArray * tagNames =[self.book.tags allObjects];
    NSString * theTags = @"";
    for (MXWTag * aTag in tagNames) {
        if (![theTags isEqualToString:@""])
            theTags = [theTags stringByAppendingString:@", "];
        
        theTags = [theTags stringByAppendingString:aTag.tagName];
    }
    self.lblTags.text = [@"Tags: " stringByAppendingString:theTags];
    
    NSArray * authorNames =[self.book.authors allObjects];
    NSString * theAuthors = @"";
    for (MXWAuthor * aAuthor in authorNames) {
        if (![theAuthors isEqualToString:@""])
            theAuthors = [theAuthors stringByAppendingString:@", "];
        
        theAuthors = [theAuthors stringByAppendingString:aAuthor.authorName];
    }
    self.lblAuthors.text = [@"Author(s): " stringByAppendingString:theAuthors];
    
    //self.lblGender.text = self.book.genders.genderName;
    
    //self.cvNotes = //UICollectionView
    
    self.title = self.book.title;
}

#pragma mark - MXWLibraryViewControllerDelegate
-(void) libraryTableViewController: (MXWLibraryViewController *) lVC
                     didSelectBook: (MXWBook *) aBook{
    
    self.book = aBook;
    
    [self manageBook];
    
}


#pragma mark - UISplitViewControllerDelegate
-(void) splitViewController:(UISplitViewController *)svc
    willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        // tabla oculta
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    } else {
        //Se muestra la tabla
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    
}

@end
