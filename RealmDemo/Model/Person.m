//
//  Person.m
//  RealmDemo
//
//  Created by ray on 2016/12/28.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "Person.h"

@implementation Person

// 主键
+ (NSString *)primaryKey {
    return @"ID";
}

//设置属性默认值
+ (NSDictionary *)defaultPropertyValues{
    return @{
             @"ID":@"0"
             };
}

//设置忽略属性,即不存到realm数据库中
//+ (NSArray<NSString *> *)ignoredProperties {
//    return @[@"ID"];
//}

//一般来说,属性为nil的话realm不会会抛出异常,但是如果实现了这个方法的话,就只有name为nil会抛出异常
+ (NSArray *)requiredProperties {
    return @[@"name"];
}

//设置索引,可以加快检索的速度
+ (NSArray *)indexedProperties {
    return @[@"ID"];
}

- (instancetype)initWithID:(NSString *)ID {
    if (self == [super init]) {
        _ID = ID;
    }
    return self;
}



@end
