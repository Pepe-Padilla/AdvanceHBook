//
//  MXWLibraryViewController.h
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/12/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWCoreDataTableViewController.h"
#import "MXWBook.h"
//#import "MXWBookViewController.h"
@class MXWLibraryViewController;

@protocol MXWLibraryViewControllerDelegate <NSObject>

@optional
-(void) libraryTableViewController: (MXWLibraryViewController *) lVC
                     didSelectBook: (MXWBook *) aBook;

-(MXWBook *) libraryTableViewControllerPDFActive: (MXWLibraryViewController *) lVC;


@end


@interface MXWLibraryViewController : MXWCoreDataTableViewController

@property (weak, nonatomic) id<MXWLibraryViewControllerDelegate> delegate;

- (void) manageStart;
- (NSManagedObjectContext*) librayContext;

@end
