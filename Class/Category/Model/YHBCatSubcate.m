//
//  YHBCatSubcate.m
//
//  Created by  C陈政旭 on 15/1/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "YHBCatSubcate.h"


NSString *const kYHBCatSubCategoryName  = @"categoryName";
//NSString *const kYHBCatSubCateCatimg = @"catimg";
NSString *const kYHBCatSubCategoryId = @"categoryId";


@interface YHBCatSubcate ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YHBCatSubcate

@synthesize categoryName = _categoryName;
@synthesize categoryId = _categoryId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.categoryName = [self objectOrNilForKey:kYHBCatSubCategoryName fromDictionary:dict];
        self.categoryId = [[self objectOrNilForKey:kYHBCatSubCategoryId fromDictionary:dict] doubleValue];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.categoryName forKey:kYHBCatSubCategoryName];
    [mutableDict setValue:[NSNumber numberWithInteger:self.categoryId] forKey:kYHBCatSubCategoryId];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.categoryName = [aDecoder decodeObjectForKey:kYHBCatSubCategoryName];
    self.categoryId = [aDecoder decodeIntegerForKey:kYHBCatSubCategoryId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_categoryName forKey:kYHBCatSubCategoryName];
    [aCoder encodeInteger:_categoryId forKey:kYHBCatSubCategoryId];
}

- (id)copyWithZone:(NSZone *)zone
{
    YHBCatSubcate *copy = [[YHBCatSubcate alloc] init];
    
    if (copy) {

        copy.categoryName = [self.categoryName copyWithZone:zone];
        copy.categoryId = self.categoryId;
    }
    
    return copy;
}


@end
