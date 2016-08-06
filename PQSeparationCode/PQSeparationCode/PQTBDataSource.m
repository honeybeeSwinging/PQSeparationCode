//
//  PQTBDataSource.m
//  PQSeparationCode
//
//  Created by codepgq on 16/8/6.
//  Copyright © 2016年 PQ. All rights reserved.
//

#import "PQTBDataSource.h"

typedef void(^CellConfigBlock)(id _Nullable cell, id _Nullable item);
@interface PQTBDataSource ()
//传入之后不允许用户在外面随意更改数据
@property (nonatomic,strong,readwrite) NSMutableArray * _Nullable valuesArray;
@property (nonatomic,copy) NSString * identifier;
@property (nonatomic,copy) CellConfigBlock cellConfigBlock;
@end

@implementation PQTBDataSource


+ (nonnull instancetype)dataSourceWith:(nullable NSArray *)values identifier:(nullable NSString *)identifier  cellConfigBlock:(nullable void(^)( id _Nullable cell,id _Nullable item))block{
    return [[self alloc]initWithDataSource:values identifier:identifier cellConfigBlock:block];
}
- (nonnull instancetype)initWithDataSource:(nullable NSArray *)values identifier:(nullable NSString *)identifier  cellConfigBlock:(nullable void(^)(id _Nullable cell,id _Nullable item))block
{
    self = [super init];
    if (self) {
        self.identifier = identifier ;
        self.valuesArray = [NSMutableArray arrayWithArray:values];
        self.cellConfigBlock = [block copy];
    }
    return self;
}

//提供方法更新，删除,获取
- (void)pq_insertValueWithItem:(NSInteger)item value:(id _Nullable)value{
//    if (item < self.valuesArray.count && ) {
//        
//    }
    [self.valuesArray insertObject:value atIndex:item];
}
- (void)pq_deleteValueWithItem:(NSInteger)item{
    [self.valuesArray removeObjectAtIndex:item];
}
- (id _Nullable)pq_valueWithItem:(NSInteger)item{
    if (item < self.valuesArray.count && item >= 0) {
        return self.valuesArray[item];
    }
    return nil;
}

- (void)pq_updateWithArray:(NSArray *)array{
    self.valuesArray = nil;
    self.valuesArray = [NSMutableArray arrayWithArray:array];
}

- (id _Nullable )itemWithIndexPath:(NSIndexPath *)indexPath{
    return self.valuesArray[indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.valuesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cell = [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
    id item = [self itemWithIndexPath:indexPath];
    self.cellConfigBlock(cell,item);
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.valuesArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end