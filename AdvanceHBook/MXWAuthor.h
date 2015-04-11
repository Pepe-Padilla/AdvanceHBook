#import "_MXWAuthor.h"

@interface MXWAuthor : _MXWAuthor {}

+(instancetype) authorWithAuthorName: (NSString *) authorName
                             context: (NSManagedObjectContext *) context;

@end
