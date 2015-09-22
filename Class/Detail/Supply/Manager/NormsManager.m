//
//  NormsManager.m
//  kuaibu
//
//  Created by zxy on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "NormsManager.h"
#import "GYKDataBaseManager.h"
#define NORMS_TABLE_NAME @"normsTable"//表名
#define NORMS_NAME @"normsName"
#define NORMS_PRICE @"normsPrice"


#define LIBNOTEPATH [NSString stringWithFormat:@"%@/norms.db",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]]
@implementation NormsManager
{
    GYKDataBaseManager * _manager;
    
}
- (instancetype)init{
    if (self = [super init]) {
        _manager = [[GYKDataBaseManager alloc] initWithDataBasePath:LIBNOTEPATH];
        [self createTable];
    }
    return self;
}


/**单例对象实现管理*/
+ (NormsManager *)shareManager {
    
    static NormsManager * manager;
    if (!manager) {
        manager = [[NormsManager alloc] init];
    }
    return manager;
}

/**创建表格*/
- (void)createTable
{
    NSDictionary * columsDict = @{
                                  NORMS_PRICE :@"text"
                                  };
    
    [_manager createTable:NORMS_TABLE_NAME primaryKey:NORMS_NAME primaryType:@"text" otherColums:columsDict];
    
    
}

/**插入数据*/
- (void)insertData:(NormsModle *)norms
{
    [_manager insertRecordIntoTable:NORMS_TABLE_NAME withColumsAndValues:@{NORMS_NAME:norms.specificationName, NORMS_PRICE:norms.price}];
    
}

/**显示表格信息*/
- (void)showTableDetail{
    
    FMResultSet * set = [_manager select:nil fromTable:NORMS_TABLE_NAME where:nil];
    while ([set next]) {
        NSLog(@"数据库%@ %@", [set stringForColumn:NORMS_NAME], [set stringForColumn:NORMS_PRICE]);
    }
    
}

/**查找是否存在,根据名字*/
- (BOOL)selectByName:(NSString *)name
{
    FMResultSet * set = [_manager select:nil fromTable:NORMS_TABLE_NAME where:@{NORMS_NAME:name}];
    if ([set next] == NO) {
        return NO;
    }
    return YES;
}

/**根据名字查找名字的内容*/
- (NSString *)selectInfoByName:(NSString *)name
{
    
    FMResultSet * set = [_manager select:@[NORMS_PRICE] fromTable:NORMS_TABLE_NAME where:@{name:name}];
    if ([set next] == NO) {
        return nil;
    }
    
    NSString * str = [NSString stringWithFormat:@"price:%@", [set stringForColumn:NORMS_PRICE]];
    return str;
}

/**返回所有数据*/
- (NSArray *)selectAllNorms
{
    FMResultSet * set = [_manager select:nil fromTable:NORMS_TABLE_NAME where:nil];
    
    NSMutableArray * marray = [[NSMutableArray alloc] init];
    while ([set next]) {
        NSString * str = [NSString stringWithFormat:@"%@xiaozhu%@",[set stringForColumn:NORMS_NAME],[set stringForColumn:NORMS_PRICE]];
        [marray addObject:str];
//        NSLog(@"%@",str);
    }
    return marray;
}



/**根据名字删除*/
- (void)deleteDataByName:(NSString *)name
{
    
    [_manager deleteRecordFromTable:NORMS_TABLE_NAME where:@{NORMS_NAME:name}];
    
}

- (void)deleteAlls
{
    [_manager deleteRecordFromTable:NORMS_TABLE_NAME where:nil];
}

//修改
-(void)updateName:(NSString *)name price:(NSString *)price
{
    //判断记录是否存在
    BOOL flag = [self selectByName:name];
    if (!flag) {
        NSLog(@"修改的记录不存在");
        return;
    }
    [_manager updateTable:NORMS_TABLE_NAME records:@{NORMS_NAME:name,NORMS_PRICE:price} where:@{NORMS_NAME:name,NORMS_PRICE:price}];
    
}

@end
