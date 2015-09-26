//
//  YHBCatManage.m
//  YHB_Prj
//
//  Created by Johnny's on 15/1/15.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBCatManage.h"
#import "YHBCatData.h"
//#import "NetManager.h"
//#import "YHBMock.h"

@implementation YHBCatManage

- (void)getDataArraySuccBlock:(void(^)(NSMutableArray *aArray))aSuccBlock andFailBlock:(void(^)(NSString *aStr))aFailBlock
{
    NSString *url = nil;
    kYHBRequestUrl(@"category/getCategory", url);
    //NSLog(@"%@",url);
    [NetworkService postWithURL:url paramters:nil success:^(NSData *receiveData) {
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result;
            //NSLog(@"###result:%@",dic);
            NSMutableArray *reslutArray = [NSMutableArray new];
            NSArray *dataArray = [dic objectForKey:@"RESULT"];
            for (NSDictionary *dict in dataArray)
            {
               // NSLog(@"*****%@",dict);
                YHBCatData *model = [YHBCatData modelObjectWithDictionary:dict];
                [reslutArray addObject:model];
            }
            aSuccBlock(reslutArray);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
