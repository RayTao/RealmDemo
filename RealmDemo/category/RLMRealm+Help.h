//
//  RLMRealm+Help.h
//  RealmDemo
//
//  Created by ray on 2016/12/29.
//  Copyright © 2016年 ray. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMRealm (Help)


/**
 将realm写操作放入单独的串行队列里面
 
 请注意，如果在进程中存在多个写入操作的话，那么单个写入操作将会阻塞其余的写入操作，并且还会锁定该操作所在的当前线程。
 Realm这个特性与其他持久化解决方案类似，我们建议您使用该方案常规的最佳做法：将写入操作转移到一个独立的线程中执行
 */
+ (void)writeWithBlock:(__attribute__((noescape)) void(^)(void))block;
+ (void)writeWithBlock:(__attribute__((noescape)) void(^)(void))block inRealm:(__attribute__((noescape)) RLMRealm*(^)(void))realm;


@end
