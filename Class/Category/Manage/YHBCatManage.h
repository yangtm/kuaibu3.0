//
//  YHBCatManage.h
//  YHB_Prj
//
//  Created by Johnny's on 15/1/15.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHBCatManage : NSObject

- (void)getDataArraySuccBlock:(void(^)(NSMutableArray *aArray))aSuccBlock andFailBlock:(void(^)(NSString *aStr))aFailBlock;
@end
