//
//  RLMRealm+Help.m
//  RealmDemo
//
//  Created by ray on 2016/12/29.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "RLMRealm+Help.h"

@implementation RLMRealm (Help)

const char *_Nullable writeLabel = "com.realmWrite.serialQueue";

- (NSOperationQueue *)operationQueue {
    static NSOperationQueue *operationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 1;//串行
//        operationQueue.isSuspended = true;
        operationQueue.qualityOfService = NSQualityOfServiceUtility;
        NSString *threadName = [NSString stringWithCString:writeLabel encoding:NSUTF8StringEncoding];
        operationQueue.name = threadName;
    });
    return operationQueue;
}

+ (void)writeWithBlock:(__attribute__((noescape)) void(^)(void))block inRealm:(__attribute__((noescape)) RLMRealm*(^)(void))realm {
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        NSString *threadName = [NSString stringWithCString:writeLabel encoding:NSUTF8StringEncoding];
        [[NSThread currentThread] setName:threadName];
        [realm() transactionWithBlock:block];
    }];
    [realm().operationQueue addOperation:blockOp];
}


+ (void)writeWithBlock:(__attribute__((noescape)) void(^)(void))block {
    RLMRealm * (^realm)(void);
    realm = ^(void){
        return [RLMRealm defaultRealm];
    };
    [RLMRealm writeWithBlock:block inRealm:realm];
    
    
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        NSString *threadName = [NSString stringWithCString:writeLabel encoding:NSUTF8StringEncoding];
        [[NSThread currentThread] setName:threadName];
        [[RLMRealm defaultRealm] transactionWithBlock:block];
    }];
    [[RLMRealm defaultRealm].operationQueue addOperation:blockOp];
}





@end
