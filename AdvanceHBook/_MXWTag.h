// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MXWTag.h instead.

@import CoreData;
#import "MXWBaseManagedObject.h"

extern const struct MXWTagAttributes {
	__unsafe_unretained NSString *tagName;
} MXWTagAttributes;

extern const struct MXWTagRelationships {
	__unsafe_unretained NSString *books;
} MXWTagRelationships;

@class MXWBook;

@interface MXWTagID : NSManagedObjectID {}
@end

@interface _MXWTag : MXWBaseManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MXWTagID* objectID;

@property (nonatomic, strong) NSString* tagName;

//- (BOOL)validateTagName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *books;

- (NSMutableSet*)booksSet;

@end

@interface _MXWTag (BooksCoreDataGeneratedAccessors)
- (void)addBooks:(NSSet*)value_;
- (void)removeBooks:(NSSet*)value_;
- (void)addBooksObject:(MXWBook*)value_;
- (void)removeBooksObject:(MXWBook*)value_;

@end

@interface _MXWTag (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveTagName;
- (void)setPrimitiveTagName:(NSString*)value;

- (NSMutableSet*)primitiveBooks;
- (void)setPrimitiveBooks:(NSMutableSet*)value;

@end
