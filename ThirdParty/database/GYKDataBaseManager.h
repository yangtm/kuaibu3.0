//
//  GYKDataBaseManager.h
//  数据库访问
//
//  Created by gyk on 15/3/4.
//  Copyright (c) 2015年 GYK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

/*
 该类基于FMDB，进行二次迭代。需要导入libsqlite3.dylib
 */

/**数据库管理类，负责数据库操作，一个manager负责一个数据库*/
@interface GYKDataBaseManager : NSObject

/**构造方法，参数是数据库的路径*/
- (instancetype)initWithDataBasePath:(NSString *)path;

/**创建表单，传入表单名，主键列和其他健列*/
- (void)createTable:(NSString *)tableName primaryKey:(NSString *)keyName primaryType:(NSString *)colType otherColums:(NSDictionary *)colums;

/**删除表单，根据表单名*/
- (void)dropTable:(NSString *)tableName;

/**插入记录，参数是字典，键是列名，值是列值*/
- (void)insertRecordIntoTable:(NSString *)tableName withColumsAndValues:(NSDictionary *)dict;
//@{@"姓名":@"刘德华", @"国籍":@"中国香港", @"生日":[NSDate date]}

/**删除记录，参数是字典，是筛选的条件*/
- (void)deleteRecordFromTable:(NSString *)tableName where:(NSDictionary *)whereDict;

/**删除记录，参数是字符串，允许用户，自定义删选条件*/
- (void)deleteRecordFromTable:(NSString *)tableName whereString:(NSString *)whereStr;

/**查看记录，参数是数组和字典，是筛选条件*/
- (FMResultSet *)select:(NSArray *)columNames fromTable:(NSString *)tableName where:(NSDictionary *)whereDict;

/**更新记录，参数是两个字典，更新的记录，和筛选条件*/
- (void)updateTable:(NSString *)tableName records:(NSDictionary *)updateDict where:(NSDictionary *)whereDict;

+ (void)test;

@end











