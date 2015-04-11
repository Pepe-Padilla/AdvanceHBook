// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MXWBook.h instead.

@import CoreData;
#import "MXWBaseManagedObject.h"

extern const struct MXWBookAttributes {
	__unsafe_unretained NSString *extURLPDF;
	__unsafe_unretained NSString *extURLPortraid;
	__unsafe_unretained NSString *favorites;
	__unsafe_unretained NSString *finished;
	__unsafe_unretained NSString *lastDayAcces;
	__unsafe_unretained NSString *lastPage;
	__unsafe_unretained NSString *pdfData;
	__unsafe_unretained NSString *portraid;
	__unsafe_unretained NSString *title;
} MXWBookAttributes;

extern const struct MXWBookRelationships {
	__unsafe_unretained NSString *authors;
	__unsafe_unretained NSString *genders;
	__unsafe_unretained NSString *notes;
	__unsafe_unretained NSString *tags;
} MXWBookRelationships;

@class MXWAuthor;
@class MXWGender;
@class MXWNote;
@class MXWTag;

@interface MXWBookID : NSManagedObjectID {}
@end

@interface _MXWBook : MXWBaseManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MXWBookID* objectID;

@property (nonatomic, strong) NSString* extURLPDF;

//- (BOOL)validateExtURLPDF:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* extURLPortraid;

//- (BOOL)validateExtURLPortraid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* favorites;

@property (atomic) BOOL favoritesValue;
- (BOOL)favoritesValue;
- (void)setFavoritesValue:(BOOL)value_;

//- (BOOL)validateFavorites:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* finished;

@property (atomic) BOOL finishedValue;
- (BOOL)finishedValue;
- (void)setFinishedValue:(BOOL)value_;

//- (BOOL)validateFinished:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* lastDayAcces;

//- (BOOL)validateLastDayAcces:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* lastPage;

@property (atomic) int16_t lastPageValue;
- (int16_t)lastPageValue;
- (void)setLastPageValue:(int16_t)value_;

//- (BOOL)validateLastPage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* pdfData;

//- (BOOL)validatePdfData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* portraid;

//- (BOOL)validatePortraid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *authors;

- (NSMutableSet*)authorsSet;

@property (nonatomic, strong) MXWGender *genders;

//- (BOOL)validateGenders:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *notes;

- (NSMutableSet*)notesSet;

@property (nonatomic, strong) NSSet *tags;

- (NSMutableSet*)tagsSet;

@end

@interface _MXWBook (AuthorsCoreDataGeneratedAccessors)
- (void)addAuthors:(NSSet*)value_;
- (void)removeAuthors:(NSSet*)value_;
- (void)addAuthorsObject:(MXWAuthor*)value_;
- (void)removeAuthorsObject:(MXWAuthor*)value_;

@end

@interface _MXWBook (NotesCoreDataGeneratedAccessors)
- (void)addNotes:(NSSet*)value_;
- (void)removeNotes:(NSSet*)value_;
- (void)addNotesObject:(MXWNote*)value_;
- (void)removeNotesObject:(MXWNote*)value_;

@end

@interface _MXWBook (TagsCoreDataGeneratedAccessors)
- (void)addTags:(NSSet*)value_;
- (void)removeTags:(NSSet*)value_;
- (void)addTagsObject:(MXWTag*)value_;
- (void)removeTagsObject:(MXWTag*)value_;

@end

@interface _MXWBook (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveExtURLPDF;
- (void)setPrimitiveExtURLPDF:(NSString*)value;

- (NSString*)primitiveExtURLPortraid;
- (void)setPrimitiveExtURLPortraid:(NSString*)value;

- (NSNumber*)primitiveFavorites;
- (void)setPrimitiveFavorites:(NSNumber*)value;

- (BOOL)primitiveFavoritesValue;
- (void)setPrimitiveFavoritesValue:(BOOL)value_;

- (NSNumber*)primitiveFinished;
- (void)setPrimitiveFinished:(NSNumber*)value;

- (BOOL)primitiveFinishedValue;
- (void)setPrimitiveFinishedValue:(BOOL)value_;

- (NSDate*)primitiveLastDayAcces;
- (void)setPrimitiveLastDayAcces:(NSDate*)value;

- (NSNumber*)primitiveLastPage;
- (void)setPrimitiveLastPage:(NSNumber*)value;

- (int16_t)primitiveLastPageValue;
- (void)setPrimitiveLastPageValue:(int16_t)value_;

- (NSData*)primitivePdfData;
- (void)setPrimitivePdfData:(NSData*)value;

- (NSData*)primitivePortraid;
- (void)setPrimitivePortraid:(NSData*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSMutableSet*)primitiveAuthors;
- (void)setPrimitiveAuthors:(NSMutableSet*)value;

- (MXWGender*)primitiveGenders;
- (void)setPrimitiveGenders:(MXWGender*)value;

- (NSMutableSet*)primitiveNotes;
- (void)setPrimitiveNotes:(NSMutableSet*)value;

- (NSMutableSet*)primitiveTags;
- (void)setPrimitiveTags:(NSMutableSet*)value;

@end
