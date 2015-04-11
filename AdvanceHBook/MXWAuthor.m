#import "MXWAuthor.h"

@interface MXWAuthor ()

// Private interface goes here.

@end

@implementation MXWAuthor

+(instancetype) authorWithAuthorName: (NSString *) authorName
                             context: (NSManagedObjectContext *) context{
    
    MXWAuthor *a = [self insertInManagedObjectContext:context];
    
    a.authorName = authorName;
    
    return a;
}

@end
