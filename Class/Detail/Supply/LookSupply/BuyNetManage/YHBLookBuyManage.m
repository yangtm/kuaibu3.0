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

- (void)getBuyArrayWithKeyword:(NSString *)keyword typeId:(NSInteger)typeId catIds:(NSArray *)catIds complete:(void(^)(YHBSupplyDataSource *dataSource))aSuccBlock andFail:(void(^)(NSString *aStr))aFailBlock isVip:(BOOL)aBool
{
    if (self.dataSource == nil) {
        self.dataSource = [[YHBSupplyDataSource alloc] init];
    }
    
    isVip = aBool;
    pageid = 1;
    pagesize = 10;
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
            catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
        }
        catIdsStr = [catIdsStr substringFromIndex:1];
        NSString *allConditions = [NSString stringWithFormat:@"category:%@",catIdsStr];
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageid],@"pageIndex",allConditions,@"allConditions", nil];
    }else
    {
      dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageid],@"pageIndex", nil];
    }
    NSString *url = nil;
    //NSLog(@"keyword=%@",keyword);
    if ([keyword isEqualToString:@"my"]) {
        kYHBRequestUrl(@"procurement/getMyAttentionProcurement", url);
    }
    kYHBRequestUrl(@"procurement/open/getProcurementList", url);
    [NetworkService postWithURL:url paramters:dict success:^(NSData *receiveData) {
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result;
            NSArray *rslistArray = dic[@"RESULT"];
            NSMutableArray *resultArray = [NSMutableArray new];
            pagetotal = [dic[@"RESPCODE"]intValue];
            self.dataSource.totalNum = pagetotal;
            for (int i=0; i<rslistArray.count; i++)
            {
                NSDictionary *dict = [rslistArray objectAtIndex:i];
                YHBSupplyModel *model = [YHBSupplyModel modelObjectWithDictionary:dict];
                [resultArray addObject:model];
            }
            //NSLog(@"result=%@",result);
             self.dataSource.dataArray = resultArray;
            aSuccBlock(self.dataSource);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

- (void)getNextBuyArrayWithKeyword:(NSString *)keyword typeId:(NSInteger)typeId complete:(void (^)(YHBSupplyDataSource *dataSource))aSuccBlock andFail:(void (^)(NSString *aStr))aFailBlock
{
    if (pagesize*pageid<pagetotal)
    {
        pageid++;
        NSMutableDictionary *dict;
//        if (isVip)
//        {
//            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                    [NSString stringWithFormat:@"%d", pageid], @"pageid",
//                    [NSString stringWithFormat:@"%d", pagesize], @"pagesize",
//                    [NSString stringWithFormat:@"%d", (int)typeId], @"typeid",
//                    @"1", @"vip",
//                    nil];
//        }
//        else
//        {
//            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                    [NSString stringWithFormat:@"%d", pageid], @"pageid",
//                    [NSString stringWithFormat:@"%d", pagesize], @"pagesize",
//                    [NSString stringWithFormat:@"%d", (int)typeId], @"typeid",
//                    nil];
//        }
        
        if (_catIds != nil) {
            NSString *catIdsStr = @"";
            for (NSNumber *number in _catIds) {
                catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
            }
            catIdsStr = [catIdsStr substringFromIndex:1];
            NSString *allConditions = [NSString stringWithFormat:@"category:%@",catIdsStr];
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageid],@"pageIndex",allConditions,@"allConditions", nil];
        }else
        {
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageid],@"pageIndex", nil];
        }
    
        NSString *url = nil;
        //NSLog(@"keyword=%@",keyword);
        if ([keyword isEqualToString:@"my"]) {
            kYHBRequestUrl(@"procurement/getMyAttentionProcurement", url);
        }
        kYHBRequestUrl(@"procurement/open/getProcurementList", url);
        //NSLog(@"采购刷新dict=%@",dict);
        [NetworkService postWithURL:url paramters:dict success:^(NSData *receiveData) {
            id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = result;
                // NSLog(@"result:%@",dic);
                NSArray *rslistArray = dic[@"RESULT"];
                NSMutableArray *resultArray = [NSMutableArray new];
                for (int i=0; i<rslistArray.count; i++)
                {
                    NSDictionary *dict = [rslistArray objectAtIndex:i];
                    YHBSupplyModel *model = [YHBSupplyModel modelObjectWithDictionary:dict];
                    [resultArray addObject:model];
                }
                //NSLog(@"result=%@",resultArray);
                [self.dataSource appendData:resultArray];
                aSuccBlock(self.dataSource);
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    else
    {
        aFailBlock(@"已无更多");
    }

}
@end
