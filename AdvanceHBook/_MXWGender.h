// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MXWGender.h instead.

@import CoreData;
#import "MXWBaseManagedObject.h"

extern const struct MXWGenderAttributes {
	__unsafe_unretained NSString *genderName;
} MXWGenderAttributes;

extern const struct MXWGenderRelationships {
	__unsafe_unretained NSString *books;
} MXWGenderRelationships;

@class MXWBook;

@interface MXWGenderID : NSManagedObjectID {}
@end

@interface _MXWGender : MXWBaseManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MXWGenderID* objectID;

@property (nonatomic, strong) NSString* genderName;

//- (BOOL)validateGenderName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *books;

- (NSMutableSet*)booksSet;

@end

@interface _MXWGender (BooksCoreDataGeneratedAccessors)
- (void)addBooks:(NSSet*)value_;
- (void)removeBooks:(NSSet*)value_;
- (void)addBooksObject:(MXWBook*)value_;
- (void)removeBooksObject:(MXWBook*)value_;

@end

@interface _MXWGender (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveGenderName;
- (void)setPrimitiveGenderName:(NSString*)value;

- (NSMutableSet*)primitiveBooks;
- (void)setPrimitiveBooks:(NSMutableSet*)value;

@end
