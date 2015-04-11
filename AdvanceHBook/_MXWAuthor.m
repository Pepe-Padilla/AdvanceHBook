// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MXWAuthor.m instead.

#import "_MXWAuthor.h"

const struct MXWAuthorAttributes MXWAuthorAttributes = {
	.authorName = @"authorName",
};

const struct MXWAuthorRelationships MXWAuthorRelationships = {
	.books = @"books",
};

@implementation MXWAuthorID
@end

@implementation _MXWAuthor

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Author";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Author" inManagedObjectContext:moc_];
}

- (MXWAuthorID*)objectID {
	return (MXWAuthorID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic authorName;

@dynamic books;

- (NSMutableSet*)booksSet {
	[self willAccessValueForKey:@"books"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"books"];

	[self didAccessValueForKey:@"books"];
	return result;
}

@end

