#import "MXWBook.h"
#import "MXWTag.h"
#import "MXWAuthor.h"
#import "MXWGender.h"
#import "MXWNote.h"
@import CoreData;

@interface MXWBook ()

// Private interface goes here.

@end

@implementation MXWBook


#pragma mark - dafault manager
+(instancetype) objectWithArchivedURIRepresentation:(NSData*)archivedURI
                                            context:(NSManagedObjectContext *) context{
    
    NSURL *uri = [NSKeyedUnarchiver unarchiveObjectWithData:archivedURI];
    if (uri == nil) {
        return nil;
    }
    
    
    NSManagedObjectID *nid = [context.persistentStoreCoordinator
                              managedObjectIDForURIRepresentation:uri];
    if (nid == nil) {
        return nil;
    }
    
    
    NSManagedObject *ob = [context objectWithID:nid];
    if (ob.isFault) {
        // Got it!
        return (MXWBook*)ob;
    }else{
        // Might not exist anymore. Let's fetch it!
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:ob.entity.name];
        req.predicate = [NSPredicate predicateWithFormat:@"SELF = %@", ob];
        
        NSError *error;
        NSArray *res = [context executeFetchRequest:req
                                              error:&error];
        if (res == nil) {
            return nil;
        }else{
            return [res lastObject];
        }
    }
    
    
}

-(NSData*) archiveURIRepresentation{
    
    NSURL *uri = self.objectID.URIRepresentation;
    return [NSKeyedArchiver archivedDataWithRootObject:uri];
    
}

#pragma mark - fetchs

- (NSFetchedResultsController*) fetchForNotes {
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MXWNote entityName]];
    
    //sortedArrayUsingDescriptors
    //caseInsensitiveCompare
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:MXWNoteAttributes.page
                                                          ascending:YES],
                            [NSSortDescriptor sortDescriptorWithKey:MXWNoteAttributes.creationDate
                                                          ascending:YES]];
    req.fetchBatchSize = 20;
    
    req.predicate = [NSPredicate predicateWithFormat:@"ANY %K == %@",MXWNoteRelationships.books, self];
    
    // FetchedResultsController
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:self.managedObjectContext
                                      sectionNameKeyPath:MXWNoteAttributes.page
                                      cacheName:nil];//[MXWBookRelationships.tags stringByAppendingString:@".tagName"]];
    
    return fc;
}

#pragma mark - special seters and getters
- (void) downloadPDFwithCompletionBlock: (void (^)(bool downloaded))completionBlock {
    
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        
        BOOL done = NO;
        
        
        if(self.pdfData == nil) {
            NSData* pdf = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.extURLPDF]];
            
            if (pdf != nil) {
                self.pdfData = pdf;
                done = YES;
            }
            
        } else done = YES;

        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(done);
        });
    });
}

- (UIImage *) portraidImg {
    
    UIImage * img = nil;
    
    if (!self.portraid) {
        
        img = [UIImage imageNamed:@"Book_placeholder.png"];
        [self withImageURL: [NSURL URLWithString:self.extURLPortraid]
           completionBlock: ^(UIImage *image) {
               
               if (image) {
                   [self setPortraidImg:image];
               }
               
           }];
        
    } else {
        
        img = [UIImage imageWithData:self.portraid];
        
    }
    
    return img;
    
}

- (void) setPortraidImg:(UIImage*) image {
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
    self.portraid = imgData;
    
}


#pragma mark - Class Methods
+(instancetype) bookWithTitle: (NSString *) atitle
                       urlPDF: (NSURL*) aExtURLPDF
                  urlPortraid: (NSURL*) aExtURLPortraid
                         tags: (NSArray*) tags
                      authors: (NSArray*) authors
                       gender: (MXWGender*) gender
                      context: (NSManagedObjectContext *) context{
    
    MXWBook *n = [self insertInManagedObjectContext:context];
    
    n.title = atitle;
    //portraid
    //pdfData
    n.favorites = [NSNumber numberWithBool:NO];
    n.finished = [NSNumber numberWithBool:NO];
    //lastDayAcces
    n.lastPage = [NSNumber numberWithInt:1];
    n.extURLPDF = [aExtURLPDF absoluteString];
    n.extURLPortraid = [aExtURLPortraid absoluteString];
    
    //tags
    [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MXWTag * aTag = obj;
        [n addTagsObject:aTag];
    }];
    
    //authors
    [authors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MXWAuthor * anAuthor = obj;
        [n addAuthorsObject:anAuthor];
    }];
    
    //gender
    [n setGenders:gender];
    
    return n;
}


-(void)withImageURL: (NSURL *) url
    completionBlock: (void (^)(UIImage*image))completionBlock{
    
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        
        if (!img) {
            NSLog(@"image not found: %@",[url absoluteString]);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(img);
        });
    });
    
    
}

#pragma mark - KVO
-(void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    
}

@end
