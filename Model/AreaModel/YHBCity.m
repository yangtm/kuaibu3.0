//
//  YHBCity.m
//
//  Created by   on 15/1/23
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "YHBCity.h"


NSString *const kYHBCityAreaname = @"areaname";
NSString *const kYHBCityAreaid = @"areaid";


@interface YHBCity ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YHBCity

@synthesize areaname = _areaname;
@synthesize areaid = _areaid;


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
            self.areaname = [self objectOrNilForKey:kYHBCityAreaname fromDictionary:dict];
            self.areaid = [[self objectOrNilForKey:kYHBCityAreaid fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.areaname forKey:kYHBCityAreaname];
    [mutableDict setValue:[NSNumber numberWithDouble:self.areaid] forKey:kYHBCityAreaid];

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

    self.areaname = [aDecoder decodeObjectForKey:kYHBCityAreaname];
    self.areaid = [aDecoder decodeDoubleForKey:kYHBCityAreaid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_areaname forKey:kYHBCityAreaname];
    [aCoder encodeDouble:_areaid forKey:kYHBCityAreaid];
}

- (id)copyWithZone:(NSZone *)zone
{
    YHBCity *copy = [[YHBCity alloc] init];
    
    if (copy) {

        copy.areaname = [self.areaname copyWithZone:zone];
        copy.areaid = self.areaid;
    }
    
    return copy;
}


@end
