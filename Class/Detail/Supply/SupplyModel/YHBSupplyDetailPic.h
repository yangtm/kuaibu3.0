//
//  YHBSupplyDetailPic.h
//
//  Created by  C陈政旭 on 14/12/7
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YHBSupplyDetailPic : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *large;
@property (nonatomic, strong) NSString *middle;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
