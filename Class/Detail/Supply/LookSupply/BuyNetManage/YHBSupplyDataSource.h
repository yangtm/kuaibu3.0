//
//  YHBSupplyDataSource.h
//  YHB_Prj
//
//  Created by 童小波 on 15/3/19.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHBSupplyDataSource : NSObject

@property (assign, nonatomic) NSInteger numberOfSections;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) BOOL hasMore;
@property (assign, nonatomic) int totalNum;

- (NSInteger)rowsOfSection:(NSInteger)section;
- (id) objectForSection:(NSInteger)section andRow:(NSInteger)row;
- (void) appendData:(id)dataArray;

@end
