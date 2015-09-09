//
//  TitleTagManage.h
//  YHB_Prj
//
//  Created by Johnny's on 14/12/18.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TitleTagManage : NSObject

//type = 0为发布供应，type为1为发布采购
- (void)getTitleTag:(NSInteger)type succBlock:(void(^)(NSArray *aArray))aSuccBlock andFailBlock:(void(^)(void))aFailBlock;

@end
