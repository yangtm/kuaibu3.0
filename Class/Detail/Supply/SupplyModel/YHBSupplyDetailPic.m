//
//  YHBSupplyDetailPic.m
//
//  Created by  C陈政旭 on 14/12/7
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "YHBSupplyDetailPic.h"


NSString *const kYHBSupplyDetailPicPid = @"pid";
NSString *const kYHBSupplyDetailPicThumb = @"thumb";
NSString *const kYHBSupplyDetailPicLarge = @"large";
NSString *const kYHBSupplyDetailPicMiddle = @"middle";


@interface YHBSupplyDetailPic ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YHBSupplyDetailPic

@synthesize thumb = _thumb;
@synthesize large = _large;
@synthesize middle = _middle;


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
        self.pid = [[self objectOrNilForKey:kYHBSupplyDetailPicPid fromDictionary:dict] integerValue];
            self.thumb = [self objectOrNilForKey:kYHBSupplyDetailPicThumb fromDictionary:dict];
            self.large = [self objectOrNilForKey:kYHBSupplyDetailPicLarge fromDictionary:dict];
            self.middle = [self objectOrNilForKey:kYHBSupplyDetailPicMiddle fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInteger:self.pid] forKey:kYHBSupplyDetailPicPid];
    [mutableDict setValue:self.thumb forKey:kYHBSupplyDetailPicThumb];
    [mutableDict setValue:self.large forKey:kYHBSupplyDetailPicLarge];
    [mutableDict setValue:self.middle forKey:kYHBSupplyDetailPicMiddle];

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

    self.pid = [[aDecoder decodeObjectForKey:kYHBSupplyDetailPicPid] integerValue];
    self.thumb = [aDecoder decodeObjectForKey:kYHBSupplyDetailPicThumb];
    self.large = [aDecoder decodeObjectForKey:kYHBSupplyDetailPicLarge];
    self.middle = [aDecoder decodeObjectForKey:kYHBSupplyDetailPicMiddle];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:[NSNumber numberWithInteger:_pid] forKey:kYHBSupplyDetailPicPid];
    [aCoder encodeObject:_thumb forKey:kYHBSupplyDetailPicThumb];
    [aCoder encodeObject:_large forKey:kYHBSupplyDetailPicLarge];
    [aCoder encodeObject:_middle forKey:kYHBSupplyDetailPicMiddle];
}

- (id)copyWithZone:(NSZone *)zone
{
    YHBSupplyDetailPic *copy = [[YHBSupplyDetailPic alloc] init];
    
    if (copy) {

        copy.pid = self.pid;
        copy.thumb = [self.thumb copyWithZone:zone];
        copy.large = [self.large copyWithZone:zone];
        copy.middle = [self.middle copyWithZone:zone];
    }
    
    return copy;
}


@end
