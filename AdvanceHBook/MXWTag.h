#import "_MXWTag.h"

@interface MXWTag : _MXWTag {}

+(instancetype) tagWithTagName: (NSString *) tagName
                       context: (NSManagedObjectContext *) context;

@end
