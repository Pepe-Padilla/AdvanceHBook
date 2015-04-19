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
#import "MXWNotesCollectionViewController.h"
#import "Header.h"

@interface MXWBookViewController ()

@property (strong, nonatomic) ReaderDocument * document;
@property (strong, nonatomic) ReaderViewController *readerViewController;
@property (nonatomic) BOOL onPDF;
//@property (nonatomic) SEL aSel;

@end

@implementation MXWBookViewController

- (id) initWithModel:(MXWBook *) aBook {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _book = aBook;
        _document = nil;
        self.title = aBook.title;
        _onPDF = NO;
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout= UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    //self.aSel = self.splitViewController.displayModeButtonItem.action;
    self.onPDF = NO;
    
    [self manageBook];
    [self setupKVO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self tearDownKVO];
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
    
    [self manageCollectionViewController];
    //self.cvNotes = //UICollectionView
    
    self.title = self.book.title;
}

- (void) manageCollectionViewController {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(155, 130);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    //                    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>);
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    
    layout.headerReferenceSize = CGSizeMake(20, 20);
    
    MXWNotesCollectionViewController * nvc = [[MXWNotesCollectionViewController alloc]
                                              initWithFetchedResultsController:[self.book fetchForNotes] layout:layout];
    
    nvc.collectionView = self.cvNotes;
    
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
            
            //self.readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //self.readerViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            
            
            //[self presentViewController:readerViewController animated:YES completion:^{
                
            //}];
            
            self.readerViewController.title = self.book.title;
            self.readerViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            
            
            UIBarButtonItem *dismis = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                       target:self action:@selector(dismissReaderViewController:)];
            
            UIBarButtonItem *addNote = [[UIBarButtonItem alloc] initWithTitle:@"Add Note"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(addNote)];
            
            NSArray * arrItems = @[dismis,addNote];
            
            self.readerViewController.navigationItem.rightBarButtonItems = arrItems;
            
            //self.readerViewController.navigationItem.leftBarButtonItem = addNote;
            
            self.onPDF = YES;
            
            
            [self.navigationController pushViewController:self.readerViewController
                                                 animated:YES];
            //UINavigationController *navController = self.splitViewController.viewControllers[0];
            
            
            if ([self.splitViewController displayMode] == UISplitViewControllerDisplayModePrimaryHidden) {
                //[self.splitViewController separateSecondaryViewControllerForSplitViewController:self.splitViewController];
                //self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
                //[self performSelector:self.aSel];//self.splitViewController.displayModeButtonItem.action];
                //[self.splitViewController showViewController:<#(UIViewController *)#> sender:self]
            }
            
            
            
            
            if ([self.delegate respondsToSelector:@selector(bookViewController:didViewPDF:)]) {
                [self.delegate bookViewController:self
                                       didViewPDF:self.book];
            }
            
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            
            NSDictionary * dict = @{BOOK_PDF : self.book};
            
            NSNotification * n = [NSNotification notificationWithName: BOOK_VIEW_PDF_OPEN
                                                               object: self
                                                             userInfo: dict];
            [nc postNotification:n];

            
        }
        
    }
}

-(void) addNote {
    
    self.document = [self.readerViewController getReaderDocument];
    MXWNote * n = [MXWNote noteWithPage:self.document.pageNumber
                                context:self.book.managedObjectContext];
    [self.book addNotesObject:n];
    
}


#pragma mark - MXWLibraryViewControllerDelegate
-(void) libraryTableViewController: (MXWLibraryViewController *) lVC
                     didSelectBook: (MXWBook *) aBook{
    
    self.book = aBook;
    
    [self manageBook];
    
}

- (MXWBook*) libraryTableViewControllerPDFActive:(MXWLibraryViewController *) lVC {
    if (self.onPDF) {
        return self.book;
    } else {
        return nil;
    }
}


#pragma mark - UISplitViewControllerDelegate
-(void) splitViewController:(UISplitViewController *)svc
    willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        // tabla oculta
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
        //self.aSel = svc.displayModeButtonItem.action;
    } else {
        //Se muestra la tabla
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    
}

#pragma mark - ReaderViewControllerDelegate
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    
    self.onPDF = NO;
    
    if ([self.delegate respondsToSelector:@selector(bookViewController:didClosePDF:)]) {
        [self.delegate bookViewController:self
                              didClosePDF:self.book];
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    NSDictionary * dict = @{BOOK_PDF : self.book};
    
    NSNotification * n = [NSNotification notificationWithName: BOOK_VIEW_PDF_CLOSE
                                                       object: self
                                                     userInfo: dict];
    [nc postNotification:n];
    
    self.document = [self.readerViewController getReaderDocument];
    
    self.book.lastPage = self.document.pageNumber;
    
    self.book.lastDayAcces = [NSDate date];
    
    if ([self.document.pageNumber isEqualToNumber:self.document.pageCount]) {
        self.book.finished = [NSNumber numberWithBool:YES];
    }
    
    [self.readerViewController dismissViewControllerAnimated:YES completion:^{
    
    }];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - KVO
-(void) setupKVO{
    
    if (self.book.portraid == nil)
    [self.book addObserver:self
                forKeyPath:MXWBookAttributes.portraid
                   options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                   context:NULL];
    
}

-(void) tearDownKVO{
    // si me doy de baja el KVO en el viewWillDisaper me da un excepción de que el elemento ya observado ya no existe.
}

-(void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    self.imgPrortraid.image = self.book.portraidImg;
    [self.book removeObserver:self
                   forKeyPath:MXWBookAttributes.portraid];
}


@end
