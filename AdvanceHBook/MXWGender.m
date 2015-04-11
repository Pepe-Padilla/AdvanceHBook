#import "MXWGender.h"

@interface MXWGender ()

// Private interface goes here.

@end

@implementation MXWGender

+(instancetype) genderWithGenderName: (NSString *) genderName
                             context: (NSManagedObjectContext *) context{
    
    MXWGender *g = [self insertInManagedObjectContext:context];
    
    g.genderName = genderName;
    
    return g;
}

@end
