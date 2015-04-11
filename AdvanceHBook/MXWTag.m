#import "MXWTag.h"

@interface MXWTag ()

// Private interface goes here.

@end

@implementation MXWTag

+(instancetype) tagWithTagName: (NSString *) tagName
                       context: (NSManagedObjectContext *) context{
    
    MXWTag *t = [self insertInManagedObjectContext:context];
    
    t.tagName = tagName;
    
    return t;
}

@end
