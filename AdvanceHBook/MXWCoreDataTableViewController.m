//
//  MXWCoreDataTableViewController.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/12/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWCoreDataTableViewController.h"
#import "Header.h"



@interface MXWCoreDataTableViewController()

@property (nonatomic) BOOL beganUpdates;
@property (strong, nonatomic) NSMutableArray * aTitle;
@property (strong, nonatomic) NSMutableArray * arrayTable;

@end

@implementation MXWCoreDataTableViewController


-(id) initWithArray: (NSMutableArray *) arrayOfFetchC
              style: (UITableViewStyle) aStyle{
    if (self = [super initWithStyle:aStyle]) {
        _arrayTable = arrayOfFetchC;
        _aTitle = [[NSMutableArray alloc] init];
        //_debug = YES;
    }
    
    return self;
    
}

/*-(id) initWithFetchedResultsController: (NSFetchedResultsController *) aFetchedResultsController
                                 style: (UITableViewStyle) aStyle{
    
    if (self = [super initWithStyle:aStyle]) {
        self.fetchedResultsController = aFetchedResultsController;
    }
    return self;
}*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Fetching

- (void)performFetch {
    
    [self.arrayTable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary * dictionary = obj;
        
        NSString * sectionRFC = [dictionary objectForKey:SECTION_FRC];
        
        if([sectionRFC isEqualToString:@"YES"]){
            NSFetchedResultsController * fetchedResultsController = [dictionary objectForKey:FETCH_RC];
            
            if (fetchedResultsController) {
                if (fetchedResultsController.fetchRequest.predicate) {
                    if (self.debug)
                        NSLog(@"[%@ %@] fetching %@ with predicate: %@",
                              NSStringFromClass([self class]),
                              NSStringFromSelector(_cmd),
                              fetchedResultsController.fetchRequest.entityName,
                              fetchedResultsController.fetchRequest.predicate);
                } else {
                    if (self.debug)
                        NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)",
                              NSStringFromClass([self class]),
                              NSStringFromSelector(_cmd),
                              fetchedResultsController.fetchRequest.entityName);
                }
                NSError *error;
                [fetchedResultsController performFetch:&error];
                if (error)
                    NSLog(@"[%@ %@] %@ (%@)",
                          NSStringFromClass([self class]),
                          NSStringFromSelector(_cmd),
                          [error localizedDescription],
                          [error localizedFailureReason]);
            
                fetchedResultsController.delegate = self;
                [dictionary setObject:fetchedResultsController forKey:FETCH_RC];
                [self.arrayTable setObject:dictionary atIndexedSubscript:idx];

            } else {
                if (self.debug)
                    NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)",
                          NSStringFromClass([self class]),
                          NSStringFromSelector(_cmd));
            }
            
        }
        
    }];
    [self.tableView reloadData];
}

- (void)setFetchedArray:(NSMutableArray *)newAfrc {
    
    [self.arrayTable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary * dictionary = obj;
        
        NSString * sectionRFC = [dictionary objectForKey:SECTION_FRC];
        
        
        if([sectionRFC isEqualToString:@"YES"]){
            NSFetchedResultsController * fetchedResultsController = [dictionary objectForKey:FETCH_RC];
            if(fetchedResultsController){
                fetchedResultsController.delegate = nil;
            }
        }
    }];
    
    self.arrayTable = newAfrc;
    [self performFetch];

}


- (NSIndexPath *) transformIndexPathWithController: (NSFetchedResultsController *)controller
                                       atIndexPath: (NSIndexPath *) indexPath{
    
    __block NSInteger section = indexPath.section;
    
    __block NSInteger anInt = 0;
    
    [self.arrayTable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary * dictionary = obj;
        
        NSString * sectionRFC = [dictionary objectForKey:SECTION_FRC];
        
        if([sectionRFC isEqualToString:@"YES"]){
            
            NSFetchedResultsController * fetchedResultsController = [dictionary objectForKey:FETCH_RC];
            
            NSInteger sectionInt =[[fetchedResultsController sections] count];
            if (sectionInt == 0) {
                sectionInt = 1;
            }
            NSInteger anInt2 = anInt + sectionInt;
            
            if([controller isEqual:fetchedResultsController]){
                section = (section + anInt);
                *stop = YES;
            } else {
                anInt = anInt2;
            }
            
        } else {
            anInt++;
        }
    }];
    
    return [NSIndexPath indexPathForRow:indexPath.row
                              inSection:section];
    
    
}

- (NSInteger) transformSectionWithController:(NSFetchedResultsController *)controller
                              atIndexSection:(NSUInteger)sectionIndex {
    
    //NSLog(@"indexpagth section-row at fetchObjectAtIndexPath: %d - %d",indexPath.section, indexPath.row);
    
    __block NSInteger section = sectionIndex;
    
    __block NSInteger anInt = 0;
    
    [self.arrayTable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary * dictionary = obj;
        
        NSString * sectionRFC = [dictionary objectForKey:SECTION_FRC];
        
        if([sectionRFC isEqualToString:@"YES"]){
            
            NSFetchedResultsController * fetchedResultsController = [dictionary objectForKey:FETCH_RC];
            
            NSInteger sectionInt =[[fetchedResultsController sections] count];
            if (sectionInt == 0) {
                sectionInt = 1;
            }
            NSInteger anInt2 = anInt + sectionInt;
            
            if([controller isEqual:fetchedResultsController]){
                section = (section + anInt);
                *stop = YES;
            } else {
                anInt = anInt2;
            }
            
        } else {
            anInt++;
        }
    }];
    
    return section;
}

-(id) fetchedObjectAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"indexpagth section-row at fetchObjectAtIndexPath: %d - %d",indexPath.section, indexPath.row);
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    __block id objToReturn = indexPath;
    __block NSInteger anInt = 0;
    
    [self.arrayTable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary * dictionary = obj;
        
        NSString * sectionRFC = [dictionary objectForKey:SECTION_FRC];
        
        if([sectionRFC isEqualToString:@"YES"]){
            
            NSFetchedResultsController * fetchedResultsController = [dictionary objectForKey:FETCH_RC];
            
            NSInteger sectionInt =[[fetchedResultsController sections] count];
            if (sectionInt == 0) {
                sectionInt = 1;
            }
            NSInteger anInt2 = anInt + sectionInt;
            
            if(section < anInt2){
                NSIndexPath * internalIP = [NSIndexPath indexPathForRow:row inSection:(section - anInt)];
                objToReturn = [fetchedResultsController objectAtIndexPath:internalIP];
                *stop = YES;
            } else {
                anInt = anInt2;
            }
            
        } else {
            if(section == anInt){
                objToReturn = obj;
                *stop = YES;
            } else {
                anInt++;
            }
        }
    }];
    
    
    return objToReturn;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    __block NSInteger anInt = 0;
    
    [self.arrayTable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary * dictionary = obj;
        
        NSString * sectionRFC = [dictionary objectForKey:SECTION_FRC];
        
        if([sectionRFC isEqualToString:@"YES"]){
            NSFetchedResultsController * fetchedResultsController = [dictionary objectForKey:FETCH_RC];
        
            NSInteger sectionInt =[[fetchedResultsController sections] count];
            if (sectionInt == 0) {
                sectionInt = 1;
            }
            anInt = anInt + sectionInt;
        } else anInt++;
    }];
    
    return anInt;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    __block NSInteger anInt = 0;
    
    [self.arrayTable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary * dictionary = obj;
        
        NSString * sectionRFC = [dictionary objectForKey:SECTION_FRC];
        
        if([sectionRFC isEqualToString:@"YES"]){
            NSFetchedResultsController * fetchedResultsController = [dictionary objectForKey:FETCH_RC];
        
            NSInteger sectionInt =[[fetchedResultsController sections] count];
            if (sectionInt == 0) {
                sectionInt = 1;
            }
            NSInteger anInt2 = anInt + sectionInt;
            
            if(section < anInt2){
                anInt = [[[fetchedResultsController sections] objectAtIndex:(section - anInt)] numberOfObjects];
                //anInt = [[[fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
                *stop = YES;
            } else {
                anInt = anInt2;
            }
            
        } else {
            if(section == anInt){
                NSString * intres = [dictionary objectForKey:NOFRC_COUNT];
                anInt = [intres integerValue];
                *stop = YES;
            } else {
                anInt++;
            }
        }
    }];
    
    return anInt;
    
    //return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    __block NSInteger anInt = 0;
    __block NSString * aString = @"";
    
    
    [self.arrayTable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary * dictionary = obj;
        
        NSString * sectionRFC = [dictionary objectForKey:SECTION_FRC];
        
        if([sectionRFC isEqualToString:@"YES"]){
            NSFetchedResultsController * fetchedResultsController = [dictionary objectForKey:FETCH_RC];
        
            NSInteger sectionInt =[[fetchedResultsController sections] count];
            if (sectionInt == 0) {
                sectionInt = 1;
            }
            NSInteger anInt2 = anInt + sectionInt;
            
            if(section < anInt2){
                aString = [[[fetchedResultsController sections] objectAtIndex:(section - anInt)] name];
                if ([aString isEqualToString:@""] || aString == nil) {
                    aString = [dictionary objectForKey:TITLE_SECTION];
                }
                if ( [self.aTitle count] <= section ) {
                    for (NSInteger i = [self.aTitle count]; i <= section; i++) {
                        [self.aTitle insertObject:@"" atIndex:i];
                    }
                }
                [self.aTitle replaceObjectAtIndex:section withObject:aString];
                *stop = YES;
            } else {
                anInt = anInt2;
            }
            
        } else {
            if(section == anInt){
                aString = [dictionary objectForKey:TITLE_SECTION];
                if ( [self.aTitle count] < section ) {
                    for (NSInteger i = [self.aTitle count] -1; i <= section; i++) {
                        [self.aTitle insertObject:@"" atIndex:i];
                    }
                }
                [self.aTitle replaceObjectAtIndex:section withObject:aString];
                *stop = YES;
            } else {
                anInt++;
            }
        }
    }];
    
    return aString;
    //return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 0;
    //return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[]; //self.aTitle;
    //return [self.fetchedResultsController sectionIndexTitles];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.tableView beginUpdates];
        self.beganUpdates = YES;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        
        NSInteger newSectionIndex = [self transformSectionWithController: controller
                                                          atIndexSection: sectionIndex]; //rev
        
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newSectionIndex]
                              withRowAnimation:UITableViewRowAnimationFade];
                //[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                //[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:newSectionIndex]
                              withRowAnimation:UITableViewRowAnimationFade];
                break;
            default:
                // other 2 changes are irrelevant in this case
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        
        NSIndexPath * anOldIndexPath = [self transformIndexPathWithController: controller
                                                                  atIndexPath: indexPath]; //rev
        
        NSIndexPath * aNewIndexPath = [self transformIndexPathWithController: controller
                                                                 atIndexPath: newIndexPath]; //rev
        
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                //                      withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:aNewIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                //                      withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:anOldIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                //                      withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:anOldIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                //                      withRowAnimation:UITableViewRowAnimationFade];
                //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                //                      withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:anOldIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:aNewIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (self.beganUpdates) [self.tableView endUpdates];
}

- (void)endSuspensionOfUpdatesDueToContextChanges {
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

@end

