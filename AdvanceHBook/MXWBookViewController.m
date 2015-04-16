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
#import "ReaderDocument.h"

@interface MXWBookViewController ()

@property (strong, nonatomic) ReaderDocument * document;
@property (strong, nonatomic) ReaderViewController *readerViewController;

@end

@implementation MXWBookViewController

- (id) initWithModel:(MXWBook *) aBook {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _book = aBook;
        _document = nil;
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

- (void) manageBook {
    self.imgPrortraid.image = self.book.portraidImg;
    
    if ([self.book.finished isEqual:[NSNumber numberWithBool:YES]]) {
        
        self.imgFinished.image = [UIImage imageNamed:@"TheEnd.jpg"];
        
    } else {
        
        self.imgFinished.image = nil;
        
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
    
    if (self.book.lastDayAcces) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        //NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        self.lblLastDayAcces.text = [[dateFormatter stringFromDate:self.book.lastDayAcces ]
        //                              descriptionWithLocale: [NSLocale autoupdatingCurrentLocale]]]
                                     stringByAppendingString:[NSString stringWithFormat:@"\n(page: %@)",self.book.lastPage]];
    } else self.lblLastDayAcces.text = @"";
    
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

#pragma mark - Actions
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
        
        NSData * file = self.book.pdfData;
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSArray * fmURL = [fm URLsForDirectory: NSCachesDirectory
                                     inDomains: NSUserDomainMask];
        
        NSString * element = @"AdvHBook.pdf";
        
        NSURL * urlF = [fmURL lastObject];
        
        urlF = [urlF URLByAppendingPathComponent:element];
        
        [fm createFileAtPath:[urlF path]
                    contents:file
                  attributes:nil];
        

        
        //NSString * aStr = nil;
        
        self.document = [ReaderDocument  withDocumentFilePath:[urlF path]
                                                                password:nil];
        
        if (self.document != nil)
        {
            
            [self.document changeInitialTitle:self.book.title];
            
            [self.document changeInitialPageNumber:self.book.lastPage];
            
            self.readerViewController = nil;
            self.readerViewController = [[ReaderViewController alloc]
                                                          initWithReaderDocument:self.document];
            self.readerViewController.delegate = self;
            
            self.readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            self.readerViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            
            
            //[self presentViewController:readerViewController animated:YES completion:^{
                
            //}];
            
            self.readerViewController.title = self.book.title;
            self.readerViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            
            UIBarButtonItem *dismis = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self action:@selector(dismissReaderViewController:)];
            
            self.readerViewController.navigationItem.rightBarButtonItem = dismis;

            
            [self.navigationController pushViewController:self.readerViewController
                                                 animated:YES];
            
        }
        
    }
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

#pragma mark - ReaderViewControllerDelegate
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    
    self.document = [self.readerViewController getReaderDocument];
    
    self.book.lastPage = self.document.pageNumber;
    
    self.book.lastDayAcces = [NSDate date];
    
    if ([self.document.pageNumber isEqualToNumber:self.document.pageCount]) {
        self.book.finished = [NSNumber numberWithBool:YES];
    }
    
    [self.readerViewController dismissViewControllerAnimated:YES completion:^{
    
    }];
    
    [self.navigationController popToViewController:self
                                          animated:YES];
}

@end
