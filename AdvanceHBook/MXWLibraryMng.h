//
//  MXWLibraryMng.h
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/11/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreData;
@class AGTCoreDataStack;

@interface MXWLibraryMng : NSObject

@property (nonatomic, strong) AGTCoreDataStack *stack;

- (void) beginStack;
- (BOOL) chargeLibrayWithError:(NSError**) error;
- (NSFetchedResultsController*) fetchForTitles;
- (NSFetchedResultsController*) fetchForTags;
- (NSFetchedResultsController*) fetchForGenders;
- (NSFetchedResultsController*) fetchForFavorites;
- (void) autoSave;

@end
