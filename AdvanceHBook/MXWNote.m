#import "MXWNote.h"

@interface MXWNote ()

// Private interface goes here.

@end

@implementation MXWNote

#pragma mark - special seters and getters
- (UIImage *) noteImg {
    UIImage * img = [UIImage imageWithData:self.image];
    return img;
}

- (void) setNoteImg:(UIImage*) image {
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
    self.image = imgData;
    
}

#pragma mark - instance class method
+(instancetype) noteWithPage: (NSNumber *) aPage
                     context: (NSManagedObjectContext *) context{
    
    MXWNote *n = [self insertInManagedObjectContext:context];
    n.text = @"";
    n.page = aPage;
    n.creationDate = [NSDate date];
    n.modificationDate = [NSDate date];
    //n.addres = @"";
    //n.longitude = 0;
    //n.latitude = 0;
    
    return n;
}

#pragma mark -  Class Methods
+(NSArray *) observableKeys{
    return @[MXWNoteAttributes.text,MXWNoteAttributes.image];
}

#pragma mark - KVO
-(void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    self.modificationDate = [NSDate date];
}


@end
