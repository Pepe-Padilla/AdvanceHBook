// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MXWAuthor.h instead.

@import CoreData;
#import "MXWBaseManagedObject.h"

extern const struct MXWAuthorAttributes {
	__unsafe_unretained NSString *authorName;
} MXWAuthorAttributes;

extern const struct MXWAuthorRelationships {
	__unsafe_unretained NSString *books;
} MXWAuthorRelationships;

@class MXWBook;

@interface MXWAuthorID : NSManagedObjectID {}
@end

@interface _MXWAuthor : MXWBaseManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MXWAuthorID* objectID;

@property (nonatomic, strong) NSString* authorName;

//- (BOOL)validateAuthorName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *books;

- (NSMutableSet*)booksSet;

@end

@interface _MXWAuthor (BooksCoreDataGeneratedAccessors)
- (void)addBooks:(NSSet*)value_;
- (void)removeBooks:(NSSet*)value_;
- (void)addBooksObject:(MXWBook*)value_;
- (void)removeBooksObject:(MXWBook*)value_;

@end

@interface _MXWAuthor (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAuthorName;
- (void)setPrimitiveAuthorName:(NSString*)value;

- (NSMutableSet*)primitiveBooks;
- (void)setPrimitiveBooks:(NSMutableSet*)value;

@end
