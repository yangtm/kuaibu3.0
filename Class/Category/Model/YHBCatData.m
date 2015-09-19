//
//  YHBCatData.m
//
//  Created by  C陈政旭 on 15/1/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "YHBCatData.h"
#import "YHBCatSubcate.h"


NSString *const kYHBCategoryId = @"categoryId";
NSString *const kYHBCategoryName = @"categoryName";
NSString *const kYHBCategroyProductAmount = @"categroyProductAmount";
NSString *const kYHBChildren = @"children";


@interface YHBCatData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YHBCatData

@synthesize categoryName = _categoryName;
@synthesize categoryId = _categoryId;
@synthesize children = _children;


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
            self.categoryName = [self objectOrNilForKey:kYHBCategoryName fromDictionary:dict];
            self.categoryId = [[self objectOrNilForKey:kYHBCategoryId fromDictionary:dict]integerValue];
            self.categroyProductAmount = [[self objectOrNilForKey:kYHBCategroyProductAmount fromDictionary:dict] doubleValue];
    NSObject *receivedYHBChildren = [dict objectForKey:kYHBChildren];
    NSMutableArray *parsedYHBCatSubcate = [NSMutableArray array];
    if ([receivedYHBChildren isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedYHBChildren) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedYHBCatSubcate addObject:[YHBCatSubcate modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedYHBChildren isKindOfClass:[NSDictionary class]]) {
       [parsedYHBCatSubcate addObject:[YHBCatSubcate modelObjectWithDictionary:(NSDictionary *)receivedYHBChildren]];
    }

    self.children = [NSArray arrayWithArray:parsedYHBCatSubcate];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.categoryName forKey:kYHBCategoryName];
    [mutableDict setValue:[NSNumber numberWithInteger:self.categoryId] forKey:kYHBCategoryId];
    [mutableDict setValue:[NSNumber numberWithInteger:self.categroyProductAmount] forKey:kYHBCategroyProductAmount];
    NSMutableArray *tempArrayForChildren = [NSMutableArray array];
    for (NSObject *subArrayObject in self.children) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForChildren addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForChildren addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForChildren] forKey:kYHBChildren];

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

    self.categoryId = [aDecoder decodeIntegerForKey:kYHBCategoryId];
    self.categoryName = [aDecoder decodeObjectForKey:kYHBCategoryName];
    self.categroyProductAmount = [aDecoder decodeDoubleForKey:kYHBCategroyProductAmount];
    self.children = [aDecoder decodeObjectForKey:kYHBChildren];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInteger:_categoryId forKey:kYHBCategoryId];
    [aCoder encodeDouble:_categroyProductAmount forKey:kYHBCategroyProductAmount];
    [aCoder encodeObject:_categoryName forKey:kYHBCategoryName];
    [aCoder encodeObject:_children forKey:kYHBChildren];
}

- (id)copyWithZone:(NSZone *)zone
{
    YHBCatData *copy = [[YHBCatData alloc] init];
    
    if (copy) {

        copy.categoryName = [self.categoryName copyWithZone:zone];
        copy.categoryId = self.categoryId;
        copy.categroyProductAmount = self.categroyProductAmount;
        copy.children = [self.children copyWithZone:zone];
    }
    
    return copy;
}


@end
