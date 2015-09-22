//
//  NormsManager.h
//  kuaibu
//
//  Created by zxy on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NormsModle.h"

/**用于用户数据的数据新信息管理*/
@interface NormsManager : NSObject


/**单例对象实现管理*/
+ (NormsManager *)shareManager;

/**用户注册插入数据*/
- (void)insertData:(NormsModle *)norms;

/**显示表格信息*/
- (void)showTableDetail;

/**查找是否存在,根据名字*/
- (BOOL)selectByName:(NSString *)name;

/**根据名字查找名字的内容*/
- (NSString *)selectInfoByName:(NSString *)name;

/**根据名字删除笔记*/
- (void)deleteDataByName:(NSString *)name;

/**返回所有笔记*/
- (NSArray *)selectAllNorms;

- (void)deleteAlls;

-(void)updateName:(NSString *)name price:(NSString *)price;
@end
