// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MXWGender.m instead.

#import "_MXWGender.h"

const struct MXWGenderAttributes MXWGenderAttributes = {
	.genderName = @"genderName",
};

const struct MXWGenderRelationships MXWGenderRelationships = {
	.books = @"books",
};

@implementation MXWGenderID
@end

@implementation _MXWGender

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Gender" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Gender";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Gender" inManagedObjectContext:moc_];
}

- (MXWGenderID*)objectID {
	return (MXWGenderID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic genderName;

@dynamic books;

- (NSMutableSet*)booksSet {
	[self willAccessValueForKey:@"books"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"books"];

	[self didAccessValueForKey:@"books"];
	return result;
}

@end

