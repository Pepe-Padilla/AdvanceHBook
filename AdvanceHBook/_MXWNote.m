// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MXWNote.m instead.

#import "_MXWNote.h"

const struct MXWNoteAttributes MXWNoteAttributes = {
	.addres = @"addres",
	.creationDate = @"creationDate",
	.image = @"image",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.modificationDate = @"modificationDate",
	.page = @"page",
	.text = @"text",
};

const struct MXWNoteRelationships MXWNoteRelationships = {
	.books = @"books",
};

@implementation MXWNoteID
@end

@implementation _MXWNote

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Note";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Note" inManagedObjectContext:moc_];
}

- (MXWNoteID*)objectID {
	return (MXWNoteID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"pageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"page"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic addres;

@dynamic creationDate;

@dynamic image;

@dynamic latitude;

- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:@(value_)];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:@(value_)];
}

@dynamic longitude;

- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:@(value_)];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:@(value_)];
}

@dynamic modificationDate;

@dynamic page;

- (int16_t)pageValue {
	NSNumber *result = [self page];
	return [result shortValue];
}

- (void)setPageValue:(int16_t)value_ {
	[self setPage:@(value_)];
}

- (int16_t)primitivePageValue {
	NSNumber *result = [self primitivePage];
	return [result shortValue];
}

- (void)setPrimitivePageValue:(int16_t)value_ {
	[self setPrimitivePage:@(value_)];
}

@dynamic text;

@dynamic books;

- (NSMutableSet*)booksSet {
	[self willAccessValueForKey:@"books"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"books"];

	[self didAccessValueForKey:@"books"];
	return result;
}

@end

