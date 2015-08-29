//
//  MXWLibraryMng.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/11/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWLibraryMng.h"
#import "MXWBook.h"
#import "MXWAuthor.h"
#import "MXWTag.h"
#import "MXWNote.h"
#import "MXWGender.h"
#import "AGTCoreDataStack.h"
#import "Header.h"


@interface MXWLibraryMng()


@end

@implementation MXWLibraryMng

#pragma mark - manageLibry
- (void) beginStack{
    
    self.stack = [AGTCoreDataStack coreDataStackWithModelName:@"BookModel"];

}

-(NSManagedObjectContext *) contextOfLibrary {
    return self.stack.context;
}

- (NSMutableArray*) fetchBooksfromFetchOfN2NSections: (NSFetchedResultsController *) aFetch {
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    
    NSError * error;
    
    
    if (![aFetch performFetch:&error]) {
        NSLog(@"Error ar fetchBooksfromFetchOfN2NSections:atributeForTitleSections: for Errro: %@",error);
    }
    
    
    NSArray* arrObj=[aFetch fetchedObjects];
    
    for (id obj in arrObj) {
        
        if ([obj isKindOfClass:[MXWTag class]]) {
            MXWTag * aTag = obj;
            
            NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MXWBook entityName]];
            
            req.sortDescriptors = @[[NSSortDescriptor
                                     sortDescriptorWithKey:MXWBookAttributes.title
                                     ascending:YES
                                     selector:@selector(caseInsensitiveCompare:)]];
            req.fetchBatchSize = 20;
            
            req.predicate = [NSPredicate predicateWithFormat:@"ANY tags == %@",aTag];
            
            // FetchedResultsController
            NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                              initWithFetchRequest:req
                                              managedObjectContext:self.stack.context
                                              sectionNameKeyPath:nil
                                              cacheName:nil];
            
            NSMutableDictionary * dTag = [NSMutableDictionary
                                                dictionaryWithDictionary:@{ TITLE_SECTION :  aTag.tagName,
                                                                            SECTION_FRC   :  @"YES",
                                                                            FETCH_RC      :  fc}];
            [arr addObject:dTag];
        } else if ([obj isKindOfClass:[MXWAuthor class]]) {
            
            MXWAuthor * anAuthor = obj;
            
            NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MXWBook entityName]];
            
            req.sortDescriptors = @[[NSSortDescriptor
                                     sortDescriptorWithKey:MXWBookAttributes.title
                                     ascending:YES
                                     selector:@selector(caseInsensitiveCompare:)]];
            req.fetchBatchSize = 20;
            
            req.predicate = [NSPredicate predicateWithFormat:@"ANY authors == %@",anAuthor];
            
            // FetchedResultsController
            NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                              initWithFetchRequest:req
                                              managedObjectContext:self.stack.context
                                              sectionNameKeyPath:nil
                                              cacheName:nil];
            
            NSMutableDictionary * dAuthor = [NSMutableDictionary
                                          dictionaryWithDictionary:@{ TITLE_SECTION :  anAuthor.authorName,
                                                                      SECTION_FRC   :  @"YES",
                                                                      FETCH_RC      :  fc}];
            [arr addObject:dAuthor];
            
        }
        
        
    }
    
    
    return arr;
}

- (NSMutableDictionary*) fetchForTitles {
    
    if (!self.stack) {
        [self beginStack];
    }
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MXWBook entityName]];
    
    req.sortDescriptors = @[[NSSortDescriptor
                             sortDescriptorWithKey:MXWBookAttributes.title
                             ascending:YES
                             selector:@selector(caseInsensitiveCompare:)]];
    req.fetchBatchSize = 20;
    
    // FetchedResultsController
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:self.stack.context
                                      sectionNameKeyPath:nil
                                      cacheName:nil];
    
    NSMutableDictionary * dTitles = [NSMutableDictionary
                                     dictionaryWithDictionary:@{ TITLE_SECTION :  @"Titles",
                                                                 SECTION_FRC   :  @"YES",
                                                                 FETCH_RC      :  fc}];
    
    return dTitles;
}

- (NSMutableDictionary *) fetchForFavorites {
    
    if (!self.stack) {
        [self beginStack];
    }
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MXWBook entityName]];
    
    req.sortDescriptors = @[[NSSortDescriptor
                             sortDescriptorWithKey:MXWBookAttributes.title
                             ascending:YES
                             selector:@selector(caseInsensitiveCompare:)]];
    req.fetchBatchSize = 20;
    
    req.predicate = [NSPredicate predicateWithFormat:@"favorites == %@",[NSNumber numberWithBool:YES]];
    
    // FetchedResultsController
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:self.stack.context
                                      sectionNameKeyPath:nil
                                      cacheName:nil];
    
    NSMutableDictionary * dFavorites = [NSMutableDictionary
                                        dictionaryWithDictionary:@{TITLE_SECTION : @"Favorites",
                                                                   SECTION_FRC : @"YES",
                                                                   FETCH_RC : fc}];
    
    return dFavorites;
}


- (NSMutableArray*) fetchForTags {
    
    if (!self.stack) {
        [self beginStack];
    }
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MXWTag entityName]];
    
    //NSString * sortVal = [NSString stringWithFormat:@"%@.@%@",MXWTagRelationships.books,MXWBookAttributes.title];
    
    //sortedArrayUsingDescriptors
    //caseInsensitiveCompare
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:MXWTagAttributes.tagName
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)]];
    req.fetchBatchSize = 20;
    
    // FetchedResultsController
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:self.stack.context
                                      sectionNameKeyPath:nil
                                      cacheName:nil];
    
    return [self fetchBooksfromFetchOfN2NSections:fc];
}

- (NSMutableArray*) fetchForAuthors {
    
    if (!self.stack) {
        [self beginStack];
    }
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MXWAuthor entityName]];
    
    //NSString * sortVal = [NSString stringWithFormat:@"%@.@%@",MXWTagRelationships.books,MXWBookAttributes.title];
    
    //sortedArrayUsingDescriptors
    //caseInsensitiveCompare
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:MXWAuthorAttributes.authorName
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)]];
    req.fetchBatchSize = 20;
    
    // FetchedResultsController
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:self.stack.context
                                      sectionNameKeyPath:nil
                                      cacheName:nil];
    
    return [self fetchBooksfromFetchOfN2NSections:fc];
}

- (NSMutableDictionary*) fetchForGenders {
    
    if (!self.stack) {
        [self beginStack];
    }
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MXWBook entityName]];
    
    NSString * sortVal = [NSString stringWithFormat:@"%@.%@",MXWBookRelationships.genders,MXWGenderAttributes.genderName];
    
    //sortedArrayUsingDescriptors
    //caseInsensitiveCompare
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortVal
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)],
                            [NSSortDescriptor sortDescriptorWithKey:MXWBookAttributes.title
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)]];
    req.fetchBatchSize = 20;
    
    //req.predicate = [NSPredicate predicateWithFormat:<#(NSString *), ...#>];
    
    // FetchedResultsController
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:self.stack.context
                                      sectionNameKeyPath:sortVal
                                      cacheName:nil];//[MXWBookRelationships.tags stringByAppendingString:@".tagName"]];
    
    NSMutableDictionary * dGenders = [NSMutableDictionary
                                      dictionaryWithDictionary:@{TITLE_SECTION : @"Genders",
                                                                 SECTION_FRC : @"YES",
                                                                 FETCH_RC : fc}];
    
    return dGenders;
}



#pragma mark - chargeLibrary
- (BOOL) chargeLibrayWithError:(NSError**) error{
    
    // Accedemos a UserDafaults
    if (!self.stack) {
        [self beginStack];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * key = @"firstEntrance";
    
    NSDate*first=[defaults objectForKey:key];
    
    if (!first || FORCE_RECHARGE) {
        // Si no hay nada, lo añadimos
        [self.stack zapAllData];
        
        if (![self rechargeWithError:error]) {
            return NO;
        }
        else {
            __block BOOL saved = YES;
            [self.stack saveWithErrorBlock:^(NSError *error) {
                NSLog(@"Error al salvar: %@", error);
                saved = NO;
            }];
            
            
            if (saved) {
                [defaults setObject:[NSDate date]
                             forKey:key];
                [defaults synchronize];
            } else return NO;
            
        }
    }
    
    return YES;
}

-(BOOL) rechargeWithError:(NSError **) error {

    // Actualizamos desde repositorio al menos 1 vez al día de otro modo leemos desde nuestro SandBox
    NSString * jString = nil;
    
    jString = [self getFromRepositoryWithError:error];
    
    if (jString == nil) {
        NSLog(@"Error at repo: %@",*error);
        return NO;
    }
    
    
    // Accedemos a al JSON
    NSData * jsonData = [jString dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonResults = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:0
                                                       error:error];
    
    if (jsonResults == nil) {
        NSLog(@"Error at JSON: %@",*error);
        return NO;
    }
    
    
    // trabajamos con el JSON
    NSMutableDictionary * authorsD = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tagsD = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * genderD = [[NSMutableDictionary alloc] init];
    
    if([jsonResults isKindOfClass:[NSDictionary class]]) {
        
        [self manageBooksWithDictionary: jsonResults
                      authorsDictionary: &authorsD
                         tagsDictionary: &tagsD
                        genderDicionary: &genderD];
        
    } else if([jsonResults isKindOfClass:[NSArray class]]) {
        
        [self manageBooksWithArray: jsonResults
                 authorsDictionary: &authorsD
                    tagsDictionary: &tagsD
                   genderDicionary: &genderD];
        
    } else {
        
        NSLog(@"Error at use JSON: JSON formata incorrect");
        
        if (*error != nil) {
            *error = [NSError errorWithDomain:@"MXWLibray"
                                     code:4030
                                 userInfo:@{@"JSONFormat":@"Error at use JSON: JSON formata incorrect"}];
        }
                
        return NO;
    }
    
    return YES;
}

- (NSString*) getFromRepositoryWithError:(NSError**)error{
    NSString * strJ = [[NSBundle mainBundle] pathForResource:@"advB_readable" ofType:@"json"];
    //NSURL * urlJ=[NSURL URLWithString:REPO_URL];
    NSError *err= nil;
    NSString * strJson= [NSString stringWithContentsOfFile:strJ
                                                 encoding:NSUTF8StringEncoding
                                                    error:&err];
    
    if (!strJson) {
        NSLog(@"Error at get from Repository: %@",err.userInfo);
        *error=err;
    }
    
    return strJson;
}


- (void) manageBooksWithArray:(NSArray*) jArray
            authorsDictionary:(NSMutableDictionary**) authorsD
               tagsDictionary:(NSMutableDictionary**) tagsD
              genderDicionary: (NSMutableDictionary**) genderD{
    for (id object in jArray) {
        [self manageBooksWithDictionary: object
                      authorsDictionary: authorsD
                         tagsDictionary: tagsD
                        genderDicionary: genderD];
    }
}

- (void) manageBooksWithDictionary:(NSDictionary*) jDictionary
                 authorsDictionary:(NSMutableDictionary**) authorsD
                    tagsDictionary:(NSMutableDictionary**) tagsD
                   genderDicionary: (NSMutableDictionary**) genderD{
    
    
    
    NSString * title= [[jDictionary objectForKey:@"title"]
                       stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * authors= [[jDictionary objectForKey:@"authors"]
                         stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * tags= [[jDictionary objectForKey:@"tags"]
                      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * gender = [jDictionary objectForKey:@"gender"];
    
    
    if (!gender) {
        gender = @"No gender";
    } else {
        gender = [gender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    NSURL * coverURL= [[NSURL alloc] initWithString:[jDictionary objectForKey:@"image_url"]];
    NSURL * pdfURL= [[NSURL alloc] initWithString:[jDictionary objectForKey:@"pdf_url"]];
    
    NSArray * aAuthors = [authors componentsSeparatedByString:@", "];
    NSArray * aTags = [tags componentsSeparatedByString:@", "];
    
    NSMutableArray *aa = [[NSMutableArray alloc] init];
    NSMutableArray *at = [[NSMutableArray alloc] init];
    
    for (id strAuthor in aAuthors) {
        MXWAuthor * anAuthor = [*authorsD objectForKey:strAuthor];
        if (!anAuthor) {
            anAuthor = [MXWAuthor authorWithAuthorName:strAuthor
                                               context:self.stack.context];
            [*authorsD addEntriesFromDictionary:@{strAuthor : anAuthor}];
        }
        [aa addObject:anAuthor];
    }
    
    for (id strTag in aTags) {
        MXWTag * aTag = [*tagsD objectForKey:strTag];
        if (!aTag) {
            aTag = [MXWTag tagWithTagName: strTag
                                  context: self.stack.context];
            [*tagsD addEntriesFromDictionary:@{strTag : aTag}];
        }
        [at addObject:aTag];
    }
    
    MXWGender * aGender = [*genderD objectForKey:gender];
    
    if(!aGender){
        aGender = [MXWGender genderWithGenderName:gender
                                          context:self.stack.context];
        [*genderD addEntriesFromDictionary:@{gender : aGender}];
    }
    
    [MXWBook bookWithTitle: title
                    urlPDF: pdfURL
               urlPortraid: coverURL
                      tags: at
                   authors: aa
                    gender: aGender
                   context: self.stack.context];
    
    
}

-(void) autoSave{
    NSLog(@"Autosave");
    
    [self.stack saveWithErrorBlock:^(NSError *error) {
        if (error.code != 1) {
            NSLog(@"Error al salvar: %@", error);
        }
        
    }];
    
    [self performSelector:@selector(autoSave) withObject:nil afterDelay:15];
    
}


@end
