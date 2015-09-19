//
//  YHBCatSubcate.h
//
//  Created by  C陈政旭 on 15/1/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YHBCatSubcate : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *categoryName;
//@property (nonatomic, strong) NSString *catimg;
@property (nonatomic, assign) NSInteger categoryId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
