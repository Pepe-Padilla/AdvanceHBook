#import "_MXWGender.h"

@interface MXWGender : _MXWGender {}

+(instancetype) genderWithGenderName: (NSString *) genderName
                             context: (NSManagedObjectContext *) context;

@end
