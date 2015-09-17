//
//  YHBSupplyDataSource.m
//  YHB_Prj
//
//  Created by 童小波 on 15/3/19.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBSupplyDataSource.h"
#import "YHBSupplyModel.h"
#import "NSDate+Utilities.h"

@interface YHBSupplyDataSource()

@property (strong, nonatomic) NSArray *sectionArray;
@property (strong, nonatomic) NSArray *offsetArray;

@end

@implementation YHBSupplyDataSource

- (NSInteger)rowsOfSection:(NSInteger)section
{
    return [self.sectionArray[section] integerValue];
}

- (id) objectForSection:(NSInteger)section andRow:(NSInteger)row
{
    NSInteger num = [self.offsetArray[section] integerValue] + row;
    return self.dataArray[num];
}

- (void) setDataArray:(NSMutableArray *)dataArray
{
    self.hasMore = YES;
    _dataArray = dataArray;
    if (_dataArray.count == self.totalNum) {
        self.hasMore = NO;
    }
    [self sort];
}

- (void) appendData:(id)dataArray
{
    [self.dataArray addObjectsFromArray:dataArray];
    if (_dataArray.count == self.totalNum) {
        self.hasMore = NO;
    }
    [self sort];
}

- (NSInteger) numberOfSections
{
    return self.sectionArray.count;
}

- (NSString *)titleForSection:(NSInteger)section
{
    NSInteger num = [self.offsetArray[section] integerValue];
    YHBSupplyModel *model = self.dataArray[num];
    if ([model.date isToday]) {
        return @"最新";
    }
    return model.editdate;
}

- (void) sort
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    if (self.dataArray.count > 0) {
        YHBSupplyModel *first = self.dataArray[0];
        NSDate *baseDate = first.date;
        int count = 0;
        int count1 = 0;
        [array1 addObject:[NSNumber numberWithInt:0]];
        for (YHBSupplyModel *model in self.dataArray) {
            if ([model.date isEqualToDate:baseDate]) {
                count++;
            }
            else{
                [array addObject:[NSNumber numberWithInt:count]];
                [array1 addObject:[NSNumber numberWithInt:count1]];
                count = 1;
                baseDate = model.date;
            }
            count1++;
        }
        [array addObject:[NSNumber numberWithInt:count]];
    }
    self.sectionArray = array;
    self.offsetArray = array1;
}

@end
