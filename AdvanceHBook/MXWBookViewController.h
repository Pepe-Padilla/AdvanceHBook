//
//  MXWBookViewController.h
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/13/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import UIKit;
@class MXWBook;
@class MXWBookViewController;
#import "MXWLibraryViewController.h"
#import "ReaderViewController.h"


@protocol MXWBookViewControllerDelegate <NSObject>

@optional
-(void) bookViewController: (MXWBookViewController *) lVC
                didViewPDF: (MXWBook *) aBook;

-(void) bookViewController: (MXWBookViewController *) lVC
               didClosePDF: (MXWBook *) aBook;

@end


@interface MXWBookViewController : UIViewController <UISplitViewControllerDelegate,MXWLibraryViewControllerDelegate, ReaderViewControllerDelegate>

@property (weak, nonatomic) id<MXWBookViewControllerDelegate> delegate;

@property (strong,nonatomic) MXWBook * book;

@property (weak, nonatomic) IBOutlet UIImageView *imgPrortraid;
@property (weak, nonatomic) IBOutlet UIImageView *imgFinished;
@property (weak, nonatomic) IBOutlet UIButton *buttonFavorite;
@property (weak, nonatomic) IBOutlet UIButton *buttonPDF;
@property (weak, nonatomic) IBOutlet UILabel *lblLastDayAcces;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTags;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthors;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UICollectionView *cvNotes;

- (IBAction)actionFavorite:(id)sender;
- (IBAction)actionPDF:(id)sender;

- (id) initWithModel:(MXWBook *) aBook;

@end
