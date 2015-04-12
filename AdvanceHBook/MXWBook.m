#import "MXWBook.h"
#import "MXWTag.h"
#import "MXWAuthor.h"
#import "MXWGender.h"

@interface MXWBook ()

// Private interface goes here.

@end

@implementation MXWBook

#pragma mark - special seters and getters
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
    n.lastPage = 0;
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
    
    
    // nos vamos a 2º plano a descargar la imagen
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        
        if (!img) {
            NSLog(@"image not found: %@",[url absoluteString]);
        }
        
        // cuando la tengo, me voy a primer plano
        // llamo al completionBlock
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
