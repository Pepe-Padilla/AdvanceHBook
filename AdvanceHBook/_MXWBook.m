// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MXWBook.m instead.

#import "_MXWBook.h"

const struct MXWBookAttributes MXWBookAttributes = {
	.extURLPDF = @"extURLPDF",
	.extURLPortraid = @"extURLPortraid",
	.favorites = @"favorites",
	.finished = @"finished",
	.lastDayAcces = @"lastDayAcces",
	.lastPage = @"lastPage",
	.pdfData = @"pdfData",
	.portraid = @"portraid",
	.title = @"title",
};

const struct MXWBookRelationships MXWBookRelationships = {
	.authors = @"authors",
	.genders = @"genders",
	.notes = @"notes",
	.tags = @"tags",
};

@implementation MXWBookID
@end

@implementation _MXWBook

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Book";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Book" inManagedObjectContext:moc_];
}

- (MXWBookID*)objectID {
	return (MXWBookID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"favoritesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favorites"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"finishedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"finished"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lastPageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lastPage"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic extURLPDF;

@dynamic extURLPortraid;

@dynamic favorites;

- (BOOL)favoritesValue {
	NSNumber *result = [self favorites];
	return [result boolValue];
}

- (void)setFavoritesValue:(BOOL)value_ {
	[self setFavorites:@(value_)];
}

- (BOOL)primitiveFavoritesValue {
	NSNumber *result = [self primitiveFavorites];
	return [result boolValue];
}

- (void)setPrimitiveFavoritesValue:(BOOL)value_ {
	[self setPrimitiveFavorites:@(value_)];
}

@dynamic finished;

- (BOOL)finishedValue {
	NSNumber *result = [self finished];
	return [result boolValue];
}

- (void)setFinishedValue:(BOOL)value_ {
	[self setFinished:@(value_)];
}

- (BOOL)primitiveFinishedValue {
	NSNumber *result = [self primitiveFinished];
	return [result boolValue];
}

- (void)setPrimitiveFinishedValue:(BOOL)value_ {
	[self setPrimitiveFinished:@(value_)];
}

@dynamic lastDayAcces;

@dynamic lastPage;

- (int32_t)lastPageValue {
	NSNumber *result = [self lastPage];
	return [result intValue];
}

- (void)setLastPageValue:(int32_t)value_ {
	[self setLastPage:@(value_)];
}

- (int32_t)primitiveLastPageValue {
	NSNumber *result = [self primitiveLastPage];
	return [result intValue];
}

- (void)setPrimitiveLastPageValue:(int32_t)value_ {
	[self setPrimitiveLastPage:@(value_)];
}

@dynamic pdfData;

@dynamic portraid;

@dynamic title;

@dynamic authors;

- (NSMutableSet*)authorsSet {
	[self willAccessValueForKey:@"authors"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"authors"];

	[self didAccessValueForKey:@"authors"];
	return result;
}

@dynamic genders;

@dynamic notes;

- (NSMutableSet*)notesSet {
	[self willAccessValueForKey:@"notes"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"notes"];

	[self didAccessValueForKey:@"notes"];
	return result;
}

@dynamic tags;

- (NSMutableSet*)tagsSet {
	[self willAccessValueForKey:@"tags"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tags"];

	[self didAccessValueForKey:@"tags"];
	return result;
}

@end

