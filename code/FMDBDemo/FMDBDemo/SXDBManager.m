//
//  SXDBManager.m
//  FMDBDemo
//
//  Created by jumei_vince on 17/4/27.
//  Copyright © 2017年 vince. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "SXDBManager+Cache.h"

@interface SXDBManager()
@property (nonatomic, strong) FMDatabaseQueue * queue;
@end

@implementation SXDBManager

+ (instancetype)shareDBManager{
    static SXDBManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SXDBManager alloc] init];
    });
    return manager;
}

- (void)dealloc
{
    [self.queue close];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDB];
        [self initialConfiguration];
//        [self deleteExpireUser];
//        [self deleteAllUser];
//        [self deleteUserTo:50];
    }
    return self;
}

- (void)setupDB{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/SUser.db"];
    self.queue = [FMDatabaseQueue databaseQueueWithPath:path];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        [db executeUpdate:@"DROP TABLE Suser"]; //删除数据表
        //构建数据表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Suser(uid text,name text,des text)"];
        //创建索引 增加查询更新效率
        [db executeUpdate:@"CREATE INDEX IF NOT EXISTS Suser_index ON Suser (uid)"];
        //增加新字段
        if (![db columnExists:@"time" inTableWithName:@"Suser"]) {
            NSLog(@"增加新字段time");
            [db executeUpdate:@"ALTER TABLE Suser ADD time date"];
        }
    }];
}
//添加
- (void)addUser:(SXUser *)user{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet * s = [db executeQuery:@"SELECT Count(*) FROM Suser WHERE uid=?",user.uid];
        [s next];
        if ([s intForColumnIndex:0]) {
            NSLog(@"更新,%@",[s stringForColumn:@"name"]);
            [db executeUpdate:@"UPDATE Suser SET uid=?,name=?,des=?,time=? WHERE uid=?",user.uid,user.name,user.des,user.creatDate,user.uid];
        }else{
            NSLog(@"添加");
            [db executeUpdate:@"INSERT INTO Suser(uid,name,des,time) VALUES(?,?,?,?)",user.uid,user.name,user.des,user.creatDate];
        }
        [s close];
    }];
}
//指定删除
- (void)deleteUser:(NSString *)uid{
//    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//       [db executeUpdate:@"DELETE FROM Suser WHERE uid=?",uid];
//    }];
    [self deleteUsers:@[uid]];
}

- (void)deleteUsers:(NSArray *)uids{
    if (uids.count == 0) return;
    NSString * sql = nil;
    if (uids.count == 1) {
        sql = [NSString stringWithFormat:@"DELETE FROM Suser WHERE uid='%@'",[uids firstObject]];
    }else{
        //如果是字符串类型的。。 就是DELETE FROM Suser WHERE uid in ('1','2','3')
        NSString * uidStr = [uids componentsJoinedByString:@"','"];
        uidStr = [NSString stringWithFormat:@"'%@'",uidStr];
        sql = [NSString stringWithFormat:@"DELETE FROM Suser WHERE uid IN (%@)",uidStr];
    }
    if (sql) {
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:sql];
        }];
    }
}
//删除所有
- (void)deleteAllUser{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        [db executeUpdate:@"DROP TABLE Suser"]; //删除数据表
        [db executeUpdate:@"DELETE FROM Suser"];
    }];
}
//删除表
- (void)deleteTable{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"DROP TABLE Suser"]; //删除数据表
    }];
}

//删除过期用户
- (void)deleteExpireUser{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"DELETE FROM Suser WHERE time<?",[NSDate date]];
    }];
}
//获取所有user
- (void)userList:(void(^)(NSArray <SXUser *>*list))block{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableArray * list = @[].mutableCopy;
        FMResultSet *s = [db executeQuery:@"SELECT * FROM Suser"];
        while ([s next]) {
            SXUser * user = [[SXUser alloc] init];
            user.uid    = [s stringForColumn:@"uid"];
            user.name   = [s stringForColumn:@"name"];
            user.des    = [s stringForColumn:@"des"];
            user.creatDate = [s dateForColumn:@"time"];
            [list addObject:user];
        }
        [s close];
        !block?:block(list);
    }];
}
////删除表中前 x 条数据
//- (void)deleteUserTo:(NSUInteger)index{
//    NSString * sql = [NSString stringWithFormat:@"delete from Suser where (select count(uid) from Suser)> %zd and Id in (select Id from Suser order by Id ASC limit %zd)",index,index];
//    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        [db executeUpdate:sql];
//    }];
//}

#pragma mark --- 批量处理
//批量添加
- (void)addUsers:(NSArray <SXUser *>*)users{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            NSLog(@"批量添加开始");
            for (SXUser * user in users) {
                FMResultSet * s = [db executeQuery:@"SELECT Count(*) FROM Suser WHERE uid=?",user.uid];
                [s next];
                if ([s intForColumnIndex:0]) {
//                    NSLog(@"更新,%@",[s stringForColumn:@"name"]);
                    *rollback = ![db executeUpdate:@"UPDATE Suser SET uid=?,name=?,des=?,time=? WHERE uid=?",user.uid,user.name,user.des,user.creatDate,user.uid];
                }else{
//                    NSLog(@"添加");
                    *rollback = ![db executeUpdate:@"INSERT INTO Suser(uid,name,des,time) VALUES(?,?,?,?)",user.uid,user.name,user.des,user.creatDate];
                }
                [s close];
            }
        } @catch (NSException *exception) {
            *rollback = YES;
            NSLog(@"批量添加异常:%@",exception);
        } @finally {
            NSLog(@"批量添加完成");
        }
    }];
}
@end
