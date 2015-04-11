#import "_MXWNote.h"
@import UIKit;

@interface MXWNote : _MXWNote {}

@property (nonatomic, strong) UIImage * noteImg;

+(instancetype) noteWithPage: (NSNumber*) aPage
                     context: (NSManagedObjectContext*) context;

@end
