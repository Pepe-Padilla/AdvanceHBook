#import "_MXWBook.h"
@import UIKit;
@class MXWGender;

@interface MXWBook : _MXWBook {}

@property (nonatomic, strong) UIImage * portraidImg;

+(instancetype) bookWithTitle: (NSString *) atitle
                       urlPDF: (NSURL*) aExtURLPDF
                  urlPortraid: (NSURL*) aExtURLPortraid
                         tags: (NSArray*) tags
                      authors: (NSArray*) authors
                       gender: (MXWGender*) gender
                      context: (NSManagedObjectContext *) context;

- (void) downloadPDFwithCompletionBlock: (void (^)(bool downloaded))completionBlock;

@end
