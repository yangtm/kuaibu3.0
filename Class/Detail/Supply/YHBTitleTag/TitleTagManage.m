//
//  TitleTagManage.m
//  YHB_Prj
//
//  Created by Johnny's on 14/12/18.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "TitleTagManage.h"
//#import "NetManager.h"

@implementation TitleTagManage

- (void)getTitleTag:(NSInteger)type succBlock:(void(^)(NSArray *aArray))aSuccBlock andFailBlock:(void(^)(void))aFailBlock
{
    if (type == 1) {
        NSArray *array = @[@"样板房", @"别墅工程", @"酒店工程", @"办公工程", @"家用住宅", @"辅料配件"];
        aSuccBlock(array);
    }
    else{
//        NSString *supplyDetailUrl = nil;
//        NSDictionary *dict = [NSDictionary new];
//        kYHBRequestUrl(@"getTitleTag.php", supplyDetailUrl);
//        [NetManager requestWith:dict url:supplyDetailUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
//            NSDictionary *dataDict = [successDict objectForKey:@"data"];
//            NSArray *array = [dataDict objectForKey:@"taglist"];
//            aSuccBlock(array);
//        } failure:^(NSDictionary *failDict, NSError *error) {
//            aFailBlock();
//        }];
    }
}

@end
