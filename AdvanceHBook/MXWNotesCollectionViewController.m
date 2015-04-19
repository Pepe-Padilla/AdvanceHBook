//
//  MXWNotesCollectionViewController.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/16/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWNotesCollectionViewController.h"
#import "MXWNote.h"
#import "MXWNoteCollectionViewCell.h"
#import "MXWBookViewController.h"
#import "Header.h"

@interface MXWNotesCollectionViewController ()


@end

@implementation MXWNotesCollectionViewController

static NSString * const reuseCellIdentifier = @"NotesCVCell";
static NSString * const reuseHeaderIdentifier = @"NotesCVHeader";

#pragma mark - Xib registration
-(void) registerNib {
    //personalizado
    UINib * nib = [UINib nibWithNibName:@"MXWNoteCollectionViewCell" bundle:nil];
    
    [self.collectionView registerNib:nib
          forCellWithReuseIdentifier:reuseCellIdentifier];
    
    //generico
    //[self.collectionView registerClass:[MXWNoteCollectionViewCell class]
    //        forCellWithReuseIdentifier:reuseCellIdentifier];
}

#pragma mark - Life cycle
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter ];
    [nc addObserver:self
           selector:@selector(bookDidClosePDF:)
               name:BOOK_VIEW_PDF_CLOSE
             object:nil];
    
    UIBarButtonItem *blanckB = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:nil];
    
    self.navigationItem.leftBarButtonItem = blanckB;
    
    NSArray *splitAr = self.splitViewController.viewControllers;
    NSArray *detailAr = [splitAr[1] childViewControllers];
    if (detailAr.count == 1) {
        [self bookDidClosePDF:nil];
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self registerNib];
    
    // Register headers Sections
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:reuseHeaderIdentifier];
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

#pragma mark <UICollectionViewDataSource>
- (UICollectionReusableView *) collectionView: (UICollectionView *)collectionView
            viewForSupplementaryElementOfKind: (NSString *)kind
                                  atIndexPath: (NSIndexPath *)indexPath {
    
    UICollectionReusableView * supView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        supView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                     withReuseIdentifier:reuseHeaderIdentifier
                                                            forIndexPath:indexPath];
        for (UIView *each in supView.subviews) {
            [each removeFromSuperview];
        }
        
        supView.backgroundColor = [UIColor lightGrayColor];
        
        UILabel * tittle = [[UILabel alloc] initWithFrame:supView.bounds];
        tittle.textColor = [UIColor colorWithWhite:0.87 alpha:1.0];
        tittle.text = [NSString
                       stringWithFormat: @"Page: %@",
                       [[[self.fetchedResultsController sections]
                         objectAtIndex:indexPath.section] name]];
        
        [supView addSubview:tittle];
        
        //
    } else {
        return nil;
    }
    
    return supView;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MXWNote * n = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    MXWNoteCollectionViewCell *cell = [collectionView
                                       dequeueReusableCellWithReuseIdentifier:reuseCellIdentifier
                                       forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor yellowColor];
    
    cell.imgNote.image = n.noteImg;
    
    cell.imgNote.transform = CGAffineTransformIdentity;
    
    long l = (arc4random() % 100) / 100.0l ;
    cell.imgNote.transform = CGAffineTransformMakeRotation(M_PI_4 * l);
    
    cell.noteLabel.text = n.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    cell.dateLable.text = [dateFormatter stringFromDate:n.creationDate];
    
    
    return cell;
}

// BOOK_VIEW_PDF_CLOSE
- (void) bookDidClosePDF :(NSNotification*) notification{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
