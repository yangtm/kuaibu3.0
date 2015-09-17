//
//  YHBSupplyModel.h
//
//  Created by  C陈政旭 on 14/12/6
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YHBSupplyModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *typename;
@property (nonatomic, assign) int itemid;
@property (nonatomic, strong) NSString *catname;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *editdate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, assign) int vip;
@property (nonatomic, strong) NSString *edittime;
@property(nonatomic, strong) NSString *amount;
@property(nonatomic, strong) NSString *unit;
@property(nonatomic, strong) NSString *today;
@property (nonatomic, assign) int hits;
@property (nonatomic, strong) NSString *voicePath;
@property (nonatomic, assign) NSInteger voiceSeconds;
@property (nonatomic, strong) NSString *amontUnit;
@property (nonatomic, strong) NSString *creatDate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
