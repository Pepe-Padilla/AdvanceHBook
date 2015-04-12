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
    
    self.stack = [AGTCoreDataStack coreDataStackWithModelName:@"Model"];

}

- (NSFetchedResultsController*) fetchForTitles {
    
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
    
    return fc;
}

- (NSFetchedResultsController*) fetchForTags {
    
    if (!self.stack) {
        [self beginStack];
    }
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MXWTag entityName]];
    
    req.sortDescriptors = @[[NSSortDescriptor
                             sortDescriptorWithKey:MXWTagAttributes.tagName
                             ascending:YES
                             selector:@selector(caseInsensitiveCompare:)]];
    req.fetchBatchSize = 20;
    
    // FetchedResultsController
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:self.stack.context
                                      sectionNameKeyPath:MXWTagAttributes.tagName
                                      cacheName:MXWTagRelationships.books];
    
    return fc;
}



#pragma mark - chargeLibrary
- (BOOL) chargeLibrayWithError:(NSError**) error{
    
    // Accedemos a UserDafaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * key = @"firstEntrance";
    
    NSDate*first=[defaults objectForKey:key];
    
    if (!first) {
        // Si no hay nada, lo añadimos
        [defaults setObject:[NSDate date]
                     forKey:key];
        [defaults synchronize];
        
        if (![self rechargeWithError:error]) return NO;
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
    
    if (!self.stack) {
        [self beginStack];
    }
    
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
        
        *error = [NSError errorWithDomain:@"MXWLibray"
                                     code:4030
                                 userInfo:@{@"JSONFormat":@"Error at use JSON: JSON formata incorrect"}];
        
        return NO;
    }
    
    return YES;
}

- (NSString*) getFromRepositoryWithError:(NSError**)error{
    NSURL * urlJ=[NSURL URLWithString:REPO_URL];
    NSError *err= nil;
    NSString * strJson= [NSString stringWithContentsOfURL:urlJ
                                                 encoding:NSUTF8StringEncoding
                                                    error:&err];
    
    if (!strJson) {
        NSLog(@"Error at get from Repository(%@): %@",[urlJ path],err.userInfo);
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
    
    NSURL * coverURL= [[NSURL alloc] initWithString:[[jDictionary objectForKey:@"image_url"]
                                                     stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSURL * pdfURL= [[NSURL alloc] initWithString:[[jDictionary objectForKey:@"pdf_url"]
                                                   stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
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
        if (!aTags) {
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


@end
