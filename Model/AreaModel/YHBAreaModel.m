//
//  YHBAreaModel.m
//
//  Created by   on 15/1/23
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "YHBAreaModel.h"
#import "YHBCity.h"


NSString *const kYHBAreaModelAreaname = @"areaname";
NSString *const kYHBAreaModelAreaid = @"areaid";
NSString *const kYHBAreaModelCity = @"city";


@interface YHBAreaModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YHBAreaModel

@synthesize areaname = _areaname;
@synthesize areaid = _areaid;
@synthesize city = _city;


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
            self.areaname = [self objectOrNilForKey:kYHBAreaModelAreaname fromDictionary:dict];
            self.areaid = [[self objectOrNilForKey:kYHBAreaModelAreaid fromDictionary:dict] doubleValue];
    NSObject *receivedYHBCity = [dict objectForKey:kYHBAreaModelCity];
    NSMutableArray *parsedYHBCity = [NSMutableArray array];
    if ([receivedYHBCity isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedYHBCity) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedYHBCity addObject:[YHBCity modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedYHBCity isKindOfClass:[NSDictionary class]]) {
       [parsedYHBCity addObject:[YHBCity modelObjectWithDictionary:(NSDictionary *)receivedYHBCity]];
    }

    self.city = [NSArray arrayWithArray:parsedYHBCity];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.areaname forKey:kYHBAreaModelAreaname];
    [mutableDict setValue:[NSNumber numberWithDouble:self.areaid] forKey:kYHBAreaModelAreaid];
    NSMutableArray *tempArrayForCity = [NSMutableArray array];
    for (NSObject *subArrayObject in self.city) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCity addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCity addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCity] forKey:kYHBAreaModelCity];

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

    self.areaname = [aDecoder decodeObjectForKey:kYHBAreaModelAreaname];
    self.areaid = [aDecoder decodeDoubleForKey:kYHBAreaModelAreaid];
    self.city = [aDecoder decodeObjectForKey:kYHBAreaModelCity];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_areaname forKey:kYHBAreaModelAreaname];
    [aCoder encodeDouble:_areaid forKey:kYHBAreaModelAreaid];
    [aCoder encodeObject:_city forKey:kYHBAreaModelCity];
}

- (id)copyWithZone:(NSZone *)zone
{
    YHBAreaModel *copy = [[YHBAreaModel alloc] init];
    
    if (copy) {

        copy.areaname = [self.areaname copyWithZone:zone];
        copy.areaid = self.areaid;
        copy.city = [self.city copyWithZone:zone];
    }
    
    return copy;
}


@end
