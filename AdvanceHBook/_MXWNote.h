// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MXWNote.h instead.

@import CoreData;
#import "MXWBaseManagedObject.h"

extern const struct MXWNoteAttributes {
	__unsafe_unretained NSString *addres;
	__unsafe_unretained NSString *creationDate;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *modificationDate;
	__unsafe_unretained NSString *page;
	__unsafe_unretained NSString *text;
} MXWNoteAttributes;

extern const struct MXWNoteRelationships {
	__unsafe_unretained NSString *books;
} MXWNoteRelationships;

@class MXWBook;

@interface MXWNoteID : NSManagedObjectID {}
@end

@interface _MXWNote : MXWBaseManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MXWNoteID* objectID;

@property (nonatomic, strong) NSString* addres;

//- (BOOL)validateAddres:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* creationDate;

//- (BOOL)validateCreationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitude;

@property (atomic) double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* modificationDate;

//- (BOOL)validateModificationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* page;

@property (atomic) int16_t pageValue;
- (int16_t)pageValue;
- (void)setPageValue:(int16_t)value_;

//- (BOOL)validatePage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *books;

- (NSMutableSet*)booksSet;

@end

@interface _MXWNote (BooksCoreDataGeneratedAccessors)
- (void)addBooks:(NSSet*)value_;
- (void)removeBooks:(NSSet*)value_;
- (void)addBooksObject:(MXWBook*)value_;
- (void)removeBooksObject:(MXWBook*)value_;

@end

@interface _MXWNote (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAddres;
- (void)setPrimitiveAddres:(NSString*)value;

- (NSDate*)primitiveCreationDate;
- (void)setPrimitiveCreationDate:(NSDate*)value;

- (NSData*)primitiveImage;
- (void)setPrimitiveImage:(NSData*)value;

- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (NSDate*)primitiveModificationDate;
- (void)setPrimitiveModificationDate:(NSDate*)value;

- (NSNumber*)primitivePage;
- (void)setPrimitivePage:(NSNumber*)value;

- (int16_t)primitivePageValue;
- (void)setPrimitivePageValue:(int16_t)value_;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (NSMutableSet*)primitiveBooks;
- (void)setPrimitiveBooks:(NSMutableSet*)value;

@end
