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


@property (nonatomic, strong) AGTCoreDataStack *stack;

// Array de MXWBooks
@property (strong,nonatomic) NSMutableArray * books;
// Titulos ordenados Alfabeticamente
@property (strong,nonatomic) NSArray * oTitles;

// referencia ordenada a books para no duplicar libros
@property (strong,nonatomic) NSMutableArray * titles;
@property (strong,nonatomic) NSMutableArray * favorites;
@property (strong,nonatomic) NSMutableDictionary * dTags;
@property (strong,nonatomic) NSMutableDictionary * dAuthors;

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



#pragma mark - chargeLibrary
- (BOOL) chargeLibrayWithError:(NSError**) error{
    // Accedemos a UserDafaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * key = @"first entrance";
    
    NSDate*first=[defaults objectForKey:key];
    
    if (!first) {
        // Si no hay nada, lo añadimos
        [defaults setObject:[NSDate date]
                     forKey:key];
        [defaults synchronize];
        
        if (![self rechargeWithError:error]) return NO;
    }
    
    return true;
}

-(BOOL) rechargeWithError:(NSError **) error {

    // Actualizamos desde repositorio al menos 1 vez al día de otro modo leemos desde nuestro SandBox
    NSString * jString = nil;
    
    jString = [self getFromRepositoryWithError:error];
        
    
    
    // Accedemos a al JSON
    NSData * jsonData = [jString dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonResults = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:0
                                                       error:error];
    
    if (!jsonResults) {
        NSLog(@"Error at JSON: %@",*error);
        return NO;
    }
    
    
    // trabajamos con el JSON
    if([jsonResults isKindOfClass:[NSDictionary class]]) {
        
        [self manageBooksWithDictionary:jsonResults];
        
    } else if([jsonResults isKindOfClass:[NSArray class]]) {
        
        [self manageBooksWithArray:jsonResults];
        
        
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


- (void) manageBooksWithArray:(NSArray*) jArray {
    for (id object in jArray) {
        [self manageBooksWithDictionary:object];
    }
}

- (void) manageBooksWithDictionary:(NSDictionary*) jDictionary {
    NSString * title= [[jDictionary objectForKey:@"title"]
                       stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * authors= [[jDictionary objectForKey:@"authors"]
                         stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * tags= [[jDictionary objectForKey:@"tags"]
                      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * gender = [[jDictionary objectForKey:@"gender"]
                         stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!gender) {
        gender = @"No gender";
    }
    
    NSURL * coverURL= [[NSURL alloc] initWithString:[[jDictionary objectForKey:@"image_url"]
                                                     stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSURL * pdfURL= [[NSURL alloc] initWithString:[[jDictionary objectForKey:@"pdf_url"]
                                                   stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    
    NSArray * aAuthors = [authors componentsSeparatedByString:@", "];
    NSArray * aTags = [tags componentsSeparatedByString:@", "];
    
    
    MXWBook * book = [MXWBook bookWithTitle: title
                                     urlPDF: pdfURL
                                urlPortraid: coverURL
                                       tags:<#(NSArray *)#>
                                    authors:<#(NSArray *)#>
                                     gender:<#(MXWGender *)#>
                                    context:<#(NSManagedObjectContext *)#>]];
    
    
}


@end
