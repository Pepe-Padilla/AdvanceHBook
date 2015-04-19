//
//  MXWLibraryViewController.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/12/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWLibraryViewController.h"
#import "MXWBookViewController.h"
#import "MXWTag.h"
#import "MXWAuthor.h"
#import "MXWLibraryMng.h"
#import "Header.h"
#import "MXWNotesCollectionViewController.h"

@interface MXWLibraryViewController ()

@property (strong,nonatomic) MXWLibraryMng * library;
@property (strong,nonatomic) NSMutableDictionary * mdHeader;
@property (strong,nonatomic) NSMutableDictionary * mdFavorites;
@property (strong,nonatomic) NSMutableDictionary * mdGenders;
@property (strong,nonatomic) NSMutableDictionary * mdTitles;
@property (strong,nonatomic) NSMutableArray * maTags;
@property (strong,nonatomic) NSMutableArray * maAuthors;

@end

@implementation MXWLibraryViewController

//-(id) initWithArray:(NSMutableArray *)arrayOfFetchC style:(UITableViewStyle)aStyle {
//
//}

- (id) initWithStyle:(UITableViewStyle)style{
    if (self=[super initWithStyle:style]) {
        
        _library = [[MXWLibraryMng alloc] init];
        _mdHeader = [[NSMutableDictionary alloc] init];
        _mdFavorites = [[NSMutableDictionary alloc] init];
        _mdGenders = [[NSMutableDictionary alloc] init];
        _maTags = [[NSMutableArray alloc] init];
        _maAuthors = [[NSMutableArray alloc] init];
        
        self.title = @"Library";
        
    }
    
    return self;
}

- (void) manageStart {
    
    [self.library beginStack];
    
    NSError * error = nil;
    if (![self.library chargeLibrayWithError:&error]) {
        NSLog(@"Error in library: %@",error.userInfo);
    }
    
    
    
    self.mdHeader = [NSMutableDictionary
                     dictionaryWithDictionary:@{TITLE_SECTION : @"",
                                                SECTION_FRC : @"NO",
                                                NOFRC_COUNT : @1 }];
    
    self.mdFavorites = [self.library fetchForFavorites];
    self.mdGenders = [self.library fetchForGenders];
    self.maTags = [self.library fetchForTags];
    self.maAuthors = [self.library fetchForAuthors];
    
    NSMutableArray * aSections = [NSMutableArray arrayWithArray:@[self.mdFavorites]];
    
    [aSections addObjectsFromArray:self.maTags];
    
    [self setFetchedArray:aSections];
    [self.library autoSave];
}

- (NSManagedObjectContext*) librayContext {
    return [self.library contextOfLibrary];
}

#pragma mark - Life cycle
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter ];
    [nc addObserver:self
           selector:@selector(bookViewDidViewPDF:)
               name:BOOK_VIEW_PDF_OPEN
             object:nil];
    
    [nc addObserver:self
           selector:@selector(bookDidClosePDF:)
               name:BOOK_VIEW_PDF_CLOSE
             object:nil];
    
    if ([self.delegate respondsToSelector:@selector(libraryTableViewControllerPDFActive:)]) {
    
        MXWBook * aBook = [self.delegate libraryTableViewControllerPDFActive:self];
        
        if (aBook) {
            [self bookViewDidViewPDFWithBook:aBook];
        } else {
            [self bookDidClosePDF:nil];
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // Averiguar cual es la libreta
    id obj = [self fetchedObjectAtIndexPath:indexPath];
    
    MXWBook *b = nil;
    if ([obj isKindOfClass:[MXWBook class]]) {
        b=obj;
        
        
        // Crear una celda
        static NSString *cellID = @"notebookCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:cellID];
        }
        
        // Configurarla (sincronizar libreta -> celda)
        NSArray * aAtuthors = [b.authors allObjects];
        NSString * strAuthors = @"";
        
        for (MXWAuthor* auth in aAtuthors) {
            if (![strAuthors isEqualToString:@""]) {
                strAuthors = [strAuthors stringByAppendingString:@", "];
            }
            strAuthors = [strAuthors stringByAppendingString:auth.authorName];
        }
        
        cell.textLabel.text = b.title;
        cell.detailTextLabel.text = strAuthors;
        cell.imageView.image = b.portraidImg;
        
        // Devolverla
        return cell;
    } else {
        // Crear una celda
        static NSString *cellID = @"notebookCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:cellID];
        }
        
        cell.textLabel.text = @"Special Cell";
        
        return cell;
    }
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Averiguar cual es la libreta
    //NSLog(@"indexpagth section-row: %d - %d",indexPath.section, indexPath.row);
    
    id obj = [self fetchedObjectAtIndexPath:indexPath];
    
    MXWBook *b = nil;
    if ([obj isKindOfClass:[MXWBook class]]) {
        b=obj;
        
        if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
            [self.delegate libraryTableViewController:self
                                        didSelectBook:b];
        }
        //MXWBookViewController * bVC = [[MXWBookViewController alloc] initWithModel:b];
        
        NSData * bookdData = [b archiveURIRepresentation];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:bookdData
                     forKey:[NSString stringWithFormat:@"MXWbook_selected"]];
        [defaults synchronize];
    }
}

#pragma mark - Notification
// BOOK_VIEW_PDF_OPEN
- (void) bookViewDidViewPDF:(NSNotification*) notification{
    
    MXWBook * aBook = [notification.userInfo objectForKey:BOOK_PDF];
    [self bookViewDidViewPDFWithBook:aBook];
}

-(void) bookViewDidViewPDFWithBook:(MXWBook*) aBook {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(155, 130);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    //                    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>);
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    
    layout.headerReferenceSize = CGSizeMake(20, 20);
    
    MXWNotesCollectionViewController * ncvc = [[MXWNotesCollectionViewController alloc]
                                               initWithFetchedResultsController:[aBook fetchForNotes]
                                               layout:layout];
    
    UIBarButtonItem *blanckB = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:nil];
    
    ncvc.navigationItem.leftBarButtonItem = blanckB;
    
    [self.navigationController pushViewController:ncvc
                                         animated:YES];
    
    self.navigationItem.leftBarButtonItem = blanckB;
}

// BOOK_VIEW_PDF_CLOSE
- (void) bookDidClosePDF :(NSNotification*) notification{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
