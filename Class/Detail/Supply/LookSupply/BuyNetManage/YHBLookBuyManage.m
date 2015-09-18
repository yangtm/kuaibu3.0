//
//  YHBLookBuyManage.m
//  YHB_Prj
//
//  Created by Johnny's on 14/12/21.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "YHBLookBuyManage.h"
//#import "NetManager.h"
#import "YHBSupplyModel.h"
#import "YHBSupplyDataSource.h"

@interface YHBLookBuyManage()

@property (strong, nonatomic) YHBSupplyDataSource *dataSource;
@property (strong, nonatomic) NSArray *catIds;

@end

@implementation YHBLookBuyManage

BOOL isVip;
int pagesize;
int pageid;
int pagetotal;

- (void)getBuyArray:(void(^)(YHBSupplyDataSource *dataSource))aSuccBlock andFail:(void(^)(NSString *aStr))aFailBlock isVip:(BOOL)aBool
{
//    if (self.dataSource == nil) {
//        self.dataSource = [[YHBSupplyDataSource alloc] init];
//    }
//    
//    isVip = aBool;
//    pagesize = 20;
//    pageid = 1;
//    NSString *supplyUrl = nil;
//    NSDictionary *dict;
//    if (isVip)
//    {
//        dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", pageid],@"pageid",[NSString stringWithFormat:@"%d", pagesize],@"pagesize",@"1",@"vip",@"0",@"typeid",nil];
//    }
//    else
//    {
//        dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", pageid],@"pageid",[NSString stringWithFormat:@"%d", pagesize],@"pagesize",@"0",@"typeid",nil];
//    }
//    
//    kYHBRequestUrl(@"getBuyList.php", supplyUrl);
//    [NetManager requestWith:dict url:supplyUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
//        //        MLOG(@"%@", successDict);
//        NSString *result = [successDict objectForKey:@"result"];
//        if ([result intValue] != 1)
//        {
//            aFailBlock([successDict objectForKey:@"error"]);
//        }
//        else
//        {
//            NSDictionary *dataDict = [successDict objectForKey:@"data"];
//            NSDictionary *pageDict = [dataDict objectForKey:@"page"];
//            pagetotal = [[pageDict objectForKey:@"pagetotal"] intValue];
//            self.dataSource.totalNum = pagetotal;
//            NSArray *rslistArray = [dataDict objectForKey:@"rslist"];
//            NSMutableArray *resultArray = [NSMutableArray new];
//            for (int i=0; i<rslistArray.count; i++)
//            {
//                NSDictionary *dict = [rslistArray objectAtIndex:i];
//                YHBSupplyModel *model = [YHBSupplyModel modelObjectWithDictionary:dict];
//                [resultArray addObject:model];
//            }
//            self.dataSource.dataArray = resultArray;
//            aSuccBlock(self.dataSource);
//        }
//    } failure:^(NSDictionary *failDict, NSError *error) {
//        aFailBlock([failDict objectForKey:@"error"]);
//    }];
}

- (void)getBuyArrayWithKeyword:(NSString *)keyword typeId:(NSInteger)typeId catIds:(NSArray *)catIds complete:(void(^)(YHBSupplyDataSource *dataSource))aSuccBlock andFail:(void(^)(NSString *aStr))aFailBlock isVip:(BOOL)aBool
{
    if (self.dataSource == nil) {
        self.dataSource = [[YHBSupplyDataSource alloc] init];
    }
    
    isVip = aBool;
    pagesize = 20;
    pageid = 1;
    self.catIds = catIds;
    NSMutableDictionary *dict;
//    if (isVip)
//    {
//        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", pageid],@"pageid",[NSString stringWithFormat:@"%d", pagesize],@"pagesize",@"1",@"vip",@"0",@"typeid", keyword, @"keyword",
//                [NSNumber numberWithInteger:typeId], @"typeid", nil];
//    }
//    else
//    {
//        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", pageid],@"pageid",[NSString stringWithFormat:@"%d", pagesize],@"pagesize",@"0",@"typeid", keyword, @"keyword", [NSNumber numberWithInteger:typeId], @"typeid", nil];
//    }
    
    if (catIds != nil) {
        NSString *catIdsStr = @"";
        for (NSNumber *number in catIds) {
            catIdsStr = [catIdsStr stringByAppendingFormat:@",%@", number];
        }
        catIdsStr = [catIdsStr substringFromIndex:1];
        [dict setObject:catIdsStr forKey:@"catid"];
    }
    
    NSString *url = nil;
    kYHBRequestUrl(@"procurement/open/getProcurementList", url);
    //NSLog(@"%@",url);
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"pageIndex", nil];
    
    [NetworkService postWithURL:url paramters:dict success:^(NSData *receiveData) {
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result;
           // NSLog(@"result:%@",dic);
            NSArray *rslistArray = dic[@"RESULT"];
            NSMutableArray *resultArray = [NSMutableArray new];
            self.dataSource.totalNum = rslistArray.count;
            for (int i=0; i<rslistArray.count; i++)
            {
                NSDictionary *dict = [rslistArray objectAtIndex:i];
               // NSLog(@"dict=%@",dict);
                YHBSupplyModel *model = [YHBSupplyModel modelObjectWithDictionary:dict];
                
               // NSLog(@"#####model=%@",model);
                [resultArray addObject:model];
            }
            //NSLog(@"result=%@",resultArray);
            self.dataSource.dataArray = resultArray;
            aSuccBlock(self.dataSource);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

- (void)getNextBuyArray:(void (^)(YHBSupplyDataSource *dataSource))aSuccBlock andFail:(void (^)(NSString *aStr))aFailBlock
{
    if (pagesize*pageid<pagetotal)
    {
        pageid++;
        NSString *supplyUrl = nil;
        NSDictionary *dict;
        if (isVip)
        {
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", pageid],@"pageid",[NSString stringWithFormat:@"%d", pagesize],@"pagesize",@"1",@"vip",nil];
        }
        else
        {
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", pageid],@"pageid",[NSString stringWithFormat:@"%d", pagesize],@"pagesize",nil];
        }
        
        kYHBRequestUrl(@"getBuyList.php", supplyUrl);
//        [NetManager requestWith:dict url:supplyUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
//            //        MLOG(@"%@", successDict);
//            NSString *result = [successDict objectForKey:@"result"];
//            if ([result intValue] != 1)
//            {
//                aFailBlock([successDict objectForKey:@"error"]);
//            }
//            else
//            {
//                NSDictionary *dataDict = [successDict objectForKey:@"data"];
//                NSDictionary *pageDict = [dataDict objectForKey:@"page"];
//                pagetotal = [[pageDict objectForKey:@"pagetotal"] intValue];
//                NSArray *rslistArray = [dataDict objectForKey:@"rslist"];
//                NSMutableArray *resultArray = [NSMutableArray new];
//                for (int i=0; i<rslistArray.count; i++)
//                {
//                    NSDictionary *dict = [rslistArray objectAtIndex:i];
//                    YHBSupplyModel *model = [YHBSupplyModel modelObjectWithDictionary:dict];
//                    [resultArray addObject:model];
//                }
//                [self.dataSource appendData:resultArray];
//                aSuccBlock(self.dataSource);
//            }
//        } failure:^(NSDictionary *failDict, NSError *error) {
//            aFailBlock([failDict objectForKey:@"error"]);
//        }];
    }
    else
    {
        aFailBlock(@"已无更多");
    }
}

- (void)getNextBuyArrayWithKeyword:(NSString *)keyword typeId:(NSInteger)typeId complete:(void (^)(YHBSupplyDataSource *dataSource))aSuccBlock andFail:(void (^)(NSString *aStr))aFailBlock
{
    if (pagesize*pageid<pagetotal)
    {
        pageid++;
        NSString *supplyUrl = nil;
        NSMutableDictionary *dict;
        if (isVip)
        {
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%d", pageid], @"pageid",
                    [NSString stringWithFormat:@"%d", pagesize], @"pagesize",
                    [NSString stringWithFormat:@"%d", (int)typeId], @"typeid",
                    @"1", @"vip",
                    nil];
        }
        else
        {
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%d", pageid], @"pageid",
                    [NSString stringWithFormat:@"%d", pagesize], @"pagesize",
                    [NSString stringWithFormat:@"%d", (int)typeId], @"typeid",
                    nil];
        }
        
        if (keyword != nil) {
            [dict setValue:keyword forKey:@"keyword"];
        }
        if (_catIds != nil) {
            NSString *catIdsStr = @"";
            for (NSNumber *number in _catIds) {
                catIdsStr = [catIdsStr stringByAppendingFormat:@",%@", number];
            }
            catIdsStr = [catIdsStr substringFromIndex:1];
            [dict setObject:catIdsStr forKey:@"catid"];
        }
        
        kYHBRequestUrl(@"getBuyList.php", supplyUrl);
//        [NetManager requestWith:dict url:supplyUrl method:@"GET" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
//            //        MLOG(@"%@", successDict);
//            NSString *result = [successDict objectForKey:@"result"];
//            if ([result intValue] != 1)
//            {
//                aFailBlock([successDict objectForKey:@"error"]);
//            }
//            else
//            {
//                NSDictionary *dataDict = [successDict objectForKey:@"data"];
//                NSDictionary *pageDict = [dataDict objectForKey:@"page"];
//                pagetotal = [[pageDict objectForKey:@"pagetotal"] intValue];
//                NSArray *rslistArray = [dataDict objectForKey:@"rslist"];
//                NSMutableArray *resultArray = [NSMutableArray new];
//                for (int i=0; i<rslistArray.count; i++)
//                {
//                    NSDictionary *dict = [rslistArray objectAtIndex:i];
//                    YHBSupplyModel *model = [YHBSupplyModel modelObjectWithDictionary:dict];
//                    //                    NSLog(@"%@", model.date);
//                    [resultArray addObject:model];
//                }
//                [self.dataSource appendData:resultArray];
//                aSuccBlock(self.dataSource);
//            }
//        } failure:^(NSDictionary *failDict, NSError *error) {
//            aFailBlock([failDict objectForKey:@"error"]);
//        }];
    }
    else
    {
        aFailBlock(@"已无更多");
    }
}

@end
