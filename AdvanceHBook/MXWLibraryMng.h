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
@class MXWBook;

@interface MXWLibraryMng : NSObject

@property (nonatomic, strong) AGTCoreDataStack *stack;

- (void) beginStack;
- (BOOL) chargeLibrayWithError:(NSError**) error;
- (NSMutableDictionary*) fetchForTitles;
- (NSMutableDictionary*) fetchForGenders;
- (NSMutableDictionary*) fetchForFavorites;
- (NSMutableArray*) fetchForTags;
- (NSMutableArray*) fetchForAuthors;
- (void) autoSave;

-(NSManagedObjectContext *) contextOfLibrary;

@end
