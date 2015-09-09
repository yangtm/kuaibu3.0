//
//  YHBAreaModel.h
//
//  Created by   on 15/1/23
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YHBAreaModel : NSObject //<NSCoding, NSCopying>

@property (nonatomic, strong) NSString *areaname;
@property (nonatomic, strong) NSString* areaid;
@property (nonatomic, strong) NSArray *city;

//+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
//- (instancetype)initWithDictionary:(NSDictionary *)dict;
//- (NSDictionary *)dictionaryRepresentation;

@end
